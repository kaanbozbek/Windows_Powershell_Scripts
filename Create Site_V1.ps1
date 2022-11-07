Import-Module WebAdministration
$SiteName = "DERP30"
New-Item -Path "D:\WEBSITES" -Name $SiteName -ItemType "directory"
$SitePath = "D:\WEBSITES\$SiteName"
New-Item -Path IIS:\AppPools\$SiteName
New-WebSite -Name $SiteName -PhysicalPath $SitePath -Force
$IISSite = "IIS:\Sites\$SiteName"
$HostIP = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.DHCPEnabled -ne $null -and $_.DefaultIPGateway -ne $null}).IPAddress
Set-ItemProperty $IISSite -name  Bindings -value @{protocol="http";bindingInformation="*:80:$SiteName"}
Set-ItemProperty $IISSite applicationPool $SiteName
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "$HostIP $SiteName" -Force
$Acl = Get-Acl "$SitePath"
$Rule = New-Object System.Security.AccessControl.FileSystemAccessRule ('IIS_IUSRS', 'FullControl', 'ContainerInherit, ObjectInherit', 'InheritOnly', 'Allow')
$Acl.SetAccessRule($Rule)
$Acl | Set-Acl "$SitePath"

$RemoteServer = "DGNLDMZWEBT1"
$RemoteWorkingPath = "\\" + $RemoteServer + "\" + $Value + "\"
$Value = 
$Websites = Get-ChildItem IIS:\Sites
$Path = $Site.PhysicalPath
robocopy \\$Path $SitePath /zb /z /e /v /r:1 /w:1 