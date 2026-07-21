#!/bin/bash
set -e

if [ -z "${INPUT_RACK:-}" ]; then
  echo "::error::Required input 'rack' is missing"
  exit 1
fi
if [ -z "${INPUT_APP:-}" ]; then
  echo "::error::Required input 'app' is missing"
  exit 1
fi

echo "Deploying"

# Export Convox environment variables
[ -n "$INPUT_PASSWORD" ] && export CONVOX_PASSWORD="$INPUT_PASSWORD"
[ -n "$INPUT_HOST" ]     && export CONVOX_HOST="$INPUT_HOST"
export CONVOX_RACK="$INPUT_RACK"

# Build optional flags
ARGS=""
[ "$INPUT_CACHED" = "false" ] && ARGS="$ARGS --no-cache"
[ -n "$INPUT_MANIFEST" ]      && ARGS="$ARGS -m $INPUT_MANIFEST"
[ "$INPUT_FORCE"  = "true"  ] && ARGS="$ARGS --force"

# Split the INPUT_BUILDARGS by newline into an array
if [ "$INPUT_BUILDARGS" != "" ]; then
    IFS=$'\n' read -d '' -r -a ADDR <<< "$INPUT_BUILDARGS"

    for ARG in "${ADDR[@]}"; do
        KEY=${ARG%%=*}
        VALUE=${ARG#*=}
        if [[ -n "$KEY" && -n "$VALUE" ]]; then
            ARGS="$ARGS --build-args $KEY=$VALUE"
        fi
    done
fi

# shellcheck disable=SC2086
# ARGS is intentionally unquoted (word-split, may be empty)
convox deploy --app "$INPUT_APP" --description "$INPUT_DESCRIPTION" $ARGS --wait
