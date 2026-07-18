# @lumine-code/atom-keymap

Provides DOM-aware keymap management for Lumine and Electron applications.

> [!WARNING]
> **This package is deprecated.** Its source now lives inside the [Lumine editor](https://github.com/lumine-code/lumine) as part of Lumine core and is no longer maintained as a standalone package. This repository is archived and no longer receives updates.

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

## Changes

This is the Lumine fork of `atom-keymap`, published under the `@lumine-code` scope. Relative to the upstream Pulsar package it:

- Rebrands the package to `@lumine-code/atom-keymap` and releases it as a new major version.
- Unifies the test suite on Jasmine 6 and JavaScript.
- Drops `chai` and `debounce` for self-contained test helpers, and removes the npm overrides they required.
- Modernizes dependencies onto the `@lumine-code` forks of `season`, `fs-plus`, `pathwatcher`, and `keyboard-layout`.
- Adds cross-platform CI and modernizes the publish workflows.
- Updates the license attribution for Lumine.

## Contributing

Got ideas to make this package better, found a bug, or want to help add new features? Just drop your thoughts on GitHub. Any feedback is welcome!
