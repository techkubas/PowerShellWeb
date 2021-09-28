$manager_surname = $input1
$oued_mng = "OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
$managerarray = Get-ADUser -SearchBase $oued_mng -Filter "(sn -eq '$manager_surname')" -Properties department,DistinguishedName | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,department,DistinguishedName
$pog = ''
foreach ($line in $managerarray.name) {
	$pog += $line,"`n"
}
New-Item -Name "result.txt" -Value $pog -Force