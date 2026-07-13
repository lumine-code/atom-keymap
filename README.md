# @lumine-code/atom-keymap

Lumine's DOM-aware keymap module

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

* Tests can be run in batch mode with `npm test`
* If you want to use the debugger, profiler, etc or just speed up your flow by being able to refresh the DevTools window to re-run tests, use the `npm run test-drive` script. This will keep the DevTools open instead of exiting after the test run.
