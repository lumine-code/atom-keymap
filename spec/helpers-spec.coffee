{normalizeKeystrokes, keystrokesMatch, isModifierKeyup, isKeyup} = require '../src/helpers'

describe ".normalizeKeystrokes(keystrokes)", ->
  it "parses and normalizes the keystrokes", ->
    assert.equal(normalizeKeystrokes('ctrl--'), 'ctrl--')
    assert.equal(normalizeKeystrokes('ctrl-x'), 'ctrl-x')
    assert.equal(normalizeKeystrokes('a'), 'a')
    assert.equal(normalizeKeystrokes('shift-a'), 'shift-A')
    assert.equal(normalizeKeystrokes('shift-9'), 'shift-9')
    assert.equal(normalizeKeystrokes('-'), '-')
    assert.equal(normalizeKeystrokes('- -'), '- -')
    assert.equal(normalizeKeystrokes('a b'), 'a b')
    assert.equal(normalizeKeystrokes('cmd-k cmd-v'), 'cmd-k cmd-v')
    assert.equal(normalizeKeystrokes('cmd-cmd'), 'cmd')
    assert.equal(normalizeKeystrokes('cmd-shift'), 'shift-cmd')
    assert.equal(normalizeKeystrokes('cmd-shift-a'), 'shift-cmd-A')
    assert.equal(normalizeKeystrokes('cmd-ctrl-alt--'), 'ctrl-alt-cmd--')

    assert.equal(normalizeKeystrokes('ctrl-y   ^y'), 'ctrl-y ^y')
    assert.equal(normalizeKeystrokes('ctrl-y ^ctrl-y'), 'ctrl-y ^y')
    assert.equal(normalizeKeystrokes('cmd-shift-y ^cmd-shift-y'), 'shift-cmd-Y ^y')
    assert.equal(normalizeKeystrokes('ctrl-y ^ctrl-y ^ctrl'), 'ctrl-y ^y ^ctrl')
    assert.equal(normalizeKeystrokes('ctrl-y ^ctrl-shift-alt-cmd-y ^ctrl ^shift ^alt ^cmd'), 'ctrl-y ^y ^ctrl ^shift ^alt ^cmd')
    assert.equal(normalizeKeystrokes('a b c ^a ^b ^c'), 'a b c ^a ^b ^c')

    assert.equal(normalizeKeystrokes('a-b'), false)
    assert.equal(normalizeKeystrokes('---'), false)
    assert.equal(normalizeKeystrokes('cmd-a-b'), false)
    assert.equal(normalizeKeystrokes('-a-b'), false)
    assert.equal(normalizeKeystrokes('ctrl-'), false)
    assert.equal(normalizeKeystrokes('--'), false)
    assert.equal(normalizeKeystrokes('- '), false)
    assert.equal(normalizeKeystrokes('a '), false)

describe "CmdOrCtrl modifier in .normalizeKeystrokes(keystrokes)", ->
  cmdOrCtrl = if process.platform is 'darwin' then 'cmd' else 'ctrl'

  it "resolves CmdOrCtrl to cmd on darwin, ctrl on win32/linux", ->
    assert.equal(normalizeKeystrokes('CmdOrCtrl-f'), "#{cmdOrCtrl}-f")
    # canonical order is ctrl < alt < shift < cmd, so ctrl precedes shift but shift precedes cmd
    expectedWithShift = if process.platform is 'darwin' then 'shift-cmd-F' else 'ctrl-shift-F'
    assert.equal(normalizeKeystrokes('CmdOrCtrl-shift-f'), expectedWithShift)
    assert.equal(normalizeKeystrokes('CmdOrCtrl-k CmdOrCtrl-d'), "#{cmdOrCtrl}-k #{cmdOrCtrl}-d")

describe ".isModifierKeyup(keystroke)", ->
  it "returns true for single modifier keyups", ->
    assert.isTrue(isModifierKeyup('^ctrl'))
    assert.isTrue(isModifierKeyup('^shift'))
    assert.isTrue(isModifierKeyup('^alt'))
    assert.isTrue(isModifierKeyup('^cmd'))
    assert.isTrue(isModifierKeyup('^ctrl-shift'))
    assert.isTrue(isModifierKeyup('^alt-cmd'))

  it "returns false for modifier keydowns", ->
    assert.isFalse(isModifierKeyup('ctrl-x'))
    assert.isFalse(isModifierKeyup('shift-x'))
    assert.isFalse(isModifierKeyup('alt-x'))
    assert.isFalse(isModifierKeyup('cmd-x'))
    assert.isFalse(isModifierKeyup('ctrl-shift-x'))
    assert.isFalse(isModifierKeyup('alt-cmd-x'))

describe ".isKeyup(keystrokes)", ->
  it "return false for single ^", ->
    assert.isFalse(isKeyup('^'))

  it "return true when keystroke starts with ^", ->
    assert.isTrue(isKeyup('^a'))
    assert.isTrue(isKeyup('^ctrl'))
    assert.isTrue(isKeyup('^shift'))
