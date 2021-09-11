'use strict'

const core = require('@actions/core')

const SAMPLE_INPUT = core.getInput('sample_input')

if (require.main === module) {
  handler()
}

async function handler() {
  try {
    const sample_output = SAMPLE_INPUT + ' -> sample_output'
    core.setOutput('sample_output', sample_output)
  } catch (error) {
    core.setFailed(error.message);
  }
}
