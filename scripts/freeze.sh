#!/bin/bash
# Shared, env-agnostic freeze step.
#
# Renders diagrams + executes the Quarto project (incl. the Julia post) so that
# Quarto writes its `_freeze/` cache and the generated media. Tangled later does
# a Julia-FREE `quarto render` reusing this committed `_freeze/` (freeze: auto).
#
# This script installs NOTHING. Prepare the toolchain first with
# scripts/setup-freeze-env.sh (locally) or the freeze.yml workflow (CI).
#
# Usage:
#   ./scripts/freeze.sh          # macOS / display present
#   xvfb-run -a ./scripts/freeze.sh   # headless Linux (GLMakie needs OpenGL)
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT="$SCRIPT_DIR/.."
cd "$PROJECT_ROOT"

echo "==> Building diagrams (pikchr / d2 / typst)"
./scripts/make_all.sh

echo "==> Rendering Quarto project (executes Julia, writes _freeze/ + media)"
quarto render .

echo "==> _freeze/ status"
if [ -d _freeze ]; then
    git status --short -- _freeze/ || true
    echo "    _freeze/ tracked files: $(git ls-files _freeze/ | wc -l | tr -d ' ')"
else
    echo "    WARNING: _freeze/ was not created by quarto render"
fi

# All generated artifacts are gitignored; tangled reuses them (no Julia / typst
# / d2 / pikchr toolchain there), so they MUST be force-added when freezing.
ARTIFACTS=(
    content/posts/ca-in-julia/index.md
    content/posts/ca-in-julia/lorenz.mp4
    content/posts/ca-in-julia/streamplot.mp4
    content/posts/transformer/transformer_layer.d2.svg
    content/posts/transformer/transformer_layer.pikchr.svg
    content/posts/typst-test/fibonacci.artifact.svg
    content/posts/typst-test/example.artifact.svg
    content/posts/typst-test/fibonacci.pdf
    content/posts/typst-test/example.pdf
)

echo "==> Generated artifact status (gitignored; commit with: git add -f <path>)"
git status --short --ignored -- "${ARTIFACTS[@]}" || true

echo "Done. Review changes, then:"
echo "    git add _freeze/ && git add -f ${ARTIFACTS[*]}"
