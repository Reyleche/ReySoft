const { app, BrowserWindow, dialog, ipcMain } = require('electron');
let autoUpdater = null;
try {
  ({ autoUpdater } = require('electron-updater'));
} catch {
  autoUpdater = null;
}
const { spawn, execSync } = require('child_process');
const path = require('path');
const http = require('http');
const https = require('https');
const fs = require('fs');
const os = require('os');

let mainWindow = null;
let splashWindow = null;
let backendProcess = null;

const API_URL = 'http://localhost:3000';

const getResourcesPath = () => {
  return app.isPackaged ? process.resourcesPath : path.join(__dirname, '..');
};

const getBackendPath = () => {
  if (app.isPackaged) {
    return path.join(process.resourcesPath, 'backend', 'index.js');
  }
  return path.join(__dirname, '..', 'backend', 'index.js');
};

const getRendererPath = () => {
  if (app.isPackaged) {
    const packagedPath = path.join(process.resourcesPath, 'renderer', 'index.html');
    const packagedLegacyPath = path.join(process.resourcesPath, 'renderer', 'browser', 'index.html');
    return fs.existsSync(packagedPath) ? packagedPath : packagedLegacyPath;
  }
  const devPath = path.join(__dirname, '..', 'frontend', 'dist', 'frontend', 'index.html');
  const devLegacyPath = path.join(__dirname, '..', 'frontend', 'dist', 'frontend', 'browser', 'index.html');
  return fs.existsSync(devPath) ? devPath : devLegacyPath;
};

const getSplashLogoPath = () => {
  if (app.isPackaged) {
    const packagedLogo = path.join(process.resourcesPath, 'renderer', 'assets', 'coco.jpg');
    return fs.existsSync(packagedLogo) ? packagedLogo : '';
  }
  const devLogo = path.join(__dirname, '..', 'frontend', 'dist', 'frontend', 'assets', 'coco.jpg');
  return fs.existsSync(devLogo) ? devLogo : '';
};

const waitForBackend = (retries = 40, delayMs = 500) => {
  return new Promise((resolve, reject) => {
    const attempt = (left) => {
      http.get(API_URL, (res) => {
        res.resume();
        resolve();
      }).on('error', () => {
        if (left <= 0) {
          reject(new Error('Backend no responde'));
        } else {
          setTimeout(() => attempt(left - 1), delayMs);
        }
      });
    };
    attempt(retries);
  });
};

const getBackendLogPath = () => {
  return path.join(app.getPath('userData'), 'backend.log');
};

const getUiLogPath = () => {
  return path.join(app.getPath('userData'), 'ui.log');
};

const getUpdateLogPath = () => {
  return path.join(app.getPath('userData'), 'update.log');
};

const setupAutoUpdater = () => {
  if (!app.isPackaged) {
    return;
  }

  if (!autoUpdater) {
    return;
  }

  const logStream = fs.createWriteStream(getUpdateLogPath(), { flags: 'a' });
  const log = (message) => {
    logStream.write(`${new Date().toISOString()} ${message}\n`);
  };

  autoUpdater.autoDownload = true;

  autoUpdater.on('checking-for-update', () => log('Checking for update'));
  autoUpdater.on('update-available', () => log('Update available'));
  autoUpdater.on('update-not-available', () => log('Update not available'));
  autoUpdater.on('error', (err) => log(`Update error: ${String(err)}`));
  autoUpdater.on('download-progress', (progress) => {
    log(`Download progress: ${Math.round(progress.percent)}%`);
  });
  autoUpdater.on('update-downloaded', () => {
    log('Update downloaded');
    const result = dialog.showMessageBoxSync({
      type: 'info',
      buttons: ['Reiniciar ahora', 'Despues'],
      defaultId: 0,
      cancelId: 1,
      title: 'Actualizacion lista',
      message: 'Hay una nueva version lista. Reinicia para actualizar.'
    });
    if (result === 0) {
      autoUpdater.quitAndInstall();
    }
  });

  autoUpdater.checkForUpdatesAndNotify();
};

