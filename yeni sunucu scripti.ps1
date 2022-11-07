########################IIS web feature'lari ve AppDev feature'larini yukler########################

Install-WindowsFeature Web-Net-Ext45, Web-AppInit, Web-ASP, Web-Asp-Net45, Web-CGI, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Includes | Out-Null
Install-WindowsFeature Web-Common-Http, Web-Health, Web-Performance, Web-Security, Web-Mgmt-Tools -IncludeAllSubFeature | Out-Null

########################Apppool default ayarlari########################

Import-Module WebAdministration
Set-WebConfigurationProperty "/system.applicationHost/applicationPools/applicationPoolDefaults/processModel" -name "idleTimeout" -value "00:00:00"
Set-WebConfigurationProperty "/system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart" -name "time" -value "0.00:00:00"
Set-WebConfigurationProperty "/system.applicationHost/applicationPools/applicationPoolDefaults/recycling/periodicRestart/schedule" -name "." -value @{value='04:00:00'}
Set-WebConfigurationProperty "/system.applicationHost/applicationPools/applicationPoolDefaults" -name "startMode" -value "AlwaysRunning"

########################Clickjacking, slowpost gibi ataklara karsi gerekli default site ayarlari########################

Clear-WebConfiguration "/system.webServer/httpProtocol/customHeaders/add[@name='X-Powered-By']"
Add-WebConfigurationProperty "/system.webServer/httpProtocol/customHeaders" -name "." -AtElement @{name='X-Frame-Options'; value='SAMEORIGIN'}
Add-WebConfigurationProperty "/system.webServer/httpProtocol/customHeaders" -name "." -AtElement @{name='X-Content-Type-Options'; value='nosniff'}
Add-WebConfigurationProperty "/system.webServer/httpProtocol/customHeaders" -name "." -AtElement @{name='Content-Security-Policy'; value='frame-ancestors ''self'''}
Set-WebConfigurationProperty "/system.webServer/security/requestFiltering" -name "removeServerHeader" -value "true"
Set-WebConfigurationProperty "/system.webServer/security/requestFiltering/requestLimits" -name "maxQueryString" -value 1024
Set-WebConfigurationProperty "/system.webServer/security/requestFiltering/requestLimits" -name "maxUrl" -value 2048
Set-WebConfigurationProperty "/system.webServer/security/authentication/anonymousAuthentication" -name userName -value ""

########################Default Apppool ve Website'i siler########################

$User = [Security.Principal.WindowsIdentity]::GetCurrent()
$Role = ( New-Object Security.Principal.WindowsPrincipal $user ).IsInRole( [Security.Principal.WindowsBuiltinRole]::Administrator )
if ( -not $Role )
{
    Write-Warning "To perform some operations you must run an elevated Windows PowerShell console."
}
else
{
    Get-WebSite -Name "Default Web Site" | Remove-WebSite -Confirm:$false -Verbose
    Remove-WebAppPool -Name "DefaultAppPool" -Confirm:$false -Verbose
}

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
