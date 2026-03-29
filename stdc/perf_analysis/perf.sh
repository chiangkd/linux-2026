#!/bin/bash
DATA_FILE="perf_data.csv"
echo "Nodes,References,Misses,Instructions,Cycles,IPC" > $DATA_FILE

for size in 1000 10000 100000 1000000 10000000; do
    echo "Testing Size: $size..."

    # perf
    RAW_PERF=$(sudo perf stat -x, -e cache-references,cache-misses,instructions,cycles ./perf_exp $size 2>&1)

    REFS=$(echo "$RAW_PERF" | grep "cache-references" | cut -d',' -f1)
    MISSES=$(echo "$RAW_PERF" | grep "cache-misses" | cut -d',' -f1)    
    INSTs=$(echo "$RAW_PERF" | grep "instructions" | cut -d',' -f1)
    CYCLES=$(echo "$RAW_PERF" | grep "cycles" | cut -d',' -f1)
    
    # Fetch IPC
    IPC=$(echo "$RAW_PERF" | grep "instructions" | awk -F, '{for(i=1;i<=NF;i++) if($i ~ /insn per cycle/) print $(i-1)}' | xargs)

    echo "$size,$REFS,$MISSES,$INSTs,$CYCLES,$IPC" >> $DATA_FILE

    # Show on terminal
    printf "%-10s %-12s %-10s %-10s %-12s %-12s %-5s\n" \
           "$size" "$REFS" "$MISSES" "$INSTS" "$CYCLES" "$IPC"

done

echo "Done! Check perf_data.csv"