const path = require('path')
const {ipcRenderer} = require('electron')
const Jasmine = require('jasmine')

process.stdout.write = output => {
  ipcRenderer.send('jasmine-output', String(output))
  return true
}

const projectBaseDir = path.resolve(__dirname, '..', '..', '..')
const runner = new Jasmine({projectBaseDir})
let specs = 0
let failures = 0

runner.exitOnCompletion = false
runner.loadConfigFile(path.join(projectBaseDir, 'spec', 'support', 'jasmine.json'))
runner.addReporter({
  specDone: result => {
    specs++
    failures += result.failedExpectations.length
    for (const failure of result.failedExpectations) {
      ipcRenderer.send('jasmine-output', `${result.fullName}: ${failure.message}\n${failure.stack || ''}\n`)
    }
  },
  jasmineDone: result => {
    failures += result.failedExpectations.length
    for (const failure of result.failedExpectations) {
      ipcRenderer.send('jasmine-output', `${failure.message}\n${failure.stack || ''}\n`)
    }
    ipcRenderer.send('jasmine-done', {
      failures,
    passed: result.overallStatus === 'passed',
    specs
    })
  }
})

runner.execute()
