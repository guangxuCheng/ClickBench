#!/bin/bash

VERSION=$1
# set -x
if [[ ! -d results ]]; then mkdir results; fi

echo -e "{
    \"version\": \"'$VERSION'\",
    \"result\": [
$(
    r=$(sed -r -e 's/query[0-9]+,/[/; s/$/],/' ../result.csv)
    echo "${r%?}"
)
    ]
}
" | tee results/"$VERSION.json"

