#!/bin/bash

riscv64-unknown-elf-gcc -fno-common -fno-builtin-printf -specs=htif_nano.specs -c prefetcher_ci.c
riscv64-unknown-elf-gcc -static -specs=htif_nano.specs prefetcher_ci.o -o prefetcher_ci.riscv

cd ../../../sims/vcs

make CONFIG=BearlyConfig run-binary BINARY=../../bringup-software/bar-prefetchers/CI/prefetcher_ci.riscv

cd output/chipyard.TestHarness.BearlyConfig

if grep -Fq "*** PASSED ***" ./prefetcher_ci.out
then
    echo "CI Passed!"
    exit 0
else
    echo "CI Failed"
    exit 1
fi