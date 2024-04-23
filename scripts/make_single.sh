#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."
PIKCHR_ROOT="$PROJECT_ROOT/../pikchr-cmd"
PIKCHR_BIN="$PIKCHR_ROOT/pikchr"

TTC_ROOT="$PROJECT_ROOT/../typst-ts"
TTC_BIN="$TTC_ROOT/typst-ts/bin/typst-ts-cli"

POST_ROOT="$PROJECT_ROOT/content/posts"

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
    $TTC_BIN compile --workspace $POST_ROOT --entry "$1" --format pdf --format svg
    # $TTC_BIN compile --workspace $POST_ROOT --entry "$1" --dynamic-layout
    $TTC_BIN compile --workspace $POST_ROOT --entry "$1" --format vector
    # quarto typst compile "$1" --format svg --root $POST_ROOT
    # quarto typst compile "$1" --format pdf --root $POST_ROOT
elif [[ $1 == *.bib ]]; then
    pandoc "$1" -t csljson -o "${1%.*}.json"
fi
