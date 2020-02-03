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

    set +e
    OUTPUT=$(make test | tee 1> test_stdout.txt 2> test_stderr.txt)
    EXIT_CODE=$?
    set -e
    ## echo to STDERR so output shows up in GH action UI
    echo >&2 $OUTPUT
    echo "::set-output name=results::${OUTPUT}"
    echo "::set-output name=exit_code::${EXIT_CODE}"
    exit $EXIT_CODE
}

main
