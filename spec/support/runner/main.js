const path = require('path')
const {app, BrowserWindow, ipcMain} = require('electron')

const interactive = process.env.SUPPRESS_EXIT === 'true'
let mainWindow

ipcMain.on('jasmine-output', (_event, output) => process.stdout.write(output))
ipcMain.once('jasmine-done', (_event, result) => {
  process.stdout.write(`${result.specs} specs, ${result.failures} failures\n`)
  if (!interactive) app.exit(result.passed ? 0 : 1)
})

app.whenReady().then(() => {
  mainWindow = new BrowserWindow({
    show: interactive,
    webPreferences: {
      contextIsolation: false,
      nodeIntegration: true,
      sandbox: false
    }
  })

  mainWindow.loadFile(path.join(__dirname, 'index.html'))
  if (interactive) mainWindow.webContents.openDevTools()
})

app.on('window-all-closed', () => app.quit())
