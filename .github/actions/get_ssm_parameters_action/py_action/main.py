import boto3
import json
import os

ssm = boto3.client('ssm')

DEFAULT_REGION = os.environ['default_region']
SSM_PATH_NAME = os.environ['ssm_path_name']
ENV_NAME = os.environ['env_name']
CD_PARAMETERS = os.environ['cd_parameters'].split('\n')
PARAMETERS = os.environ['parameters'].split('\n')

def main():
    ssm_cd_path = '/cd/'
    ssm_path = '/' + SSM_PATH_NAME + '/' + ENV_NAME * '/'

    # 取得するパラメータストアのパス+名称を一つの配列に格納
    ssm_parameters = {}
    for parameter in CD_PARAMETERS:
        try: 
            response = ssm.get_parameter(
                Name = ssm_cd_path + parameter,
                WithDecryption = True
            )
            ssm_parameters[parameter] = response['Parameter']['Value']
            print('get ssm parameter succeeded.')
        except Exception as err:
            print(err)
            raise Exception ('get ssm parameter failed.')

    for parameter in PARAMETERS:
        try: 
            response = ssm.get_parameter(
                Name = ssm_path + parameter,
                WithDecryption = True
            )
            ssm_parameters[parameter] = response['Parameter']['Value']
            print('get ssm parameter succeeded.')
        except Exception as err:
            print(err)
            raise Exception ('get ssm parameter failed.')

    print("::add-mask::" + json.dumps(ssm_parameters))
    print("::set-output name=ssm_parameters::" + json.dumps(ssm_parameters))

if __name__ == '__main__':
    main()
