#!/bin/bash

# input args
default_region="DEFAULT_REGION"
ssm_path_name="SSM_PATH_NAME"
env_name="ENV_NAME"

cd_parameters="$CD_PARAMETERS"
cd_parameters=$(echo -n "${CD_PARAMETERS}" | sed --null-data -e 's/\n/,/g;')

IFS=, CD_PARAMS_ARRAY=(${cd_parameters})
CD_ARRAY_COUNT=`expr "${#CD_PARAMS_ARRAY[*]}"`

parameters="$PARAMETERS"
parameters=$(echo -n "${PARAMETERS}" | sed --null-data -e 's/\n/,/g;')

IFS=, PARAMS_ARRAY=(${parameters})
ARRAY_COUNT=`expr "${#PARAMS_ARRAY[*]}"`

i=1
for param in "${CD_PARAMS_ARRAY[@]}"
do
    END_STRING=","
    if [ "${i}" -eq 1 ]; then
        SSM_PARAMETERS="{"
    elif [ "${i}" -eq "${CD_ARRAY_COUNT}" ]; then
        END_STRING="}"
    fi

    TARGET_KEY="${SSM_PATH}""${param}"
    RESPONSE=$(aws ssm get-parameter --name "${TARGET_KEY}" --with-decryption)
    VALUE="$(jq -r '.Parameter.Value' <(echo "${RESPONSE}"))"

    SSM_PARAMETERS="${SSM_PARAMETERS}"\""${param}"\"\:\""${VALUE}"\""${END_STRING}"
    let i++
done

i=1
for param in "${PARAMS_ARRAY[@]}"
do
    END_STRING=","
    if [ "${i}" -eq 1 ]; then
        SSM_PARAMETERS="{"
    elif [ "${i}" -eq "${ARRAY_COUNT}" ]; then
        END_STRING="}"
    fi

    TARGET_KEY="${SSM_PATH}""${param}"
    RESPONSE=$(aws ssm get-parameter --name "${TARGET_KEY}" --with-decryption)
    VALUE="$(jq -r '.Parameter.Value' <(echo "${RESPONSE}"))"

    SSM_PARAMETERS="${SSM_PARAMETERS}"\""${param}"\"\:\""${VALUE}"\""${END_STRING}"
    let i++
done

# mask arg
echo "::add-mask::$SSM_PARAMETERS"

# output arg
echo "::set-output name=ssm_parameters::$SSM_PARAMETERS"
