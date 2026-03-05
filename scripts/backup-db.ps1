# ============================================
# BACKUP de la base de datos db_cococana
# Ejecutar en la laptop de la empresa (ASUS)
# ============================================
$ErrorActionPreference = 'Stop'

$pgPassword = 'rey'
$dbName = 'db_cococana'
$pgPort = 5432
$pgUser = 'postgres'

# Buscar pg_dump
$pgDump = Get-ChildItem 'C:\Program Files\PostgreSQL' -Recurse -Filter pg_dump.exe -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $pgDump) {
    Write-Host "ERROR: No se encontro pg_dump.exe. Verifica que PostgreSQL este instalado." -ForegroundColor Red
    pause
    exit 1
}

$pgDumpPath = $pgDump.FullName

# Crear carpeta de backups
$backupDir = "$env:USERPROFILE\Desktop\backups_cococana"
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

# Nombre del archivo con fecha y hora
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = "$backupDir\backup_${timestamp}.sql"

Write-Host "========================================" -ForegroundColor Green
Write-Host "  BACKUP - Coco & Cana" -ForegroundColor Green  
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Base de datos: $dbName"
Write-Host "Archivo: $backupFile"
Write-Host ""

$env:PGPASSWORD = $pgPassword

# Ejecutar pg_dump
& $pgDumpPath -U $pgUser -p $pgPort -h localhost -d $dbName -F p -f $backupFile

if ($LASTEXITCODE -eq 0) {
    $size = [math]::Round((Get-Item $backupFile).Length / 1KB, 1)
    Write-Host ""
    Write-Host "BACKUP EXITOSO!" -ForegroundColor Green
    Write-Host "Archivo: $backupFile ($size KB)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Opciones para enviar a tu otra laptop:" -ForegroundColor Yellow
    Write-Host "  1. Copia este archivo a una USB"
    Write-Host "  2. Subelo a Google Drive / WhatsApp"
    Write-Host "  3. Envialo por la red local"
    Write-Host ""
} else {
    Write-Host "ERROR al crear el backup." -ForegroundColor Red
}

pause
