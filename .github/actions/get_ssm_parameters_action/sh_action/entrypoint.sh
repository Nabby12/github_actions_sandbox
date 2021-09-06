#!/bin/bash

# input args
sample_input_args="$INPUT_SAMPLE_INPUT_ARGS"
sample_input_args=$(echo -n "${sample_input_args}" | sed --null-data -e 's/\n/,/g;')

IFS=, PARAMS_ARRAY=(${sample_input_args})

ARRAY_COUNT=`expr "${#PARAMS_ARRAY[*]}"`
echo "---"
echo "${ARRAY_COUNT}"

SSM_PARAMETERS="'{"
i=1
for param in "${PARAMS_ARRAY[@]}"
do
    END_STRING=","
    if [ "${i}" -eq "${ARRAY_COUNT"} ]; then
        END_STRING="}'"
    fi

    SSM_PARAMETERS="${SSM_PARAMETERS}"\""${param}"\"\:\""${param}"\""${END_STRING}"
    let i++
done

SSM_PARAMETERS="${SSM_PARAMETERS}""}"

# output arg
echo "::set-output name=ssm_parameters::$SSM_PARAMETERS"
