CC=gcc
BIN=perf_exp
SRC=perf_exp.c

all:
	$(CC) -o $(BIN) -O2 -g $(SRC)

perf:
	sudo sh perf.sh

plot:
	gnuplot plot.gp

clean:
	rm $(BIN)