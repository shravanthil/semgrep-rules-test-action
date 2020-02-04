#!/bin/sh
set -e

function checkRequired() {
    if [ -z "${1}" ]; then
        echo >&2 "Unable to find the ${2}. Did you set with.${2}?"
        exit 1
    fi
}

function uses() {
    [ ! -z "${1}" ]
}

function usesBoolean() {
    [ ! -z "${1}" ] && [ "${1}" = "true" ]
}

function main() {
    echo "" # see https://github.com/actions/toolkit/issues/168

    # install make in minimal docker image
    apk add make

    mkdir -p .test_output

    set +e
    make test 1>.test_output/stdout.txt 2>.test_output/stderr.txt
    EXIT_CODE=$?
    set -e
    ## echo to STDERR so output shows up in GH action UI
    cat .test_output/stdout.txt >&2
    ## format string
    OUTPUT_FMT=$(cat .test_output/stdout.txt | sed 's/$/\\n/' | tr -d '\n')
    echo "::set-output name=results::${OUTPUT_FMT}"
    echo "::set-output name=exit_code::${EXIT_CODE}"
    echo "::set-output name=output_dir::.test_output"
    exit $EXIT_CODE
}

main
