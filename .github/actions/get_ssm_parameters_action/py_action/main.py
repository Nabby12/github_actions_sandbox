import boto3
import json
import os

ssm = boto3.client('ssm')

DEFAULT_REGION = os.environ['INPUT_DEFAULT_REGION']
SSM_PATH_NAME = os.environ['INPUT_SSM_PATH_NAME']
ENV = os.environ['INPUT_ENV']
CD_PARAMETERS = os.environ['INPUT_CD_PARAMETERS'].split('\n')
PARAMETERS = os.environ['INPUT_PARAMETERS'].split('\n')


def main():
    ssm_cd_path = '/cd/'
    ssm_path = '/' + SSM_PATH_NAME + '/' + ENV + '/'

    # 取得するパラメータストアのパス+名称を一つの配列に格納
    ssm_parameters = {}
    if CD_PARAMETERS:
        for parameter in CD_PARAMETERS:
            try:
                response = ssm.get_parameter(
                    Name=ssm_cd_path + parameter,
                    WithDecryption=True
                )
                ssm_parameters[parameter] = response['Parameter']['Value']
                print('get ssm parameter succeeded.')
            except Exception as err:
                print(err)
                raise Exception('get ssm parameter failed.')

    if PARAMETERS:
        for parameter in PARAMETERS:
            try:
                response = ssm.get_parameter(
                    Name=ssm_path + parameter,
                    WithDecryption=True
                )
                ssm_parameters[parameter] = response['Parameter']['Value']
                print('get ssm parameter succeeded.')
            except Exception as err:
                print(err)
                raise Exception('get ssm parameter failed.')

    # outputに定義する値をマスク
    for key in ssm_parameters:
        print("::add-mask::" + ssm_parameters[key])

    # outputに取得した値を定義
    print("::set-output name=ssm_parameters::" + json.dumps(ssm_parameters))


if __name__ == '__main__':
    main()
