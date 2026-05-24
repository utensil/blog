#!/bin/bash
# Prepare the toolchain so scripts/freeze.sh runs fast. Idempotent:
# detect-then-install. Designed for local macOS use (operator) but also
# works on Ubuntu CI (freeze.yml).
#
# Pinned versions match .github/workflows/gh-pages.yml:
#   Julia 1.10.3 | Quarto 1.5.39 | Hugo 0.125.2 (extended) | typst-ts-cli v0.4.1
#
# After this finishes, run:  ./scripts/freeze.sh   (xvfb-run -a on headless Linux)
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT="$SCRIPT_DIR/.."
cd "$PROJECT_ROOT"

JULIA_VERSION="1.10.3"
QUARTO_VERSION="1.5.39"
HUGO_VERSION="0.125.2"

MISSING_MANUAL=()

have() { command -v "$1" >/dev/null 2>&1; }

is_mac() { [ "$(uname -s)" = "Darwin" ]; }

# ---------------------------------------------------------------------------
# Julia 1.10.3 via juliaup
# ---------------------------------------------------------------------------
echo "==> Julia $JULIA_VERSION (juliaup)"
if ! have juliaup; then
    echo "    juliaup not found; installing"
    if is_mac && have brew; then
        brew install juliaup
    else
        curl -fsSL https://install.julialang.org | sh -s -- --yes
        export PATH="$HOME/.juliaup/bin:$PATH"
    fi
fi

if have juliaup; then
    juliaup add "$JULIA_VERSION" || true
    juliaup default "$JULIA_VERSION" || true
else
    MISSING_MANUAL+=("juliaup/julia $JULIA_VERSION — install from https://github.com/JuliaLang/juliaup")
fi

# ---------------------------------------------------------------------------
# Julia project deps for the ca-in-julia post
# ---------------------------------------------------------------------------
if have julia; then
    echo "==> Instantiate + precompile content/posts/ca-in-julia (Julia $JULIA_VERSION)"
    julia +"$JULIA_VERSION" --project=content/posts/ca-in-julia \
        -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()' \
        || julia --project=content/posts/ca-in-julia \
            -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'
else
    echo "    Skipping Julia instantiate (julia not on PATH yet — re-run after juliaup PATH is active)"
fi

# ---------------------------------------------------------------------------
# Quarto 1.5.39
# ---------------------------------------------------------------------------
echo "==> Quarto $QUARTO_VERSION"
if have quarto; then
    echo "    found: $(quarto --version)"
else
    if is_mac && have brew; then
        brew install --cask quarto
        echo "    NOTE: brew installs latest Quarto, not pinned $QUARTO_VERSION."
        echo "          For an exact pin, download from https://github.com/quarto-dev/quarto-cli/releases/tag/v$QUARTO_VERSION"
    else
        MISSING_MANUAL+=("quarto $QUARTO_VERSION — https://github.com/quarto-dev/quarto-cli/releases/tag/v$QUARTO_VERSION")
    fi
fi

# ---------------------------------------------------------------------------
# Hugo 0.125.2 (extended)
# ---------------------------------------------------------------------------
echo "==> Hugo $HUGO_VERSION (extended)"
if have hugo; then
    echo "    found: $(hugo version)"
else
    if is_mac && have brew; then
        brew install hugo
        echo "    NOTE: brew installs latest Hugo, not pinned $HUGO_VERSION."
    else
        MISSING_MANUAL+=("hugo $HUGO_VERSION extended — https://github.com/gohugoio/hugo/releases/tag/v$HUGO_VERSION")
    fi
fi

# ---------------------------------------------------------------------------
# Diagram tools: d2, pikchr, typst-ts-cli
# ---------------------------------------------------------------------------
echo "==> d2"
if have d2; then
    echo "    found: $(d2 --version 2>/dev/null || echo present)"
elif have brew; then
    brew install d2
else
    MISSING_MANUAL+=("d2 — curl -fsSL https://d2lang.com/install.sh | sh -s --")
fi

echo "==> pikchr (built via scripts/install_pikchr.sh into ../pikchr-cmd)"
# install_pikchr.sh clones zenomt/pikchr-cmd and `make all`; needs git + make + cc.
if have make && have cc && have git; then
    ./scripts/install_pikchr.sh || MISSING_MANUAL+=("pikchr — scripts/install_pikchr.sh failed; build zenomt/pikchr-cmd manually")
else
    MISSING_MANUAL+=("pikchr — needs git+make+cc, then run scripts/install_pikchr.sh")
fi

TTC_HINT="v0.4.1"
echo "==> typst-ts-cli $TTC_HINT (make_single.sh calls bare 'typst-ts-cli' on PATH)"
if have typst-ts-cli; then
    echo "    found on PATH"
elif have cargo; then
    echo "    installing via cargo (matches gh-pages.yml)"
    cargo install --locked --git https://github.com/Myriad-Dreamin/typst.ts typst-ts-cli \
        || MISSING_MANUAL+=("typst-ts-cli — cargo install failed; see scripts/install_typst_ts_cli.sh for prebuilt $TTC_HINT")
else
    MISSING_MANUAL+=("typst-ts-cli $TTC_HINT — either 'cargo install --git https://github.com/Myriad-Dreamin/typst.ts typst-ts-cli', or run scripts/install_typst_ts_cli.sh and add ../typst-ts/typst-ts/bin to PATH")
fi

# ---------------------------------------------------------------------------
# Python deps (Quarto/Hugo helpers per gh-pages.yml requirements.txt)
# ---------------------------------------------------------------------------
if [ -f requirements.txt ]; then
    echo "==> Python deps (requirements.txt)"
    if have pip; then
        pip install -r requirements.txt || MISSING_MANUAL+=("python deps — pip install -r requirements.txt failed")
    elif have pip3; then
        pip3 install -r requirements.txt || MISSING_MANUAL+=("python deps — pip3 install -r requirements.txt failed")
    else
        MISSING_MANUAL+=("python deps — pip not found; pip install -r requirements.txt")
    fi
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
if [ ${#MISSING_MANUAL[@]} -eq 0 ]; then
    echo "==> Environment ready. Next: ./scripts/freeze.sh"
else
    echo "==> Environment mostly ready, but install these MANUALLY:"
    for item in "${MISSING_MANUAL[@]}"; do
        echo "    - $item"
    done
    echo "    Then: ./scripts/freeze.sh"
fi

if ! is_mac; then
    echo "    (Headless Linux: GLMakie needs OpenGL — run freeze via 'xvfb-run -a ./scripts/freeze.sh')"
fi
