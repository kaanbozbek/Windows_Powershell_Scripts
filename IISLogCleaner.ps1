Set-ExecutionPolicy RemoteSigned
Start-Process powershell.exe -verb runas -ArgumentList "-file C:\IISLogcleaner\conf.ps1"