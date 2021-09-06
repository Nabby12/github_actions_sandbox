#!/bin/bash

# input args
sample_input_args="$INPUT_SAMPLE_INPUT_args"
sample_input_args=${echo "${sample_input_args}" | sed --null-data -e 's/\n/,/g;'}

echo "${sample_input_args}"

IFS=, PARAMS_ARRAY="(${sample_input_args})"

SSM_PARAMETERS="'{"
i=1
for param in "${PARAMS_ARRAY[@]}"
do
    END_STRING=","
    if [ i -eq "${#PARAMS_ARRAY[*]}" ]; then
        END_STRING="}'"
    fi

    SSM_PARAMETERS="${SSM_PARAMETERS}"\""${param}"\"\:\""${param}"\""${END_STRING}"
    let i++
done

SSM_PARAMETERS="${SSM_PARAMETERS}""}"

# output arg
echo "::set-output name=ssm_parameters::$SSM_PARAMETERS"
