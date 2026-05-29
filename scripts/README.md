# Build scripts

## Diagrams + dev

- `make_all.sh` — render every `*.pikchr` / `*.d2` / `*.typ` under `content/posts`
  via `make_single.sh`, then `check_all.sh` asserts the expected SVGs exist.
- `make_changed.sh` / `dev.sh` — incremental rebuild + live preview (watchexec).
- `install_pikchr.sh`, `install_typst_ts_cli.sh` — fetch the diagram binaries.

## How the blog is rendered

Two independent lanes, no cross-deps:

- **github.io lane** — `.github/workflows/gh-pages.yml` does a LIVE render on
  GitHub Actions (`julia-actions/setup-julia` + `xvfb-run quarto/hugo`) and
  publishes to `https://utensil.github.io/blog/`.
- **tngl.sh lane** — `.tangled/workflows/{build-depot,render}.yml` runs on
  tangled's Spindle: `build-depot.yml` pre-builds the precompiled Julia depot
  + render-env closure (nix flake at repo root) and uploads to Cloudflare R2;
  `render.yml` pulls them via `manifest.json` and renders LIVE under Xvfb,
  publishing to the `site` branch → `https://utensil.tngl.sh/blog/`.

No freeze step is needed any more — the `ca-in-julia` Julia post executes on
both lanes, and `_freeze/` is no longer relied upon. Quarto's `freeze: auto`
remains on (in `_quarto.yml`) for cheap local re-renders only.
