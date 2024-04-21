SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."

for pattern in '*.pikchr' '*.d2' '*.typ'; do
    find content/posts -name "$pattern" -exec sh -c './scripts/make_single.sh $0' {} \;
done

./scripts/check_all.sh
