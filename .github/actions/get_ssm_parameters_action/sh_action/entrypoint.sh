#!/bin/bash

# input args
sample_input_args="$INPUT_SAMPLE_INPUT_ARGS"
sample_input_args=$(echo -n "${sample_input_args}" | sed --null-data -e 's/\n/,/g;')

IFS=, PARAMS_ARRAY=(${sample_input_args})
ARRAY_COUNT=`expr "${#PARAMS_ARRAY[*]}"`

SSM_PATH="/test_path/"

i=1
for param in "${PARAMS_ARRAY[@]}"
do
    END_STRING=","
    if [ "${i}" -eq 1 ]; then
        SSM_PARAMETERS="{"
    elif [ "${i}" -eq "${ARRAY_COUNT}" ]; then
        END_STRING="}"
    fi

    TARGET_KEY="${SSM_PATH}"TEST_VALUE1
    RESPONSE=$(aws ssm get-parameter --name "${TARGET_KEY}" --with-decryption)
    VALUE="$(jq -r '.Parameter.Value' <(echo "${RESPONSE}"))"
    echo "----"
    echo "${VALUE}"
    echo "----"
    SSM_PARAMETERS="${SSM_PARAMETERS}"\""${param}"\"\:\""${VALUE}"\""${END_STRING}"
    let i++
done

# output arg
echo "::set-output name=ssm_parameters::$SSM_PARAMETERS"
