$a = New-Object System.Globalization.CultureInfo("en-US")
$csvFileName = "C:\tools\AutoCostAI_Scripting\AutoCostAI.csv"
$classexists = Get-WmiObject -List -Namespace root\cimv2 | select -Property name | where name -like "*Win32_PerfFormattedData_W3SVC*"
if ( $classexists -eq $null )
{
    Install-WindowsFeature Web-Common-Http, Web-Mgmt-Tools
    Restart-Service Winmgmt -Force
  }
Set-Location C:\Windows\System32 | lodctr /R -Force | Out-Null
Set-Location C:\Windows\SysWOW64 | lodctr /R -Force | Out-Null
$ProcessorQueueLength = ([int]((Get-Counter('\System\Processor Queue Length')).countersamples | select -property cookedvalue).cookedvalue).ToString()

$ProcessorTime = ([int]((Get-Counter('\Processor(_Total)\% Processor Time')).countersamples | select -property cookedvalue).cookedvalue).ToString()

$PageFileUsage = (((Get-Counter('\Paging File(_Total)\% Usage')).countersamples | select -property cookedvalue).cookedvalue).ToString("F2", $a)

$MemoryUtilization = (((Get-Counter('\Memory\% Committed Bytes In Use')).countersamples | select -property cookedvalue).cookedvalue).ToString("F2", $a)
    
$Date = Get-Date -Format "dddd MM/dd/yyyy HH:mm K"

$ServerName = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain

$ServiceUptime = (Get-WmiObject -class Win32_PerfFormattedData_W3SVC_WebService -Filter "Name LIKE '_Total'").ServiceUptime

$TotalGetRequests = (Get-WmiObject -class Win32_PerfFormattedData_W3SVC_WebService -Filter "Name LIKE '_Total'").TotalGetRequests

$TotalPutRequests = (Get-WmiObject -class Win32_PerfFormattedData_W3SVC_WebService -Filter "Name LIKE '_Total'").TotalPutRequests

$TotalBytesReceived = (Get-WmiObject -class Win32_PerfFormattedData_W3SVC_WebService -Filter "Name LIKE '_Total'").TotalBytesReceived

$TotalBytesSent = (Get-WmiObject -class Win32_PerfFormattedData_W3SVC_WebService -Filter "Name LIKE '_Total'").TotalBytesSent

$CurrentConnections  = (Get-WmiObject -class Win32_PerfFormattedData_W3SVC_WebService -Filter "Name LIKE '_Total'").CurrentConnections


$props=[ordered]@{
    Date = $Date ; 
    ServerName = $ServerName ; 
    ProcessorQueueLength = $ProcessorQueueLength ; 
    ProcessorTime = $ProcessorTime;
    PageFileUsage = $PageFileUsage ;
    MemoryUtilization = $MemoryUtilization ;
    ServiceUptime = $ServiceUptime;
    TotalGetRequests = $TotalGetRequests;
    TotalPutRequests = $TotalPutRequests;
    TotalBytesReceived = $TotalBytesReceived;
    TotalBytesSent = $TotalBytesSent;
}
New-Object PsObject -Property $props | Export-Csv $csvFileName -NoTypeInformation -Append