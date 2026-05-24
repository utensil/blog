# Build scripts

## Diagrams + dev

- `make_all.sh` — render every `*.pikchr` / `*.d2` / `*.typ` under `content/posts`
  via `make_single.sh`, then `check_all.sh` asserts the expected SVGs exist.
- `make_changed.sh` / `dev.sh` — incremental rebuild + live preview (watchexec).
- `install_pikchr.sh`, `install_typst_ts_cli.sh` — fetch the diagram binaries.

## How to refresh the freeze

The `ca-in-julia` post executes Julia (GLMakie animations), which is too heavy
for tangled's short, no-cache CI. So we **freeze** that execution: Quarto's
`_freeze/` cache (plus the generated `index.md` and `*.mp4`) is committed, and
tangled does a Julia-**free** `quarto render` that reuses it (`freeze: auto` in
`_quarto.yml`).

Refresh the freeze whenever you change a Julia-touching post (its `.qmd`,
`Project.toml`, or `Manifest.toml`):

1. Once per machine, prepare the toolchain (idempotent):
   ```sh
   ./scripts/setup-freeze-env.sh
   ```
   Installs pinned Julia 1.10.3 (juliaup) + the post's deps, and checks/installs
   Quarto 1.5.39, Hugo 0.125.2, and the diagram tools (d2, pikchr, typst-ts-cli).
   It prints anything it can't auto-install.

2. Before committing the change, regenerate the freeze:
   ```sh
   ./scripts/freeze.sh
   ```
   On macOS GLMakie uses the real display. On headless Linux run it under xvfb:
   `xvfb-run -a ./scripts/freeze.sh`.

3. Commit the result (generated media is gitignored, so force-add it):
   ```sh
   git add _freeze/
   git add -f content/posts/ca-in-julia/index.md \
              content/posts/ca-in-julia/lorenz.mp4 \
              content/posts/ca-in-julia/streamplot.mp4
   ```

GitHub Actions does the same automatically: the **Refresh Quarto Freeze**
workflow (`.github/workflows/freeze.yml`) runs on `workflow_dispatch`, on push
to the `freeze` branch, and when a `.qmd` / `Project.toml` / `Manifest.toml`
changes — it commits "chore(blog): refresh Quarto freeze" and pushes.

**Tangled never runs Julia.** It only renders off the committed `_freeze/`.
