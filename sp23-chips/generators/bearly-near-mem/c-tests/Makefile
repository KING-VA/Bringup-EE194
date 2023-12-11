CC = riscv64-unknown-elf-gcc

libgloss_specs := htif_nano.specs

CFLAGS := -std=c11 -specs=$(libgloss_specs) -O2 -fno-common -fno-builtin-printf -Wall -Wextra $(CFLAGS)
LDFLAGS := -static -specs=$(libgloss_specs) $(LDFLAGS)

EXECUTABLES = test-memcpy test-mac test-mac-add-saturate test-mac-add-saturate-negative
HEADERS = nearmemdma.h

.PHONY: all
all: $(patsubst %,%.riscv,$(EXECUTABLES))

.PHONY: clean
clean:
	rm -f *.riscv

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

%.riscv: %.o
	$(CC) $(LDFLAGS) -o $@ $<
