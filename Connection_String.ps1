$Site = "korfezhavacilik.com.tr"
$Path = Get-WebFilePath -PSPath "IIS:\Sites\$Site"
$xml = [xml](Get-Content $Path\web.config)
$Smtp = $xml.SelectSingleNode('//add[@key="FormBuilderSMTPServer"]').Value
$SmtpPort = $xml.SelectSingleNode('//add[@key="FormBuilderSMTPServerPort"]').Value
$MailSMTPIP = $xml.SelectSingleNode('//add[@key="MailSMTPIP"]').Value
$MailSMTPPort = $xml.SelectSingleNode('//add[@key="MailSMTPPort"]').Value
$FormBCon = $xml.SelectSingleNode('//add[@key="FormBuilderConnectionString"]').Value
$ConString = $xml.SelectSingleNode('//add[@name="defaultSql"]').connectionString

