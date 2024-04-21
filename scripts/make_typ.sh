SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."
TTC_ROOT="$PROJECT_ROOT/../typst-ts"

TTC_VER="v0.4.1"
TTC_ARCH=`uname -m`
TTC_OS='apple-darwin'

if [[ "$(uname -o)" == *"Linux"* ]]; then
    TTC_OS='unknown-linux-gnu'
fi

TTC_TAR="$TTC_ROOT/typst-ts-$TTC_ARCH-$TTC_OS.tar.gz"
TTC_BIN="$TTC_ROOT/typst-ts-$TTC_ARCH-$TTC_OS/bin/typst-ts-cli"
TTC_URL="https://github.com/Myriad-Dreamin/typst.ts/releases/download/$TTC_VER/typst-ts-$TTC_ARCH-$TTC_OS.tar.gz"

./scripts/install_typst_ts_cli.sh

cd $PROJECT_ROOT

TTC_BIN=$TTC_BIN find content/posts -name "*.typ" -exec sh -c '$TTC_BIN compile --entry "$0" --format svg --format pdf' {} \;

# If this fails, the following websites can generate SVGs from Pikchr manually:
# - https://pikchr-editor.insert-mode.dev/
# - https://kroki.io/
# - https://niolesk.top/