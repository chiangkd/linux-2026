set terminal pngcairo size 1000,600 enhanced font 'Verdana,10'
set output 'linked_list_perf.png'

# Set title
set title "Linked List Cache Miss Rate (No shuffle) vs List Size" font "Verdana, 18"

set datafile separator ","
set grid
set logscale x 10
set xlabel "Number of Nodes (Log Scale)"

# --- Cache Misses ---
set ylabel "Cache Misses" tc rgb "blue"
set format y "%.0s%c"

# --- IPC ---
set y2label "Instructions Per Cycle (IPC)" tc rgb "red"
set y2tics
set y2range [0:4]      # IPC range

# --- L2 Cache Boundary (1.25MB is about 81,920 nodes) ---
set arrow from 81920, graph 0 to 81920, graph 1 nohead lc rgb "black" dt 2 lw 2
set label "L2 Cache Boundary (1.25MB)" at 82000, graph 0.1 tc rgb "black"

# --- L3 Cache Boundary (18MB is about 1.1M nodes) ---
set arrow from 1179648, graph 0 to 1179648, graph 1 nohead lc rgb "black" dt 2 lw 2
set label "L3 Cache Boundary (18MB)" at 1200000, graph 0.1 tc rgb "black"

# --- plot ---
# Column 3: Misses, Column 6: IPC
plot "perf_data.csv" using 1:3 with linespoints title "Cache Misses" axis x1y1 lw 2 pt 7 lc rgb "blue", \
     "perf_data.csv" using 1:6 with linespoints title "IPC" axis x1y2 lw 2 pt 5 lc rgb "red"