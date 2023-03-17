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
if [ "$INPUT_CACHED" = "false" ]; then
    convox deploy --app $INPUT_APP --description "$INPUT_DESCRIPTION" --no-cache --wait
else
    convox deploy --app $INPUT_APP --description "$INPUT_DESCRIPTION" --wait
fi
