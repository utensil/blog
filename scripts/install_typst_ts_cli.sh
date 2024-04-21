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

mkdir -p $TTC_ROOT

cd $TTC_ROOT

if [ ! -e $TTC_BIN ]; then
    if [ ! -e $TTC_TAR ]; then
        echo "Downloading typst-ts-cli"
        wget $TTC_URL -O $TTC_TAR
    fi

    echo "Installing typst-ts-cli"

    tar -xzvf $TTC_TAR
fi

if [ ! -e $TTC_BIN ]; then
    echo "Error: typst-ts-cli binary not found and failed to install"
    exit 1
fi

cd $PROJECT_ROOT
