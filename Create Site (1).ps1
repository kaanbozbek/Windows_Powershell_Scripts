Import-Module WebAdministration
$SiteName = "DERP"
New-Item -Path "D:\WEBSITES" -Name $SiteName -ItemType "directory"
$SitePath = "D:\WEBSITES\$SiteName"
New-Item -Path IIS:\AppPools\$SiteName
New-WebSite -Name $SiteName -PhysicalPath $SitePath -Force
$IISSite = "IIS:\Sites\$SiteName"
Set-ItemProperty $IISSite -name  Bindings -value @{protocol="http";bindingInformation="*:80:$SiteName"}
Set-ItemProperty $IISSite applicationPool $SiteName