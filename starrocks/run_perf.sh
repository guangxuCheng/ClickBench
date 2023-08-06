#!/bin/bash

# 获取入参
a=$1
b=$2

if [ ! -d "FlameGraph" ]; then
  git clone https://github.com/brendangregg/FlameGraph.git
fi

pid=$(ps aux | grep starrocks_be | grep -v grep | awk '{print $2}')

mkdir profile
# 执行 get_perf_10s.sh 脚本 b-a 次
for ((i=$a; i<=$b; i++))
do
  ./get_perf_10s.sh $pid $i
done
