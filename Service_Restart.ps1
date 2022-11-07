$server = (Get-Item env:\Computername).Value
Get-WmiObject win32_service -ComputerName $server -Filter "startmode = 'auto' AND state != 'running' AND name != 'sppsvc'" | Invoke-WmiMethod -Name StartService
$stoppedServices = Get-WmiObject win32_service -ComputerName $server -Filter "startmode = 'auto' AND state != 'running' AND name != 'sppsvc'" | select -expand Name
Write-Host "$env:ComputerName : Stopped Services: $stoppedServices"
foreach ($stoppedService in $stoppedServices) {
Write-Host -NoNewline "Starting Server/Service: "; Write-Host -ForegroundColor Green $server"/"$stoppedService
Start-Service -Name $stoppedService
}