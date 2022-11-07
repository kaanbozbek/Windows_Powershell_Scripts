Import-Module WebAdministration
$skipPools = @("DefaultAppPool", "Classic .NET AppPool", ".NET v2.0 Classic", ".NET v2.0", ".NET v4.5 Classic", ".NET v4.5")
foreach($apppool in (Get-Item IIS:\AppPools\*).Name) {
	if($skipPools.Contains($apppool)) {
		continue
	}
	$recycling = (Get-ItemProperty ("IIS:\AppPools\${apppool}") -Name Recycling.periodicRestart.schedule.collection) | select value
	if($recycling) {
		foreach($value in $((Get-ItemProperty ("IIS:\AppPools\${apppool}") -Name Recycling.periodicRestart.schedule.collection) | select value)) {
			write-output "${apppool} periodicRestart schedule at: $value"
		}
	}
}