const runPostgresInstaller = async () => {
  const scriptPath = path.join(process.resourcesPath, 'installer', 'install-postgres.ps1');
  if (!app.isPackaged || !fs.existsSync(scriptPath)) {
    return { ok: false, error: 'Instalador de Postgres no disponible.' };
  }

  const logPath = path.join(app.getPath('userData'), 'postgres-install.log');
  const logStream = fs.createWriteStream(logPath, { flags: 'a' });

  return await new Promise((resolve) => {
    const psArgs = [
      '-NoProfile',
      '-ExecutionPolicy', 'Bypass',
      '-File',
      scriptPath
    ];
    const child = spawn('powershell.exe', psArgs, {
      windowsHide: true,
      env: { ...process.env }
    });
    child.stdout.on('data', (d) => logStream.write(d));
    child.stderr.on('data', (d) => logStream.write(d));
    child.on('exit', (code) => {
      logStream.end();
      if (code === 0) return resolve({ ok: true });
      resolve({ ok: false, error: `El instalador terminó con código ${code}. Revisa ${logPath}` });
    });
    child.on('error', (err) => {
      logStream.end();
      resolve({ ok: false, error: String(err) });
    });
  });
};

const callApi = (method, pathName, body, timeoutMs = 15000) => {
  return new Promise((resolve) => {
    const postData = body ? JSON.stringify(body) : '';
    const req = http.request({
      hostname: 'localhost',
      port: 3000,
      path: pathName,
      method,
      headers: body ? { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(postData) } : undefined
    }, (res) => {
      let data = '';
      res.on('data', (c) => data += c);
      res.on('end', () => resolve({ ok: true, status: res.statusCode, data }));
    });
    req.on('error', (err) => resolve({ ok: false, error: String(err) }));
    req.setTimeout(timeoutMs, () => { req.destroy(); resolve({ ok: false, error: 'timeout' }); });
    if (postData) req.write(postData);
    req.end();
  });
};

let backupInterval = null;
const setupPeriodicAutoBackup = () => {
  if (backupInterval) return;
  // Backup periódico (seguridad): cada 30 minutos
  backupInterval = setInterval(async () => {
    try {
      const cfgRes = await callApi('GET', '/api/sync/config', null, 5000);
      if (!cfgRes.ok) return;
      let autoBackup = true;
      try {
        const cfg = JSON.parse(cfgRes.data || '{}');
        if (cfg && typeof cfg.autoBackup === 'boolean') autoBackup = cfg.autoBackup;
      } catch {}
      if (!autoBackup) return;

      await callApi('POST', '/api/sync/backup', {}, 120000);
    } catch {
      // ignore
    }
  }, 30 * 60 * 1000);
};

const startBackend = () => {
  const backendPath = getBackendPath();
  const env = {
    ...process.env,
    ELECTRON_RUN_AS_NODE: '1',
    REYSOFT_APP_DATA: app.getPath('userData')
  };
  backendProcess = spawn(process.execPath, [backendPath], {
    env,
    cwd: path.dirname(backendPath),
    stdio: 'pipe'
  });

  const logStream = fs.createWriteStream(getBackendLogPath(), { flags: 'a' });
  backendProcess.stdout.on('data', (data) => logStream.write(data));
  backendProcess.stderr.on('data', (data) => logStream.write(data));

  backendProcess.on('exit', (code) => {
    if (code !== 0) {
      dialog.showErrorBox(
        'Backend detenido',
        'El servidor se cerro. Revisa Postgres o el archivo backend.log y vuelve a abrir la app.'
      );
    }
  });
};

