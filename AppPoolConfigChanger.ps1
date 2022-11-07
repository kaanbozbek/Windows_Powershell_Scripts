Import-Module WebAdministration
Set-ItemProperty -Path "IIS:\AppPools\*" -Name Recycling.periodicRestart.schedule -Value @{value="03:00"}
Set-ItemProperty "IIS:\AppPools\*" -Name Recycling.periodicRestart.time -Value 0.00:00:00
Set-WebConfigurationProperty "/system.applicationHost/applicationPools/applicationPoolDefaults" -name "startMode" -value "AlwaysRunning"
Set-ItemProperty -Path "IIS:\AppPools\*" -name "cpu.limit" -value 0
Set-ItemProperty -Path "IIS:\AppPools\*" -name "startMode" -value "AlwaysRunning"
