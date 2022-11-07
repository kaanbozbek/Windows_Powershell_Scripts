Install-Module -Name ImportExcel -Scope CurrentUser
param (
     [string] $param1,
     [string] $param2
    
     )


"------------------------------------------`nScript Started Date => $(Get-Date) `n------------------------------------------" | Out-File Telnet-Results.txt -Append
"------------------------------------------`nScript Started Date => $(Get-Date) `n------------------------------------------" | Out-File Telnet-Errors.txt -Append

    try {
        $connection = New-Object System.Net.Sockets.TcpClient($param1.TrimEnd(), $param2)
        if ($connection.Connected) {
            Write-Host $param1 "|" $param2 "=> Success" 
            Out-File "Telnet-Results.txt" -InputObject "$($param1) - $($param2) => Success" -Append
        }
        else { 
            Write-Host $param1 "|" $param2 "=> Failed" 
            Out-File "Telnet-Results.txt" -InputObject "$($param1) - $($param2) => Failed" -Append
            Out-File "Telnet-Errors.txt" -InputObject "$($param1) - $($param2) => Failed" -Append
        }
    }
    catch [Exception] {
        Write-Host $param1 "|" $param2 "=> Timeout" 
        # Write-Host $_.Exception.GetType().FullName 
        # Write-Host $_.Exception.Message 
        Out-File "Telnet-Results.txt" -InputObject "$($param1) - $($param2) => Timeout" -Append
        Out-File "Telnet-Errors.txt" -InputObject "$($param1) - $($param2) => $($_.Exception.GetType().FullName) | $($_.Exception.Message) " -Append
    }

"------------------------------------------ `n" | Out-File Telnet-Results.txt -Append
"------------------------------------------ `n" | Out-File Telnet-Errors.txt -Append
