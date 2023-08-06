#!/bin/bash

# set -x
if [[ ! -d results ]]; then mkdir results; fi

echo -e "{
    \"system\": \"StarRocks\",
    \"date\": \"$(date '+%Y-%m-%d')\",
    \"machine\": \"$(sudo dmidecode -s system-product-name), 500gb gp2\",
    \"cluster_size\": 1,
    \"comment\": \"\",
    \"tags\": [\"C++\", \"column-oriented\", \"MySQL compatible\"],
    \"load_time\": 492,
    \"data_size\": 17233927256,
    \"result\": [
$(
    r=$(sed -r -e 's/query[0-9]+,/[/; s/$/],/' result.csv)
    echo "${r%?}"
)
    ]
}
" | tee results/"$(sudo dmidecode -s system-product-name).json"

