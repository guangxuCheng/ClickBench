#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <pid> <query_index>"
    exit 1
fi

pid=$1
query_index=$2
echo "get perf query: $2"

script_dir=$(dirname "$0")
queries_file="$script_dir/queries.sql"
mapfile -t sql_queries < "$queries_file"

selected_query=${sql_queries[$((query_index - 1))]}

perf record -e cpu-clock -g -p $pid &
perf_pid=$!

duration=10
end_time=$((SECONDS + duration))

while [ $SECONDS -lt $end_time ]
do
    mysql -h 127.0.0.1 -P9030 -uroot -D hits -e "$selected_query" >/dev/null
done

kill -INT $perf_pid

wait $perf_pid

exit_status=$?

if [ $exit_status -ne 0 ] && [ $exit_status -ne 130 ]; then
    echo "Error: 'perf record' command did not terminate correctly, exit_status=$exit_status"
    exit 1
fi

perf script -i perf.data &> perf.unfold
./FlameGraph/stackcollapse-perf.pl perf.unfold &> perf.folded
./FlameGraph/flamegraph.pl perf.folded > perf.svg

mv perf.svg clickbench_${query_index}.html

rm perf.data perf.unfold perf.folded perf.data.old
