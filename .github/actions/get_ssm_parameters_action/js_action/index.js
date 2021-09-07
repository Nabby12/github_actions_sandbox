'use strict'

const core = require('@actions/core')

const DEFAULT_REGION = 'ap-northeast-1'
const SSM_VERSION = '2014-11-06'

const SAMPLE_INPUT_ARGS = core.getInput('sample_input_args').split('\n')

const AWS = require('aws-sdk')
AWS.config.update({
  region: DEFAULT_REGION,
  apiVersions: {
    ssm: SSM_VERSION
  }
})

const ssm = new AWS.SSM()

if (require.main === module) {
  handler()
}

async function handler() {
  try {
    const ssm_path = '/test_path/'
    let ssm_params = []
    SAMPLE_INPUT_ARGS.map(arg => {
      const param = {
        path: ssm_path, 
        key: arg
      }
      ssm_params.push(param)
    })

    let ssm_parameters = {}
    await Promise.all (
      ssm_params.map(async parameter => {
        const params = {
          Name: parameter.path + parameter.key,
          WithDecryption: true
        }
        const response = await ssm.getParameter(params)
        .promise()
        .then(data => {
          ssm_parameters[parameter.key] = data.Parameter.Value
          return 'get ssm parameter succeeded.'
        })
        .catch(err => {
          console.log(err)
          throw new Error('get ssm parameter failed.')
        })

        console.log(response)
      })
    )
    // outputに定義する値をマスク
    // core.setSecret(JSON.stringify(ssm_parameters))
    // outputに取得した値を定義
    core.setOutput('ssm_parameters', JSON.stringify(ssm_parameters))
  } catch (error) {
    core.setFailed(error.message)
  }
}
