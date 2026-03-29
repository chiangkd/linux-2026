set terminal pngcairo size 1000,600 enhanced font "Verdana,10"
set output 'l1_l2_cycle_analysis.png'

set datafile separator ","
set grid
set logscale x 10
set xlabel "Number of Nodes (Log Scale)"
set ylabel "Cycles spent on Misses"
set title "{/Bold L1 & L2 Miss (single pointer imple.)}" font ",14"

# L1/L2 Boundary
# 12400 P-core: L1D=48KB (~3,072 nodes), L2=1.25MB (~81920 nodes)
set arrow from 3072, graph 0 to 3072, graph 1 nohead lc rgb "red" dt 2 lw 2
set label "L1 Boundary" at 3100, graph 0.9

set arrow from 81920, graph 0 to 81920, graph 1 nohead lc rgb "red" dt 2 lw 2
set label "L2 Boundary" at 40000, graph 0.7

# Column8: Cycle_L1_Miss, Column 9: Cycle_L2_Miss
plot "perf_data.csv" using 1:8 with linespoints title "Cycles w/ L1 Miss" lw 2 pt 7 lc rgb "orange", \
     "perf_data.csv" using 1:9 with linespoints title "Cycles w/ L2 Miss" lw 2 pt 5 lc rgb "blue"