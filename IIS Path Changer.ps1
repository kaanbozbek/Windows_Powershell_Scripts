
########################Gerekli dizinleri olusturur########################

New-Item -Path "D:\" -Name "DATA" -ItemType "directory"
New-Item -Path "D:\" -Name "LOGS" -ItemType "directory"
New-Item -Path "D:\LOGS" -Name "APPLOGS" -ItemType "directory"
New-Item -Path "D:\LOGS" -Name "IISLOGS" -ItemType "directory"
New-Item -Path "D:\LOGS" -Name "SYSLOGS" -ItemType "directory"
New-Item -Path "D:\" -Name "WEBSITES" -ItemType "directory"
New-Item -Path "D:\" -Name "WINSERVICES" -ItemType "directory"

########################IIS default log path'leri degistirir########################

Import-Module WebAdministration
Set-WebConfigurationProperty "/system.applicationHost/sites/siteDefaults" -name logfile.directory -value "D:\LOGS\IISLOGS"
Set-WebConfigurationProperty "/system.applicationHost/sites/siteDefaults" -name traceFailedRequestsLogging.directory -value "D:\LOGS\FailedReqLogFiles"
Set-WebConfigurationProperty "/system.applicationHost/log" -name centralW3CLogFile.directory -value "D:\LOGS\IISLOGS"
Set-WebConfigurationProperty "/system.applicationHost/log" -name centralBinaryLogFile.directory -value "D:\LOGS\IISLOGS"

########################HTTPErr log path'i degistirir, sonrasinde net stop http ve start gerekli########################

$myRegKeyBase = "HKLM:\SYSTEM\CurrentControlSet\services\HTTP\Parameters"
$myRegKeyName = "ErrorLoggingDir"
$myRegKeyVal  = "D:\LOGS\SYSLOGS"
$myRC = New-ItemProperty $myRegKeyBase -Name $myRegKeyName -Value $myRegKeyVal -PropertyType String -ErrorAction SilentlyContinue

########################TLS 1.0 ve 1.1 disable eder########################

New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -name 'Enabled' -value '0' -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -name 'DisabledByDefault' -value 1 -PropertyType 'DWord' -Force | Out-Null
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -name 'Enabled' -value '0' -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -name 'DisabledByDefault' -value 1 -PropertyType 'DWord' -Force | Out-Null
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -name 'Enabled' -value '0' -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server' -name 'DisabledByDefault' -value 1 -PropertyType 'DWord' -Force | Out-Null
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -name 'Enabled' -value '0' -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client' -name 'DisabledByDefault' -value 1 -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -name 'SystemDefaultTlsVersions' -value 1 -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' -name 'SchUseStrongCrypto' -value 1 -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -name 'SystemDefaultTlsVersions' -value 1 -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -name 'SchUseStrongCrypto' -value 1 -PropertyType 'DWord' -Force | Out-Null
