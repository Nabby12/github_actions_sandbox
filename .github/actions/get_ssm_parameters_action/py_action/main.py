import boto3
import json
import os

ssm = boto3.client('ssm')

SAMPLE_INPUT_ARGS = os.environ['INPUT_SAMPLE_INPUT_ARGS'].split('\n')

def main():
    ssm_parameters = {}

    ssm_path = '/test_path/'
    for SAMPLE_INPUT_ARGS in arg:
        try: 
            response = ssm.get_parameters(
                Name = ssm_path + arg,
                WithDecryption = True
            )
            ssm_parameters[arg] = response['Parameter']['Value']
            print 'get ssm parameter succeeded.'
        except Exception as err:
            print(err)
            raise Exception ('get ssm parameter failed.')

    print("::set-output name=ssm_parameter:: " + json.dumps(ssm_parameter))

if __name__ == '__main__':
    main()
