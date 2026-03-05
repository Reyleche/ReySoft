!macro customInstall
  DetailPrint "Instalando PostgreSQL..."
  ExecWait '"$WINDIR\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" -ExecutionPolicy Bypass -File "$INSTDIR\\resources\\installer\\install-postgres.ps1"'
!macroend
