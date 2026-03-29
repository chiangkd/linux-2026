set terminal pngcairo size 1000,600 enhanced font "Verdana,10"
set output 'Cache_misses_analysis.png'

set datafile separator ","
set grid
# set logscale x 10
set xlabel "Number of Nodes"
set ylabel "Cache Misses"
set title "{/Bold Cache misses (Fast-Slow vs. Single)}" font ",14"

# L1/L2 Boundary
# 12400 P-core: L1D=48KB (~3,072 nodes), L2=1.25MB (~81920 nodes)
set arrow from 3072, graph 0 to 3072, graph 1 nohead lc rgb "black" dt 2 lw 1
set label "L1 Boundary" at 3100, graph 0.9

set arrow from 81920, graph 0 to 81920, graph 1 nohead lc rgb "black" dt 2 lw 1
set label "L2 Boundary" at 40000, graph 0.7

# Column8: Cycle_L1_Miss, Column 9: Cycle_L2_Miss
# plot "perf_data.csv" using 1:8 with linespoints title "Cycles w/ L1 Miss" lw 2 pt 7 lc rgb "orange", \
#     "perf_data.csv" using 1:9 with linespoints title "Cycles w/ L2 Miss" lw 2 pt 5 lc rgb "blue"

# Compare 2 csv 'Cycles'
# plot "perf_data_fast_slow_imple.csv" using 1:3 with linespoints title "Fast-Slow: Cycles" lw 2 pt 7 lc rgb "blue", \
#     "perf_data_single_pointer.csv" using 1:3 with linespoints title "Single Pointer: Cycles" lw 2 pt 5 lc rgb "red"

# Compare 2 csv 'IPC'
# plot "perf_data_fast_slow_imple.csv" using 1:4 with linespoints title "Fast-Slow: IPC" lw 2 pt 7 lc rgb "blue", \
#     "perf_data_single_pointer.csv" using 1:4 with linespoints title "Single Pointer: IPC" lw 2 pt 5 lc rgb "red"

# Compare 2 csv 'Cycle_L1_Miss'
# plot "perf_data_fs_l1_l2_miss.csv" using 1:2 with linespoints title "Fast-Slow: Cycles w/ L1 Miss" lw 2 pt 7 lc rgb "red", \
#     "perf_data_single_l1_l2_miss.csv" using 1:2 with linespoints title "Single Pointer: Cycles w/ L1 Miss" lw 2 pt 5 lc rgb "blue"

# Compare 2 csv 'Cycle_L2_Miss'
# plot "perf_data_fs_l1_l2_miss.csv" using 1:3 with linespoints title "Fast-Slow: Cycles w/ L2 Miss" lw 2 pt 7 lc rgb "red", \
#    "perf_data_single_l1_l2_miss.csv" using 1:3 with linespoints title "Single Pointer: Cycles w/ L2 Miss" lw 2 pt 5 lc rgb "blue"


# Set x-axis range
set xrange [0:500000]

# Compare 'Cache_Miss'
plot "perf_data_fs_find_middle.csv" using 1:2 with linespoints title "Fast-Slow: Cache Miss" lw 2 pt 7 lc rgb "red", \
   "perf_data_single_find_middle.csv" using 1:2 with linespoints title "Single Pointer: Cache MIss" lw 2 pt 5 lc rgb "blue"