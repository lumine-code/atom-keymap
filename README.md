# @lumine-code/atom-keymap

Provides DOM-aware keymap management for Lumine and Electron applications.

## Features

- **DOM awareness**: resolves bindings against the focused element and its ancestors.
- **Key sequences**: supports multi-keystroke bindings, keyup handlers, and partial-match timeouts.
- **Layout handling**: normalizes keyboard events across operating systems and keyboard layouts.

## Installation

```sh
npm install @lumine-code/atom-keymap
```

## Usage

```js
var KeymapManager, keymaps;
KeymapManager = require('@lumine-code/atom-keymap')

keymaps = new KeymapManager
keymaps.defaultTarget = document.body

// Pass all the window's keydown events to the KeymapManager
document.addEventListener('keydown', function(event) {
  keymaps.handleKeyboardEvent(event)
})

// Add some keymaps
keymaps.loadKeymap('/path/to/keymap-file.json') // can also be a directory of json / cson files
// OR
keymaps.add('/key/for/these/keymaps', {
  "body": {
    "up": "core:move-up",
    "down": "core:move-down"
  }
})

// When a keybinding is triggered, it will dispatch it on the node that was focused
window.addEventListener('core:move-up', (event) => console.log('up', event))
window.addEventListener('core:move-down', (event) => console.log('down', event))
```

## Development

The tests for this module *must* be run in Electron because they depend on browser APIs.

- Tests can be run in batch mode with `npm test`.
- Use `npm run test-drive` to keep DevTools open for debugging, profiling, and repeated test runs.

## Contributing

Got ideas to make this package better, found a bug, or want to help add new features? Just drop your thoughts on GitHub. Any feedback is welcome!
