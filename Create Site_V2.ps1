Import-Module WebAdministration
$SiteName = "DERP50"
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
$User = "IIS AppPool\$SiteName"  
$Acl = Get-Acl $SitePath  
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($User,"FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")  
$Acl.SetAccessRule($Ar)  
Set-Acl $SitePath $Acl  