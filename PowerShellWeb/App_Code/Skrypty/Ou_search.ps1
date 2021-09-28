$oued = "OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
$ou = Get-ADObject -SearchBase $oued -Filter { ObjectClass -eq 'organizationalunit' } | Where-Object {($_.DistinguishedName | Select-String -NotMatch "OU=Disabled","OU=Distribution Groups","^OU=O365","OU=Skrzynki Udostępnione")} | Select-Object -Property Name,DistinguishedName
$pog = ""
foreach ($line in $ou.name) {
	$pog += $line,"`n"
}
New-Item -Name "result.txt" -Value $pog -Force