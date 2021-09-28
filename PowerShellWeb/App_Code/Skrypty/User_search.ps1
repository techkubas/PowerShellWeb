$nazwisko = "$input1"
$oued_mng = "OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
$array = Get-ADUser -SearchBase $oued_mng -Filter "(sn -eq '$nazwisko')" -Properties department,DistinguishedName | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,department,DistinguishedName
$pog = ''
$temp1 = ''
$temp2 = ''
foreach ($line in $array) {
    $temp1 = $line.name
    $temp2 = $line.department
	$pog += $temp1," - ",$temp2,"`n"
}
New-Item -Name "result.txt" -Value $pog -Force