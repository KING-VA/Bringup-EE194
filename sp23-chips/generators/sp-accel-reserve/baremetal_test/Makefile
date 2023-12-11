# Add <executable name> to the EXECUTABLES list, where <executable name>.c exists


EXECUTABLES= test-under-then-over test-overflow test-underflow test-no-fense test-comprehensive test-sanity test-correctness test-true-perf test-perf 
CC=riscv64-unknown-elf-gcc
CFLAGS=-fno-common -fno-builtin-printf -specs=htif_nano.specs
LDFLAGS=-static

.PHONY: all clean

all: $(EXECUTABLES)

% :: %.c 
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

test-all: $(EXECUTABLES)
	bash test-all.sh $(EXECUTABLES)

# compile:
# 	riscv64-unknown-elf-gcc -fno-common -fno-builtin-printf -specs=htif_nano.specs -c test.c
# 	riscv64-unknown-elf-gcc -static -specs=htif_nano.specs test.o -o test

clean:
	rm -f $(EXECUTABLES) *.o

