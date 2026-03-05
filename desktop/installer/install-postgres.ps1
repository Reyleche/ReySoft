$ErrorActionPreference = 'Stop'

$postgresPassword = 'rey'
$dbName = 'db_cococana'
$pgPort = 5432

function Find-Psql {
  $paths = Get-ChildItem 'C:\Program Files\PostgreSQL' -Recurse -Filter psql.exe -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($paths) { return $paths.FullName }
  return $null
}

$psql = Find-Psql
if (-not $psql) {
  $installerUrl = 'https://get.enterprisedb.com/postgresql/postgresql-16.3-1-windows-x64.exe'
  $installerPath = "$env:TEMP\postgresql-installer.exe"
  Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
  $args = "--mode unattended --superpassword `"$postgresPassword`" --serverport $pgPort"
  Start-Process -FilePath $installerPath -ArgumentList $args -Wait
  $psql = Find-Psql
}

if (-not $psql) {
  throw 'No se pudo instalar Postgres.'
}

$env:PGPASSWORD = $postgresPassword
$checkDb = & $psql -U postgres -p $pgPort -h localhost -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$dbName'"
if (-not $checkDb) {
  & $psql -U postgres -p $pgPort -h localhost -d postgres -c "CREATE DATABASE $dbName;"
}
