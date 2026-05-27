# Build scripts

This blog mixes several heavy/slow generators (Julia, a Rust-built typst
compiler, diagram tools). GitHub Pages runs them all on every deploy. **tangled**
(`utensil.tngl.sh/blog`) does NOT — it has no such toolchain and a short, no-cache
CI — so we **freeze-split**: generate everything here (GitHub Actions or locally),
commit the artifacts, and let tangled do a toolchain-free assemble that reuses
them. See "How tangled builds it" below.

## Diagrams + dev

`make_all.sh` renders every `*.pikchr` / `*.d2` / `*.typ` under `content/posts`
via `make_single.sh`, then `check_all.sh` asserts the expected outputs exist:

- **`*.typ`** → `*.pdf` + `*.artifact.svg`, via **typst-ts-cli**
  (Myriad-Dreamin/typst.ts). This is NOT plain `typst`: the `.artifact.svg` is an
  interactive SVG for the typst.ts web renderer, embedded by the `show_typ`
  shortcode (`layouts/shortcodes/show_typ.html`) which fingerprints the `.pdf` +
  `.svg` as Hugo page resources. typst-ts-cli is a `cargo install --git`
  from-source build (slow, not in nixpkgs).
- **`*.d2`** → `*.d2.svg`, via [`d2`] (a Go binary, in nixpkgs).
- **`*.pikchr`** → `*.pikchr.svg`, via `pikchr` (tiny C tool built from source by
  `install_pikchr.sh` — zenomt/pikchr-cmd, `-b` SVG-fragment mode).

- `make_changed.sh` / `dev.sh` — incremental rebuild + live preview (watchexec).
- `install_pikchr.sh`, `install_typst_ts_cli.sh` — fetch/build the diagram binaries.

All of these outputs are **`.gitignore`d** (GitHub Pages regenerates them every
deploy). The freeze step force-adds them so tangled can reuse them.

## How to refresh the freeze

The freeze is the committed set of everything the heavy toolchain produces:

- Quarto's `_freeze/` cache **+** the `ca-in-julia` post's generated `index.md` +
  `*.mp4` (GLMakie animations). `execute.freeze: auto` in `_quarto.yml` lets a
  later `quarto render` reuse `_freeze/` with **no Julia**.
- the diagram/typst artifacts above (`*.d2.svg`, `*.pikchr.svg`,
  `*.artifact.svg`, typst `*.pdf`).

Refresh it whenever you change a Julia-touching post (`.qmd` / `Project.toml` /
`Manifest.toml`) or any `.typ` / `.d2` / `.pikchr` source:

1. Once per machine, prepare the toolchain (idempotent):
   ```sh
   ./scripts/setup-freeze-env.sh
   ```
   Installs pinned Julia 1.10.3 (juliaup) + the post's deps, and checks/installs
   Quarto 1.5.39, Hugo 0.125.2, and the diagram tools (d2, pikchr, typst-ts-cli).
   It prints anything it can't auto-install.

2. Regenerate the freeze (runs `make_all.sh` + `quarto render`):
   ```sh
   ./scripts/freeze.sh
   ```
   On macOS GLMakie uses the real display. On headless Linux run it under xvfb:
   `xvfb-run -a ./scripts/freeze.sh`. The script prints the exact `git add` line
   for all generated artifacts when it finishes.

3. Commit the result (everything generated is gitignored, so force-add it):
   ```sh
   git add _freeze/
   git add -f \
     content/posts/ca-in-julia/index.md \
     content/posts/ca-in-julia/lorenz.mp4 \
     content/posts/ca-in-julia/streamplot.mp4 \
     content/posts/transformer/transformer_layer.d2.svg \
     content/posts/transformer/transformer_layer.pikchr.svg \
     content/posts/typst-test/fibonacci.artifact.svg \
     content/posts/typst-test/example.artifact.svg \
     content/posts/typst-test/fibonacci.pdf \
     content/posts/typst-test/example.pdf
   ```

GitHub Actions does the same automatically: the **Refresh Quarto Freeze** workflow
(`.github/workflows/freeze.yml`) runs on push to the `freeze` branch (loop-guarded
so its own commit doesn't re-trigger) and on `workflow_dispatch` — it regenerates,
force-adds all the artifacts, commits "chore(blog): refresh Quarto freeze", and
pushes back to `freeze`.

## How tangled builds it

tangled renders off the committed freeze with **no Julia, typst, d2 or pikchr** —
just Quarto + Hugo. `.tangled/workflows/render.yml` (Spindle, `engine: nixery`,
triggered by push to `main`):

1. **Pins Hugo to 0.125.2** — the version GitHub Pages builds with. nixpkgs ships
   Hugo 0.152.x, which removed `echoParam` / `getJSON` and made `partial` lookups
   strict, breaking the pinned **PaperMod** + **hugo-cite** theme submodules. With
   0.125.2 the submodules stay **vanilla** and output matches GitHub. The release
   binary is a foreign glibc ELF, so the workflow `patchelf`s it for the NixOS
   container (no `/lib64` linker there).
2. `quarto render .` — reuses committed `_freeze/` (no Julia).
3. `hugo --minify` — uses the committed diagram/typst artifacts as page resources.
4. force-pushes `public/` to the `site` branch → served at `utensil.tngl.sh/blog`.

**Flow to update the live tangled site:** bring new content onto the `freeze`
branch → push to GitHub `freeze` (freeze.yml regenerates + commits artifacts) →
fast-forward that commit to tangled `main` (triggers render.yml → deploys to
`site`). GitHub `main` is intentionally NOT kept in lockstep — it keeps
regenerating everything fresh on each GH Pages deploy.

[`d2`]: https://d2lang.com
