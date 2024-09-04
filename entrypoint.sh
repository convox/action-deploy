#!/bin/sh
echo "Deploying"
if [ -n "$INPUT_PASSWORD" ]
then
    export CONVOX_PASSWORD=$INPUT_PASSWORD
fi
if [ -n "$INPUT_HOST" ]
then
    export CONVOX_HOST=$INPUT_HOST
fi
export CONVOX_RACK=$INPUT_RACK

# Initialize variables for the command options
CACHED_COMMAND=""
MANIFEST_COMMAND=""

if [ "$INPUT_CACHED" = "false" ]; then
    CACHED_COMMAND="--no-cache"
fi

if [ "$INPUT_MANIFEST" != "" ]; then
    MANIFEST_COMMAND="-m $INPUT_MANIFEST"
fi

# Split the INPUT_BUILDARGS by newline into an array
if [ "$INPUT_BUILDARGS" != "" ]; then
    IFS=$'\n' read -d '' -r -a ADDR <<< "$INPUT_BUILDARGS"  # Split build arguments by newline

    for ARG in "${ADDR[@]}"; do
        # Extract key and value (handle empty lines or invalid format)
        KEY=${ARG%%=*}
        VALUE=${ARG#*=}
        if [[ -n "$KEY" && -n "$VALUE" ]]; then
            BUILDARGS_COMMAND="$BUILDARGS_COMMAND --build-args $KEY=$VALUE"
        fi
    done
fi

convox deploy --app $INPUT_APP --description "$INPUT_DESCRIPTION" $BUILDARGS_COMMAND $CACHED_COMMAND $MANIFEST_COMMAND
