const fs = require('fs');
const path = require('path');

const buildRoot = path.join(__dirname, '..', '..', 'frontend', 'dist', 'frontend');
const legacyBuildRoot = path.join(buildRoot, 'browser');
const rootIndex = path.join(buildRoot, 'index.html');
const legacyIndex = path.join(legacyBuildRoot, 'index.html');
const hasRootIndex = fs.existsSync(rootIndex);
const hasLegacyIndex = fs.existsSync(legacyIndex);

if (!hasRootIndex && !hasLegacyIndex) {
  throw new Error(
    `No se encontro el build del frontend. Esperado: ${rootIndex} o ${legacyIndex}. ` +
    'Ejecuta npm run build:ui en la carpeta desktop.'
  );
}

const src = hasRootIndex ? buildRoot : legacyBuildRoot;
const dest = path.join(__dirname, '..', 'renderer');

const copyDir = (from, to) => {
  if (!fs.existsSync(from)) {
    throw new Error(`No existe el build en ${from}`);
  }
  fs.mkdirSync(to, { recursive: true });
  for (const entry of fs.readdirSync(from, { withFileTypes: true })) {
    const srcPath = path.join(from, entry.name);
    const destPath = path.join(to, entry.name);
    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
};

if (fs.existsSync(dest)) {
  fs.rmSync(dest, { recursive: true, force: true });
}

copyDir(src, dest);
console.log('Renderer copiado.');
