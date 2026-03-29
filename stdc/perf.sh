for size in 1000 10000 100000 1000000 10000000; do
    echo "========================================"
    echo "--- Testing Size: $size nodes ---"
    perf stat -e cache-references,cache-misses,instructions,cycles ./perf_exp $size
done