while IFS= read -r line; do
    IFS=':' read -ra ADDR <<< "$line"
    ./scripts/make_single.sh "${ADDR[1]}"
done
