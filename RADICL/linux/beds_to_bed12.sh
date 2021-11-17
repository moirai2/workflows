#!/bin/bash
input_file1=$1; shift
input_file2=$1; shift
output_file=$1; shift

join -j 4 ${input_file1} ${input_file2} | awk 'BEGIN{OFS="\t"}{print $2,$3,$4,$1,$5,$6,$7,$8,$9,$1,$10,$11}' > ${output_file}

