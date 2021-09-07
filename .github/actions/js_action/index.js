'use strict'

const core = require('@actions/core')

const SAMPLE_INPUT = core.getInput('sample_input')

if (require.main === module) {
  handler()
}

async function handler() {
  try {
    const sample_output = SAMPLE_INPUT + ' -> sample_output'

    // outputに定義する値をマスク
    core.setSecret(JSON.stringify(ssm_parameters))
    // outputに取得した値を定義
    core.setOutput('ssm_parameters', JSON.stringify(ssm_parameters))
  } catch (error) {
    core.setFailed(error.message);
  }
}
