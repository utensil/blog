SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."
PIKCHR_ROOT="$PROJECT_ROOT/../pikchr-cmd"
PIKCHR_BIN="$PIKCHR_ROOT/pikchr"

cd $PROJECT_ROOT

if [ ! -e $PIKCHR_BIN ]; then
    git clone https://github.com/zenomt/pikchr-cmd $PIKCHR_ROOT
    cd $PIKCHR_ROOT
    make all
fi

cd $PROJECT_ROOT

if [ ! -e $PIKCHR_BIN ]; then
    echo "Error: pikchr binary not found and failed to install"
    exit 1
fi

PIKCHR_BIN=$PIKCHR_BIN find content/posts -name "*.pikchr" -exec sh -c '$PIKCHR_BIN -q -b < "$0" > "${0%}.svg"' {} \;

# If this fails, the following websites can generate SVGs from Pikchr manually:
# - https://pikchr-editor.insert-mode.dev/
# - https://kroki.io/
# - https://niolesk.top/