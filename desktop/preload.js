const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('reysoft', {
  version: '1.0.0',
  printSilent: (html) => ipcRenderer.invoke('print-silent', html),
  getLogoBase64: () => ipcRenderer.invoke('get-logo-base64')
});
