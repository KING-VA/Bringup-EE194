CFLAGS := -std=c11 -Iinclude -Wall -Wextra $(CFLAGS)

lib_srcs = nearmemdma.c

default: build/libnearmemdma.a

build/lib/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/libnearmemdma.a: $(patsubst %.c,build/lib/%.o,$(lib_srcs))
	$(AR) rcs $@ $^