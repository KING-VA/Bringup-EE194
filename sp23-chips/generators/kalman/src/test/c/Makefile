#
# Makefile for TinyEKF GPS example
#
# Copyright (C) 2015 Simon D. Levy
#
# MIT License

SRC = ./

ifeq ($(SOFTWARE), 1)
    CFLAGS+=-DSOFTWARE
endif

all: gps_ekf

run: gps_ekf
	./gps_ekf

gps_ekf: gps_ekf.c $(SRC)/tiny_ekf.c $(SRC)/tiny_ekf.h
	gcc -Wall -I. -I$(SRC) -o gps_ekf gps_ekf.c $(SRC)/tiny_ekf.c -lm $(CFLAGS)

edit:
	vim gps_ekf.c

clean:
	rm -f gps_ekf *.o *~ ekf.csv
