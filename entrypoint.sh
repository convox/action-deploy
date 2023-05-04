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

convox deploy --app $INPUT_APP --description "$INPUT_DESCRIPTION" $CACHED_COMMAND $MANIFEST_COMMAND --wait