const createWindow = async () => {
  splashWindow = new BrowserWindow({
    width: 520,
    height: 320,
    resizable: false,
    frame: false,
    transparent: true,
    alwaysOnTop: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    }
  });
  const splashLogo = getSplashLogoPath();
  await splashWindow.loadFile(path.join(__dirname, 'splash.html'), {
    query: splashLogo ? { logo: splashLogo } : {}
  });

  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    show: false,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    }
  });

  const rendererPath = getRendererPath();
  const uiLog = fs.createWriteStream(getUiLogPath(), { flags: 'a' });
  uiLog.write(`Renderer path: ${rendererPath}\n`);

  mainWindow.webContents.on('did-fail-load', (_event, errorCode, errorDesc, validatedURL) => {
    uiLog.write(`Load fail: ${errorCode} ${errorDesc} ${validatedURL}\n`);
    if (splashWindow) {
      splashWindow.close();
      splashWindow = null;
    }
    dialog.showErrorBox(
      'Error de interfaz',
      'No se pudo cargar la interfaz. Revisa ui.log y vuelve a intentar.'
    );
  });

  if (!fs.existsSync(rendererPath)) {
    uiLog.write(`Renderer missing: ${rendererPath}\n`);
    if (splashWindow) {
      splashWindow.close();
      splashWindow = null;
    }
    dialog.showErrorBox(
      'Error de interfaz',
      `No se encontro la interfaz en ${rendererPath}. Reinstala el instalador o genera el build del frontend.`
    );
    return;
  }

  try {
    await mainWindow.loadFile(rendererPath);
  } catch (err) {
    uiLog.write(`Load error: ${String(err)}\n`);
    if (splashWindow) {
      splashWindow.close();
      splashWindow = null;
    }
    dialog.showErrorBox(
      'Error de interfaz',
      'No se pudo cargar la interfaz. Revisa ui.log y vuelve a intentar.'
    );
  }

  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
    if (splashWindow) {
      splashWindow.close();
      splashWindow = null;
    }
  });

  waitForBackend().catch(() => {
    const result = dialog.showMessageBoxSync({
      type: 'error',
      buttons: ['Instalar Postgres', 'Cerrar'],
      defaultId: 0,
      cancelId: 1,
      title: 'Servidor no disponible',
      message: 'No se pudo iniciar el backend. En la PC nueva normalmente es porque Postgres no está instalado o no está configurado.'
    });
    if (result === 0) {
      (async () => {
        const install = await runPostgresInstaller();
        if (!install.ok) {
          dialog.showErrorBox('No se pudo instalar Postgres', String(install.error || 'Error desconocido'));
          return;
        }
        // Reintentar backend
        try {
          startBackend();
          await waitForBackend(60, 500);
          setupPeriodicAutoBackup();
        } catch {
          dialog.showErrorBox('Postgres instalado pero backend no responde', 'Revisa backend.log e intenta abrir la app nuevamente.');
        }
      })();
    }
  });
};

// IPC: Obtener ruta OneDrive detectada
ipcMain.handle('get-onedrive-path', async () => {
  const candidates = [
    process.env.OneDrive,
    process.env.OneDriveConsumer,
    process.env.OneDriveCommercial,
    path.join(os.homedir(), 'OneDrive'),
    path.join(os.homedir(), 'OneDrive - Personal')
  ].filter(Boolean);
  for (const p of candidates) {
    if (fs.existsSync(p)) return p;
  }
  return '';
});

// IPC: Impresión silenciosa de recibo
ipcMain.handle('print-silent', async (_event, html) => {
  return new Promise((resolve) => {
    const printWin = new BrowserWindow({
      show: false,
      width: 400,
      height: 700,
      webPreferences: { nodeIntegration: false, contextIsolation: true }
    });
    printWin.loadURL('data:text/html;charset=utf-8,' + encodeURIComponent(html));
    printWin.webContents.on('did-finish-load', () => {
      setTimeout(() => {
        printWin.webContents.print({ silent: true, printBackground: true }, (success, failureReason) => {
          printWin.close();
          resolve({ success, failureReason });
        });
      }, 300);
    });
  });
});

// IPC: Obtener logo en base64
ipcMain.handle('get-logo-base64', async () => {
  try {
    let logoPath;
    if (app.isPackaged) {
      logoPath = path.join(process.resourcesPath, 'renderer', 'assets', 'coco.jpg');
    } else {
      logoPath = path.join(__dirname, '..', 'frontend', 'dist', 'frontend', 'assets', 'coco.jpg');
      if (!fs.existsSync(logoPath)) {
        logoPath = path.join(__dirname, 'renderer', 'assets', 'coco.jpg');
      }
    }
    if (fs.existsSync(logoPath)) {
      const data = fs.readFileSync(logoPath);
      return 'data:image/jpeg;base64,' + data.toString('base64');
    }
    return '';
  } catch {
    return '';
  }
});

app.whenReady().then(() => {
  startBackend();
  setupAutoUpdater();
  createWindow();
  setupPeriodicAutoBackup();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('before-quit', async (e) => {
  // Auto-backup antes de cerrar (si está habilitado en config)
  if (!app._backupDone) {
    e.preventDefault();
    app._backupDone = true;
    try {
      const cfgRes = await callApi('GET', '/api/sync/config', null, 5000);
      const cfgRaw = cfgRes && cfgRes.ok ? cfgRes.data : null;

      let autoBackup = true;
      try {
        const cfg = JSON.parse(cfgRaw || '{}');
        if (cfg && typeof cfg.autoBackup === 'boolean') autoBackup = cfg.autoBackup;
      } catch {}

      if (autoBackup) {
        await callApi('POST', '/api/sync/backup', {}, 120000);
      }
    } catch {
      // Silently skip if backup fails
    }
    app.quit();
    return;
  }

  if (backupInterval) {
    clearInterval(backupInterval);
    backupInterval = null;
  }

  if (backendProcess) {
    backendProcess.kill();
  }
});
