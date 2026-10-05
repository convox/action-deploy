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
if [ -n "$INPUT_PASSWORD" ]
then
    export CONVOX_PASSWORD="$INPUT_PASSWORD"
fi
if [ -n "$INPUT_HOST" ]
then
    export CONVOX_HOST="$INPUT_HOST"
fi
export CONVOX_RACK="$INPUT_RACK"

args=(--app "$INPUT_APP" --description "$INPUT_DESCRIPTION")

while IFS= read -r line || [ -n "$line" ]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    key="${line%%=*}"
    value="${line#*=}"
    if [ -z "$key" ] || [ -z "$value" ]; then
        continue
    fi
    case "$line" in
        *[[:space:]]*)
            echo "::error::Build arg '$key' contains whitespace, which the build cannot receive intact"
            exit 1
            ;;
    esac
    if [ "$line" = "$key" ]; then
        echo "::warning::Build arg '$key' has no '=' and is sent as $key=$key"
    fi
    if [[ "$value" == *,* ]]; then
        echo "::warning::Build arg '$key' contains a comma, which splits it into separate build args"
    fi
    args+=(--build-args "$key=$value")
done <<< "${INPUT_BUILDARGS:-}"

if [ "$INPUT_CACHED" = "false" ]; then
    args+=(--no-cache)
fi

if [ -n "$INPUT_MANIFEST" ]; then
    args+=(-m "$INPUT_MANIFEST")
fi

convox deploy "${args[@]}"
