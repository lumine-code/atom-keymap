/* global beforeEach, afterEach */

'use strict'

const FakeTimers = require('@sinonjs/fake-timers')
const sinon = require('sinon')

let sinonSandbox, fakeClock, processPlatform, originalProcessPlatform

originalProcessPlatform = process.platform
processPlatform = process.platform
Object.defineProperty(process, 'platform', {get: () => processPlatform})

beforeEach(function () {
  document.body.innerHTML = ''
  sinonSandbox = sinon.createSandbox()
  fakeClock = FakeTimers.install()
})

afterEach(function () {
  fakeClock.uninstall()
  sinonSandbox.restore()
  processPlatform = originalProcessPlatform
})

function appendContent (element) {
  document.body.appendChild(element)
  return element
}

function stub () {
  const [object, method, replacement] = arguments
  if (object == null) return sinonSandbox.stub()
  const result = sinonSandbox.stub(object, method)
  return replacement ? result.callsFake(replacement) : result
}

function getFakeClock () {
  return fakeClock
}

function mockProcessPlatform (platform) {
  processPlatform = platform
}

function restoreProcessPlatform () {
  processPlatform = originalProcessPlatform
}

function buildKeydownEvent (props) {
  return buildKeyboardEvent('keydown', props)
}

function buildKeyupEvent (props) {
  return buildKeyboardEvent('keyup', props)
}

function buildKeyboardEvent (type, props) {
  let {key, code, ctrlKey, shiftKey, altKey, metaKey, target, modifierState} = props
  if (!modifierState) modifierState = {}

  if (process.platform === 'darwin') {
    if (modifierState.AltGraph) {
      altKey = true
    }
  } else if (process.platform === 'win32') {
    if (modifierState.AltGraph) {
      ctrlKey = true
      altKey = true
    } else if (ctrlKey && altKey) {
      modifierState.AltGraph = true
    }
  }

  const event = new KeyboardEvent(type, {
    key, code,
    ctrlKey, shiftKey, altKey, metaKey,
    cancelable: true, bubbles: true
  })

  if (target) {
    Object.defineProperty(event, 'target', {get: () => target})
    Object.defineProperty(event, 'path', {get: () => [target]})
  }

  Object.defineProperty(event, 'getModifierState', {value: (key) => {
    return !!modifierState[key]
  }})

  return event
}

module.exports = {
  appendContent,
  stub,
  getFakeClock,
  mockProcessPlatform,
  restoreProcessPlatform,
  buildKeydownEvent,
  buildKeyupEvent
}
