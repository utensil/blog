SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."
PIKCHR_ROOT="$PROJECT_ROOT/../pikchr-cmd"
PIKCHR_BIN="$PIKCHR_ROOT/pikchr"

$PROJECT_ROOT/scripts/install_pikchr.sh

cd $PROJECT_ROOT

PIKCHR_BIN=$PIKCHR_BIN find content/posts -name "*.pikchr" -exec sh -c '$PIKCHR_BIN -q -b < "$0" > "${0%}.svg"' {} \;

# If this fails, the following websites can generate SVGs from Pikchr manually:
# - https://pikchr-editor.insert-mode.dev/
# - https://kroki.io/
# - https://niolesk.top/