# ============================================
# RESTAURAR backup de db_cococana
# Ejecutar en tu PC de desarrollo
# ============================================
$ErrorActionPreference = 'Stop'

$pgPassword = 'rey'
$dbName = 'db_cococana'
$pgPort = 5432
$pgUser = 'postgres'

# Buscar psql
$psqlExe = Get-ChildItem 'C:\Program Files\PostgreSQL' -Recurse -Filter psql.exe -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $psqlExe) {
    Write-Host "ERROR: No se encontro psql.exe. Verifica que PostgreSQL este instalado." -ForegroundColor Red
    pause
    exit 1
}
$psqlPath = $psqlExe.FullName

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RESTAURAR BACKUP - Coco & Cana" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Buscar archivos de backup en el escritorio
$backupDir = "$env:USERPROFILE\Desktop\backups_cococana"
$backups = @()

if (Test-Path $backupDir) {
    $backups = Get-ChildItem "$backupDir\backup_*.sql" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
}

# Tambien buscar en el escritorio directamente
$desktopBackups = Get-ChildItem "$env:USERPROFILE\Desktop\backup_*.sql" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
$backups = @($backups) + @($desktopBackups)

if ($backups.Count -eq 0) {
    Write-Host "No se encontraron archivos de backup." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Coloca el archivo backup_XXXX.sql en:" -ForegroundColor Yellow
    Write-Host "  $backupDir" -ForegroundColor Cyan
    Write-Host "  o en el Escritorio" -ForegroundColor Cyan
    Write-Host ""
    pause
    exit 0
}

Write-Host "Backups encontrados:" -ForegroundColor Green
for ($i = 0; $i -lt $backups.Count; $i++) {
    $size = [math]::Round($backups[$i].Length / 1KB, 1)
    Write-Host "  [$i] $($backups[$i].Name) ($size KB)" -ForegroundColor White
}
Write-Host ""

$seleccion = Read-Host "Selecciona el numero del backup a restaurar (0 para el mas reciente)"
$idx = [int]$seleccion

if ($idx -lt 0 -or $idx -ge $backups.Count) {
    Write-Host "Seleccion invalida." -ForegroundColor Red
    pause
    exit 1
}

$archivoBackup = $backups[$idx].FullName
Write-Host ""
Write-Host "Restaurando: $($backups[$idx].Name)" -ForegroundColor Yellow
Write-Host ""
Write-Host "ATENCION: Esto REEMPLAZA todos los datos actuales de $dbName" -ForegroundColor Red
$confirmar = Read-Host "Escribi 'SI' para continuar"

if ($confirmar -ne 'SI') {
    Write-Host "Cancelado." -ForegroundColor Yellow
    pause
    exit 0
}

$env:PGPASSWORD = $pgPassword

# Eliminar y recrear la base de datos
Write-Host ""
Write-Host "Eliminando base de datos existente..." -ForegroundColor Yellow
& $psqlPath -U $pgUser -p $pgPort -h localhost -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$dbName' AND pid <> pg_backend_pid();" 2>$null
& $psqlPath -U $pgUser -p $pgPort -h localhost -d postgres -c "DROP DATABASE IF EXISTS $dbName;"
& $psqlPath -U $pgUser -p $pgPort -h localhost -d postgres -c "CREATE DATABASE $dbName;"

Write-Host "Restaurando datos..." -ForegroundColor Yellow
& $psqlPath -U $pgUser -p $pgPort -h localhost -d $dbName -f $archivoBackup 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "RESTAURACION EXITOSA!" -ForegroundColor Green
    Write-Host "Tu base de datos ahora tiene los mismos datos que la empresa." -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "Restauracion completada (puede haber warnings normales)." -ForegroundColor Yellow
}

Write-Host ""
pause
