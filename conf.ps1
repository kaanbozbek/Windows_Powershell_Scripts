$RarDaysBefore = -20 # ziplenen dosyaların saklanacağı gün
$seachString="XblAuthManager" #service restart edilecekse ilgili servisin display name'inde  aranacak pattern
$serviceRestart= 1 # servis retsart edilecek ise 1
$DaysBefore = -10  #Parametrik gün değeri
$staticLogPath="C:\\EuroApps\\Logs\\" # sabit loglarin silineceği path
$log_file = "C:\\IISLogcleaner\\logs\\IISLogcleaner_" + (Get-Date -f yyyy-MM-dd_HH-mm) + ".log" #powershell'in log atacağı path
$FormattedDate = Get-Date -Format "yyyyMMdd" 
$taskName = "LogCleanbyPowershell"

###################################################################################


  function delLog ( [string]$file)

  {
  Write-Log("$file icin silme baslatildi.")
    Get-ChildItem $file -Force -Recurse -Attributes !Hidden, !System, !ReparsePoint -Include *.log, *.err, *.txt  | where {$_.lastwritetime -lt (get-date).adddays($DaysBefore)} | Remove-Item -force
  }

######################################################  

function Zip-Logs([string]$file)
{
   Get-ChildItem $file -Force -Recurse -Attributes !Hidden, !System, !ReparsePoint -Include  *.zip  | where {$_.lastwritetime -lt (get-date).adddays($RarDaysBefore)} | Remove-Item -force
  foreach($file in Get-ChildItem -Path $logpath -Filter *log | Where{$_.LastWriteTime -lt (Get-Date).AddDays($RarDaysBefore)} |  %{$_.FullName})
    {
       
     try {
          if ( -not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) 
           {
              Write-Log("$env:ProgramFiles\7-Zip\7z.exe needed, must be installed")
              throw "$env:ProgramFiles\7-Zip\7z.exe needed, must be installed"
      
           }
              set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
 
                    Write-Log("zipleme baslatildi.")
                        $zipfile = $file.Replace(".log",".zip")
                        $zipfile
                        sz  -mx=9 a "$zipfile" "$file" 
                        
                        Remove-Item $file -ErrorAction SilentlyContinue
                        
           }

      catch [Exception]
        {
  
	       Write-Log($_.Exception.GetType().FullName+"  "+ $_.Exception.Message)

             continue;

           }
      
        }
     
     
  }
  #######################################


  function IISLog
  {
               
                Import-Module WebAdministration
                
                #Start-Process -Wait -FilePath $mypath\"7z1900-x64.exe" -ArgumentList '/S','/v','/qn' -passthru
                
                foreach($WebSite in $(get-website))
                    {
                   
                
                       $logFile="$($Website.logFile.directory)".replace("%SystemDrive%",$env:SystemDrive).ToString()
                      
                       if ( Test-Path $logFile)
                    
                   {
                   # Write-Log($WebSite.name)
                 
                      $logpath=$logFile
                      
                      delLog($logpath)
                
                      Zip-Logs($logpath)
                
                   }
                
                      }
  }


  

  #########################################################################################



function Write-Log 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
        [string]$Message, 
 
        [Parameter(Mandatory=$false)] 
        [Alias('LogPath')] 
        [string]$Path=$log_file, 
         
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
         
        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 
 
    Begin 
    { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    Process 
    { 
         
        # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $Path) -AND $NoClobber) { 
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $Path)) { 
            Write-Verbose "Creating $Path." 
            
            $NewLogFile = New-Item $Path -Force -ItemType File 
            } 
 
        else { 
            # Nothing to see here yet. 
            } 
 
        # Format Date for our Log File 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
 
        # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                $LevelText = 'ERROR:' 
                } 
            'Warn' { 
                Write-Warning $Message 
                $LevelText = 'WARNING:' 
                } 
            'Info' { 
                Write-Verbose $Message 
                $LevelText = 'INFO:' 
                } 
            } 
         
        # Write log entry to $Path 
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append 
    } 
    End 
    { 
    } 
}
########################################



function serviceRestart 
{ 


 try {
  
          Get-Service | Where-Object {$_.Status -eq "Running"} |ForEach-Object {
          
             
          if ($_.DisplayName.ToLower()  -match $seachString) 
          {
          
             if ( $_.StartType.ToString() -eq "Automatic")
             {
               $srv=$_.DisplayName.ToLower().ToString()
               write-host $srv -ForegroundColor Green
          
               Get-Service $srv | Stop-Service -Force 
               Write-Log($srv+" servisi durduruldu.")
          
              Get-Service $srv | Start-Service 
          
                Write-Log($srv+" servisi baslatildi.")
             }

          }
         delLog($logfile)
          
          }

}
catch [Exception]
  {
  
	       Write-Log($_.Exception.GetType().FullName+"  "+ $_.Exception.Message)
		  
  }
	       Write-Log("Log silme islemi tamamlandi.")
}

function taskSchedule 
   {
      try {
      
      $taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }
      
      if($taskExists) 
      {

        Write-Log("$taskName  already exists") 

      } 
      else 
      {
      $principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
     $action = New-ScheduledTaskAction -Execute 'Powershell.exe'  '–ExecutionPolicy RemoteSigned –File C:\\IISLogcleaner\\IISLogcleaner.ps1'
     
      $trigger =  New-ScheduledTaskTrigger -Daily -At 9am

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "IISLogClean" -Description "Daily IIS Log clean Job" -Principal $principal

     
 


      }

         
    }
    catch [Exception]{

      Write-Log($_.Exception.GetType().FullName+"  "+ $_.Exception.Message)
      
    }
          
    }
#powershell.exe -ExecutionPolicy Bypass -File C:\Users\dtdmzadmin\Desktop\logcleaner.ps1


#taskSchedule #task scheduler eklenmek isteniyorsa burası açılması lazım
IISLog #IISLog silinmesi isteniyorsa buranın açılması lazım
#serviceRestart # Windows Service restart edilmesi gerekiyorsa buranın açılması lazım
#delLog($staticLogPath) # Static log path silinmesi gerekiyorsa buranın açılması lazım.