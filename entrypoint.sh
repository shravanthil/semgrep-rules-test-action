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

    apk add make
    

    set +e
    OUTPUT=$(make test)
    EXIT_CODE=$?
    set -e
    ## echo to STDERR so output shows up in GH action UI
    echo >&2 $OUTPUT
    echo "::set-output name=output::${OUTPUT}"
    exit $EXIT_CODE
}

main
