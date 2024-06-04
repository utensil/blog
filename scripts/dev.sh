#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."

cd $PROJECT_ROOT

# watchexec --ignore-nothing -vvv --project-origin . -w content/posts/math-2024 -e d2,pikchr,typ,bib --only-emit-events --emit-events-to json-stdio --print-events --notify --poll 500ms
watchexec --project-origin . --on-busy-update queue --poll 500ms -e d2,pikchr,typ,bib --emit-events-to=stdio -- ./scripts/make_changed.sh &

quarto preview --execute-debug --no-serve --no-browser --render all &

watchexec --project-origin . --restart --poll 500ms -e qmd -- hugo serve --port 1313 -w --forceSyncStatic --disableFastRender --ignoreCache --noHTTPCache & # --gc --cleanDestinationDir

wait
