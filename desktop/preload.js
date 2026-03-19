const { contextBridge, ipcRenderer } = require('electron');
const pkg = require('./package.json');

contextBridge.exposeInMainWorld('reysoft', {
  version: pkg.version,
  printSilent: (html, options) => ipcRenderer.invoke('print-silent', { html, ...(options || {}) }),
  getLogoBase64: () => ipcRenderer.invoke('get-logo-base64'),
  getOneDrivePath: () => ipcRenderer.invoke('get-onedrive-path')
});
