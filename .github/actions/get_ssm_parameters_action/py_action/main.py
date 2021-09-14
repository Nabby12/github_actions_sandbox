import boto3
import json
import os

ssm = boto3.client('ssm')

SAMPLE_INPUT_ARGS = os.environ['INPUT_SAMPLE_INPUT_ARGS'].split('\n')

def main():
    ssm_parameters = {}

    ssm_path = '/test_path/'
    for arg in SAMPLE_INPUT_ARGS:
        try: 
            response = ssm.get_parameter(
                Name = ssm_path + arg,
                WithDecryption = True
            )
            ssm_parameters[arg] = response['Parameter']['Value']
            print('get ssm parameter succeeded.')
        except Exception as err:
            print(err)
            raise Exception ('get ssm parameter failed.')

    print("::add-mask::" + json.dumps(ssm_parameters))
    print("::set-output name=ssm_parameters::" + json.dumps(ssm_parameters))

if __name__ == '__main__':
    main()
