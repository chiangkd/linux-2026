#!/bin/bash
DATA_FILE="perf_data.csv"
# 寫入表頭
echo "Nodes,Insts,Cycles,IPC,L1_Miss,Stall_L1,Stall_L2,Cycle_L1_Miss,Cycle_L2_Miss" > $DATA_FILE

for size in 1000 5000 8000 10000 20000 30000 50000 70000 90000 100000; do
    echo "Testing Size: $size..."

    # perf
    RAW_PERF=$(sudo perf stat -x, --repeat 5 -e instructions,cycles,L1-dcache-load-misses,cycle_activity.stalls_l1d_miss,cycle_activity.stalls_l2_miss,cycle_activity.cycles_l1d_miss,cycle_activity.cycles_l2_miss ./perf_exp $size 2>&1)

    INSTs=$(echo "$RAW_PERF" | grep "instructions" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    CYCLES=$(echo "$RAW_PERF" | grep "cycles" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    
    # IPC
    IPC=$(echo "$RAW_PERF" | grep "instructions" | awk -F, '{for(i=1;i<=NF;i++) if($i ~ /insn per cycle/) print $(i-1)}' | xargs)

    L1_MISS=$(echo "$RAW_PERF" | grep "L1-dcache-load-misses" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    STALL_L1=$(echo "$RAW_PERF" | grep "cycle_activity.stalls_l1d_miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    STALL_L2=$(echo "$RAW_PERF" | grep "cycle_activity.stalls_l2_miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    CYC_L1M=$(echo "$RAW_PERF" | grep "cycle_activity.cycles_l1d_miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')
    CYC_L2M=$(echo "$RAW_PERF" | grep "cycle_activity.cycles_l2_miss" | head -n1 | cut -d',' -f1 | tr -d ' \n\r')

    printf "%s,%s,%s,%s,%s,%s,%s,%s,%s\n" \
        "$size" "$INSTs" "$CYCLES" "$IPC" "$L1_MISS" "$STALL_L1" "$STALL_L2" "$CYC_L1M" "$CYC_L2M" >> $DATA_FILE

    # Terminal
    echo "Done Size $size: IPC=$IPC"
done

echo "Finished! Data saved to $DATA_FILE"