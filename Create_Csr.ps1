param (
     [string] $param1,
     [string] $param2,
     [string] $param3,
     [string] $param4,
     [string] $param5
     )

Write-Host "Creating CertificateRequest(CSR) for $param1 `r "
Write-Host $param1, $param2, $param3 $param4 $param5

$CSRPath = "c:\" + $param1 + ".csr"
$INFPath = "c:\" + $param1 + ".inf"
$Signature = '$Windows NT$' 

$INF =
@"
[Version]
Signature= "$Signature" 

[NewRequest]
Subject = "CN=$param1, OU=$param2, O=$param3, L=$param4, C=$param5"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
MachineKeySet = TRUE
SMIME = False
PrivateKeyArchive = FALSE
UserProtected = FALSE
UseExistingKeySet = FALSE
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ProviderType = 12
RequestType = PKCS10
KeyUsage = 0xa0

[EnhancedKeyUsageExtension]

OID=1.3.6.1.5.5.7.3.1 
"@

write-Host "Certificate Request is being generated `r "
$INF | out-file -filepath $INFPath -force
certreq -new $INFPath $CSRPath


write-output "Certificate Request has been generated"

Copy-Item $CSRPath -Destination '\\tsclient\C\'