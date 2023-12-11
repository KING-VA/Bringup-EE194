CC = riscv64-unknown-elf-gcc

libgloss_specs := htif_nano.specs


CFLAGS := -std=gnu11 -specs=$(libgloss_specs) -specs=htif_argv.specs -O2 -fno-common -fno-builtin-printf -Wall -Wextra -lm $(CFLAGS)
LDFLAGS := -specs=$(libgloss_specs) -specs=htif_argv.specs -static  $(LDFLAGS) 

EXECUTABLES = basic nothing gps_ekf load_store dot_product add sub mul matmul_benchmark matmul_benchmark_hardware
HEADERS = ""

ifeq ($(SOFTWARE), 1)
    CFLAGS+=-DSOFTWARE
endif

.PHONY: all
all: $(patsubst %,%.riscv,$(EXECUTABLES))

.PHONY: clean
clean:
	rm -f *.riscv

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

%.riscv: %.o
	$(CC) $(LDFLAGS) -o $@ $< tiny_ekf.c -lm

