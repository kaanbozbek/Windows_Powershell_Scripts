Import-Module WebAdministration
$Websites = Get-ChildItem IIS:\Sites
$Data = foreach ($Site in $Websites) {
  Write-Host $Site.name
  $Path = Get-ChildItem -Path ‪IIS:\Sites\$Site\web.config  
  $xml = [xml](Get-Content $Path)
  $Smtp = $xml.SelectSingleNode('//add[@key="FormBuilderSMTPServer"]').Value
  $SmtpPort = $xml.SelectSingleNode('//add[@key="FormBuilderSMTPServerPort"]').Value
  $MailSMTPIP = $xml.SelectSingleNode('//add[@key="MailSMTPIP"]').Value
  $MailSMTPPort = $xml.SelectSingleNode('//add[@key="MailSMTPPort"]').Value
  $FormBCon = $xml.SelectSingleNode('//add[@key="FormBuilderConnectionString"]').Value
  $ConString = $xml.SelectSingleNode('//add[@name="defaultSql"]').connectionString
  Write-Host $Smtp $SmtpPort $ConString
}

