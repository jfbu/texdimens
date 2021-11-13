#!/bin/sh

for seed in 12380323 23683740 61911302 72465192
do
    etex '\def\RSEED{'$seed'}\input benchmark_allupdown_random.tex'
done

for seed in 2795649 67740550 70935444 92545313
do
    etex '\def\RSEED{'$seed'}\input benchmark_withunit_random.tex'
done
