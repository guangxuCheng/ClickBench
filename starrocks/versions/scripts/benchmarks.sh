#!/usr/bin/env bash

# Dataset contains 99997497 rows
mysql -h 127.0.0.1 -P9030 -uroot hits -e "SELECT count(*) FROM hits"

# Run queries
./run.sh 2>&1 | tee run.log

sed -r -e 's/query[0-9]+,/[/; s/$/],/' run.log
