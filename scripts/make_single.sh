SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."
PIKCHR_ROOT="$PROJECT_ROOT/../pikchr-cmd"
PIKCHR_BIN="$PIKCHR_ROOT/pikchr"

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

# Test with
# ./scripts/make_single.sh content/posts/transformer/transformer_layer.d2
# ./scripts/make_single.sh content/posts/transformer/transformer_layer.pikchr
# ./scripts/make_single.sh content/posts/typst-test/main.typ

if [ ! -z "$1" ]; then
    echo "Making $1"
fi

cd $PROJECT_ROOT

if [[ $1 == *.d2 ]]; then
    d2 "$1" "${1%}.svg"
elif [[ $1 == *.pikchr ]]; then
    $PROJECT_ROOT/scripts/install_pikchr.sh
    $PIKCHR_BIN -q -b < "$1" > "${1%}.svg"
elif [[ $1 == *.typ ]]; then
    $PROJECT_ROOT/scripts/install_typst_ts_cli.sh
    $TTC_BIN compile --entry "$1" --format svg --format pdf
fi
