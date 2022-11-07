$OFS = "`n"
[string[]] $Uygulama= @()
$Uygulama = READ-HOST "Silinecek Uygulama Adını Giriniz"
$Uygulama = $Uygulama.Split(',').Split(' ')
ForEach ($UygulamaAd in $Uygulama)
{
Remove-WebAppPool $UygulamaAd
Remove-WebSite $UygulamaAd
}