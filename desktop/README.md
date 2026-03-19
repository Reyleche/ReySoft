# ReySoft Coco&Cana - Desktop

## Requisitos
- Windows 10/11
- Acceso a internet (para descargar Postgres durante la instalacion)

## Build del instalador
1) Instala dependencias del desktop:
   - cd desktop
   - npm install
2) Construye el instalador:
   - npm run dist

3) Construye instalador con nueva versión automática (recomendado):
   - npm run dist:versioned

Esto generara el instalador en desktop/dist.
