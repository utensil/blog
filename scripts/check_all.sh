SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."

check_single() {
    if [ ! -e "$1" ]; then
        echo "Error: $1 not found"
        exit 1
    fi
}

check_single "$PROJECT_ROOT/content/posts/transformer/transformer_layer.d2.svg"
check_single "$PROJECT_ROOT/content/posts/transformer/transformer_layer.pikchr.svg"
check_single "$PROJECT_ROOT/content/posts/typst-test/main.artifact.svg"