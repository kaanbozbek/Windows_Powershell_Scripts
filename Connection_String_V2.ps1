Import-Module WebAdministration
$Websites = Get-ChildItem IIS:\Sites
foreach ($Site in $Websites) {
$Path = $Site.PhysicalPath
$Files = Get-ChildItem -Path $Path -Include appsettings.json, web.config -Name
foreach ($File in $Files) {
        $Conf = Get-ChildItem -Path $Path -File -Filter $File | % { $_.FullName }
             if($File -eq "web.config") {
                  $xml = [xml](Get-Content $Conf)
                  $Smtp = $xml.SelectSingleNode('//add[@key="FormBuilderSMTPServer"]').Value
                  $SmtpPort = $xml.SelectSingleNode('//add[@key="FormBuilderSMTPServerPort"]').Value
                  $MailSMTPIP = $xml.SelectSingleNode('//add[@key="MailSMTPIP"]').Value
                  $MailSMTPPort = $xml.SelectSingleNode('//add[@key="MailSMTPPort"]').Value
                  $FormBCon = $xml.SelectSingleNode('//add[@key="FormBuilderConnectionString"]').Value
                  $ConString = $xml.SelectSingleNode('//add[@name="defaultSql"]').connectionString
                  $EndPoint = $xml.configuration.'system.serviceModel'.client.endpoint.address
        
                  Write-Host "SiteName "$Site.name
                  Write-Host "Source" $Files
                  Write-Host "Smtp "$Smtp
                  Write-Host "SmtpPort "$SmtpPort 
                  Write-Host "MailSMTPIP "$MailSMTPIP 
                  Write-Host "FormBCon  "$FormBCon 
                  Write-Host "ConString "$ConString 
                  Write-Host "EndPoint "$EndPoint
        
            }

            elseif ($File -eq "appsettings.json") { 
                 Write-Host "--Json--"
                 Write-Host $Conf
                 $xml1 = (Get-Content $Conf | Out-String | ConvertFrom-Json)
                 Write-Host "ConString "($xml1.ConnectionStrings)

            }      
            
            else {Continue}

 
            }

            }

