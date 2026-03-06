const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('reysoft', {
  version: '1.1.1',
  printSilent: (html) => ipcRenderer.invoke('print-silent', html),
  getLogoBase64: () => ipcRenderer.invoke('get-logo-base64'),
  getOneDrivePath: () => ipcRenderer.invoke('get-onedrive-path')
});
