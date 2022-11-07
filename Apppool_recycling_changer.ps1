Import-Module WebAdministration
Set-ItemProperty -Path "IIS:\AppPools\Example Application Pool" -Name Recycling.periodicRestart.schedule -Value @{value="04:00"}
