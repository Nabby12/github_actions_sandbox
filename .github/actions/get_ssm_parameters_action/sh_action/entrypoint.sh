#!/bin/bash

# input args
default_region="$INPUT_DEFAULT_REGION"
ssm_path_name="$INPUT_SSM_PATH_NAME"
env="$INPUT_ENV"

cd_parameters="$INPUT_CD_PARAMETERS"
cd_parameters=$(echo -n "${cd_parameters}" | sed --null-data -e 's/\n/,/g;')

parameters="$INPUT_PARAMETERS"
parameters=$(echo -n "${parameters}" | sed --null-data -e 's/\n/,/g;')

IFS=, CD_PARAMS_ARRAY=(${cd_parameters})
CD_ARRAY_COUNT=`expr "${#CD_PARAMS_ARRAY[*]}"`

echo 'parameters'
echo parameters
echo 'parameters'

i=1
for param in "${CD_PARAMS_ARRAY[@]}"
do
    END_STRING=","
    if [ "${i}" -eq 1 ]; then
        SSM_PARAMETERS="{"
    fi

    TARGET_KEY="/cd/${param}"
    RESPONSE=$(aws ssm get-parameter --name "${TARGET_KEY}" --with-decryption --query "Parameter.Value")

    SSM_PARAMETERS="${SSM_PARAMETERS}"\""${param}"\"\:"${RESPONSE}""${END_STRING}"
    ssm_array=("${ssm_array[@]}" ${RESPONSE})

    let i++
done

IFS=, PARAMS_ARRAY=(${parameters})
ARRAY_COUNT=`expr "${#PARAMS_ARRAY[*]}"`

i=1
for param in "${PARAMS_ARRAY[@]}"
do
    END_STRING=","
    if [ "${i}" -eq "${ARRAY_COUNT}" ]; then
        END_STRING="}"
    fi

    TARGET_KEY="/${ssm_path_name}/${env}/${param}"
    RESPONSE=$(aws ssm get-parameter --name "${TARGET_KEY}" --with-decryption --query "Parameter.Value")

    SSM_PARAMETERS="${SSM_PARAMETERS}"\""${param}"\"\:"${RESPONSE}""${END_STRING}"
    ssm_array=("${ssm_array[@]}" ${RESPONSE})

    let i++
done

for data in ${ssm_array[@]}
do
    # mask arg
    echo "::add-mask::${data}"
done

echo "::set-output name=ssm_parameters::$SSM_PARAMETERS"
