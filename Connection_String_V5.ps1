Import-Module WebAdministration
$Websites = Get-ChildItem IIS:\Sites
$csvFileName = "C:\db40.csv"
function constringf {
$items = foreach ($Site in $Websites) {
$Path = $Site.PhysicalPath
$Files = Get-ChildItem -Path $Path -Include appsettings.json, web.config -Name
foreach ($File in $Files) {
        $Conf = Get-ChildItem -Path $Path -File -Filter $File | % { $_.FullName }
             if($File -eq "web.config") {

                  $xml = [xml](Get-Content $Conf)
                  $xml1 = "1"
                  $Smtp = $xml.SelectSingleNode('//add[@key="FormBuilderSMTPServer"]').Value
                  $SmtpPort = $xml.SelectSingleNode('//add[@key="FormBuilderSMTPServerPort"]').Value
                  $MailSMTPIP = $xml.SelectSingleNode('//add[@key="MailSMTPIP"]').Value
                  $MailSMTPPort = $xml.SelectSingleNode('//add[@key="MailSMTPPort"]').Value
                  $FormBCon = $xml.SelectSingleNode('//add[@key="FormBuilderConnectionString"]').Value
                  $ConnStr = $xml.SelectSingleNode('//add[@key="ConnStr"]').Value
                  $ConString = $xml.SelectSingleNode('//add[@name="defaultSql"]').connectionString
                  $CMSContext = $xml.SelectSingleNode('//add[@key="CMSContext"]').Value 
                  $EuroCMS = $xml.SelectSingleNode('//add[@name="eurocms.db"]').connectionString
                  $EndPoint = $xml.configuration.'system.serviceModel'.client.endpoint.address

      
                  Write-Host "SiteName "$Site.name
                  Write-Host "Source" $Files
                  Write-Host "Smtp "$Smtp
                  Write-Host "SmtpPort "$SmtpPort 
                  Write-Host "MailSMTPIP "$MailSMTPIP 
                  Write-Host "FormBCon  "$FormBCon 
                  Write-Host "ConString "$ConString 
                  Write-Host "EndPoint "$EndPoint
				  Write-Host "EuroCMS" $EuroCMS
				  Write-Host "Constr"$ConnStr


				  $props=[ordered]@{
      			  SiteName = $Site.name ;
				  Smtp = $Smtp ;
				  SmtpPort  = $SmtpPort ;
				  MailSMTPIP = $MailSMTPIP ;
				  MailSMTPPort = $MailSMTPPort
				  FormBCon = $FormBCon;
				  ConString = $ConString ;
				  EndPoint = $EndPoint ;
                  File = $Files ;
                  EuroCMS = $EuroCMS ;
                  Constr = $ConnStr ;
                  CMSContext = $CMSContext ;
                  xml1 = $xml1.ConnectionStrings ;
                  
				}

                 New-Object PsObject -Property $props | Export-Csv $csvFileName -NoTypeInformation -Append

        
            }

            elseif ($File -eq "appsettings.json") { 
                 Write-Host "--Json--"
                 Write-Host $Conf
                 $xml1 = (Get-Content $Conf | Out-String | ConvertFrom-Json)
                 Write-Host "ConString "($xml1.ConnectionStrings)
				 $props=[ordered]@{
				 SiteName = $Site.name ;
		         xml1 = $xml1.ConnectionStrings ;
					
				}
				
                New-Object PsObject -Property $props | Export-Csv $csvFileName -NoTypeInformation -Append

            }      
            
            else {Continue}

             $props=[ordered]@{
      			  SiteName = $Site.name ;
				  Smtp = $Smtp ;
				  SmtpPort  = $SmtpPort ;
				  MailSMTPIP = $MailSMTPIP ;
				  MailSMTPPort = $MailSMTPPort
				  FormBCon = $FormBCon;
				  ConString = $ConString ;
				  EndPoint = $EndPoint ;
                  File = $Files ;
                  EuroCMS = $EuroCMS ;
                  Constr = $ConnStr ;
                  CMSContext = $CMSContext ;
                  xml1 = $xml1.ConnectionStrings ;
                  
				}
            
            New-Object PsObject -Property $props | Export-Csv $csvFileName -NoTypeInformation -Append
 
            }
			
			
	            $props=[ordered]@{
				SiteName = $Site.name ;
				Smtp = $Smtp ;
				SmtpPort  = $SmtpPort ;
				MailSMTPIP = $MailSMTPIP ;
				MailSMTPPort = $MailSMTPPort
				FormBCon = $FormBCon;
				ConString = $ConString ;
				EndPoint = $EndPoint ;
                File = $Files ;
                Conf = $Conf ;
                xml1 = $xml1.ConnectionStrings ;
                EuroCMS = $EuroCMS ;
                Constr = $ConnStr ;
                CMSContext = $CMSContext ;
                
					
				}
				
                		


            }

             $props=[ordered]@{
      			  SiteName = $Site.name ;
				  Smtp = $Smtp ;
				  SmtpPort  = $SmtpPort ;
				  MailSMTPIP = $MailSMTPIP ;
				  MailSMTPPort = $MailSMTPPort
				  FormBCon = $FormBCon;
				  ConString = $ConString ;
				  EndPoint = $EndPoint ;
                  File = $Files ;
                  EuroCMS = $EuroCMS ;
                  Constr = $ConnStr ;
                  CMSContext = $CMSContext ;
                  xml1 = $xml1.ConnectionStrings ;
                                  
				}

New-Object PsObject -Property $props | Export-Csv $csvFileName -NoTypeInformation -Append
			
}


constringf


