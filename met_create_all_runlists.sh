#!/bin/bash

output_path=$1

for num in `seq 1 4`; do
    echo "sym"${num} > ${output_path}/sym${num}_runlist.txt
    echo "sym"${num}_redo > ${output_path}/sym${num}_redo_runlist.txt
    echo "grid"${num} > ${output_path}/grid${num}_runlist.txt
    echo "resting" > ${output_path}/resting_runlist.txt
done


