#!/bin/bash

set -eo pipefail

echo ""
echo "STARTING TESTS"
echo ""


declare -A versions
versions["requests"]="2.22.0"
versions["anyjson"]="0.3.3"
versions["Babel"]="2.2.0"
versions["certifi"]="2019.6.16"
versions["chardet"]="3.0.4"
versions["idna"]="2.8"
versions["pytz"]="2015.7"
versions["tornado"]="4.2"
versions["urllib3"]="1.25.3"
versions["vine"]="1.3.0"
versions["celery"]="3.1.19"
versions["kombu"]="3.0.37"
versions["amqp"]="1.4.9"
versions["billiard"]="3.3.0.23"
versions["importlib-metadata"]="1.1.0"
versions["zipp"]="0.6.0"
versions["more-itertools"]="8.0.2"


test_count=5
declare -A err

function handle_errors {
    local k

    if [[ ${#err[@]} -eq 0 ]]; then
        return
    fi

    echo "FAIL"
    echo ""
    echo "the following python packages did not install correctly:"

    for k in "${!err[@]}"; do
        echo " ${k}: expected ${versions["${k}"]} got ${err["${k}"]} instead"
    done

    echo ""

    exit 1
}

function validate {
    local k
    local v
    local actual
    declare -A actuals

    echo ""
    echo -n "verifying..."

    while read -r actual; do
        # split string 'actual' by sequence '=='
        actuals["${actual%%==*}"]="${actual#*==}"
    done < <(pipenv run pip freeze | grep -vE '^-e')

    for k in "${!versions[@]}"; do
        echo -n "."
        v="${versions["${k}"]}"
        actual="${actuals["${k}"]}"

        if test "${actual}" != "${v}"; then
            err["${k}"]="${actual}"
        fi
    done

    handle_errors

    # terminate 'verifying...' line
    echo ""

    echo ""
    echo "PASS"
}

msg="testing 'pipenv sync' operation"
iter=0
while :; do
    iter=$(( $iter + 1 ))
    echo ""
    echo "${msg}; iteration = ${iter}"

    rm -rf .venv
    pipenv sync

    validate

    if [[ $iter -ge $test_count ]]; then break ; fi
done

msg="testing 'pipenv install' operation"
iter=0
while :; do
    iter=$(( $iter + 1 ))
    echo ""
    echo "${msg}; iteration = ${iter}"

    rm -rf .venv Pipfile.lock
    pipenv install

    validate

    if [[ $iter -ge $test_count ]]; then break ; fi
done

echo ""
echo "looks like test passed, try upping test_count to something large to make sure all is well"
echo ""
