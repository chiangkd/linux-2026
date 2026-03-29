#!/bin/bash
DATA_FILE="perf_data.csv"
# echo "Nodes,Insts,Cycles,IPC,L1_Miss,Stall_L1,Stall_L2,Cycle_L1_Miss,Cycle_L2_Miss,L1_Cache_Miss,L1_Loads,L2 Reference, L2_Cache_Miss" > $DATA_FILE

# echo "L1_Cache_Miss,L1_Loads,L2 Reference, L2_Cache_Miss" > $DATA_FILE
echo "Nodes,Cache_Miss,L1_Cache_Miss,L2_Cache_Miss" > $DATA_FILE


for size in 500 1000 5000 8000 10000 20000 30000 50000 70000 90000 100000 300000 500000 700000 900000; do
    echo "Testing Size: $size..."

    # perf
    RAW_PERF=$(sudo perf stat -x, --repeat 5 -e instructions,\
cache-misses,\
L1-dcache-load-misses,\
l2_rqsts.miss,\
l2_rqsts.references ./perf_exp $size 2>&1)

    INSTs=$(echo "$RAW_PERF" | grep "instructions" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    CYCLES=$(echo "$RAW_PERF" | grep "cycles" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    
    # IPC
    IPC=$(echo "$RAW_PERF" | grep "instructions" | awk -F, '{for(i=1;i<=NF;i++) if($i ~ /insn per cycle/) print $(i-1)}' | xargs)
    CACHE_MISS=$(echo "$RAW_PERF" | grep "cache-misses" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')

    # L1_MISS=$(echo "$RAW_PERF" | grep "L1-dcache-load-misses" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    # STALL_L1=$(echo "$RAW_PERF" | grep "cycle_activity.stalls_l1d_miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    # STALL_L2=$(echo "$RAW_PERF" | grep "cycle_activity.stalls_l2_miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    # CYC_L1M=$(echo "$RAW_PERF" | grep "cycle_activity.cycles_l1d_miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    # CYC_L2M=$(echo "$RAW_PERF" | grep "cycle_activity.cycles_l2_miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')

    L1_MISS=$(echo "$RAW_PERF" | grep "L1-dcache-load-misses" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    L1_LOADS=$(echo "$RAW_PERF" | grep "L1-dcache-loads" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    L2_MISS=$(echo "$RAW_PERF" | grep "l2_rqsts.miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    L2_REF=$(echo "$RAW_PERF" | grep "l2_rqsts.references" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    # printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" \
    #     "$size" "$INSTs" "$CYCLES" "$IPC" "$STALL_L1" "$STALL_L2" "$CYC_L1M" "$CYC_L2M" "$L1_MISS" "$L1_LOADS" "$L2_MISS" "$L2_REF" >> $DATA_FILE
    # printf "%s %s,%s,%s,%s\n" \
    #     "$size" "$L1_MISS" "$L1_LOADS" "$L2_MISS" "$L2_REF" >> $DATA_FILE
    printf "%s,%s,%s,%s\n" \
        "$size" "$CACHE_MISS" "$L1_MISS" "$L2_MISS">> $DATA_FILE
    # Terminal
    echo "Done Size $size: IPC=$IPC"
done

echo "Finished! Data saved to $DATA_FILE"