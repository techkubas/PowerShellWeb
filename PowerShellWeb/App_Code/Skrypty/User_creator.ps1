$imie = "$input1"
$nazwisko = "$input2"
$password = "$input3"
$title = "$input4"
$dp = "$input5"
$dpnumber = "$input6"
$manager_surname = "$input7"
$managernumber = $input8
$ch = $input9

$username = "$user_input"
$password = "$pass_input"
$password = ConvertTo-SecureString -String $password -asplaintext -Force
$user_credentials = New-Object System.Management.Automation.PSCredential $username,$password

$oued = "OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
$oued_mng = "OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"

$imiel = $imie.ToLower().Normalize("FormD") -replace '\p{M}', ''
$nazwiskol = $nazwisko.ToLower().Normalize("FormD") -replace '\p{M}', ''
$samusername = $imiel + "." + $nazwiskol
$displayname = $imie + " " + $nazwisko
New-ADUser -name($imie + " " + $nazwisko) -GivenName $imie -Surname $nazwisko -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -Credential $user_credentials
Set-ADUser -Identity($imiel + " " + $nazwiskol) -Replace @{samaccountname=$samusername} -Credential $user_credentials
Set-ADUser $samusername -Replace @{ProxyAddresses="SMTP:" + $imiel + "." + $nazwiskol + "@gala-group.com"} -Credential $user_credentials
Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $imiel + "." + $nazwiskol + "@koronacandles.com"} -Credential $user_credentials
Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $imiel + "." + $nazwiskol + "@korona.wielun.pl"} -Credential $user_credentials
Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $pierwszyinicial + "." + $nazwiskol + "@gala-group.com"} -Credential $user_credentials
Set-ADUser $samusername -EmailAddress ($imiel + "." + $nazwiskol + "@gala-group.com") -Credential $user_credentials
if ($dpnumber -ne "") {Set-ADUser $samusername -Replace @{departmentNumber=$dpnumber} -Credential $user_credentials}
if ($title -ne "") {Set-ADUser $samusername -Replace @{title = $title} -Credential $user_credentials}
if ($dp -ne "") {Set-ADUser $samusername -Replace @{department=$dp} -Credential $user_credentials}
if ($displayname -ne "") {Set-ADUser $samusername -Replace @{displayName=$displayname} -Credential $user_credentials}

if (Test-Path "e_id.txt") {
    $id = Get-Content "e_id.txt"
    Set-ADUser $samusername -Replace @{EmployeeID=$id}
}
if (Test-Path "e_nb.txt") {
    $nb = Get-Content "e_nb.txt"
    Set-ADUser $samusername -Replace @{EmployeeNumber=$nb}
}

$managerarray = Get-ADUser -SearchBase $oued_mng -Filter "(sn -eq '$manager_surname')" -Properties department,DistinguishedName | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,department,DistinguishedName
$chosenone = $managerarray[$managernumber].DistinguishedName
Set-ADUser $samusername -Replace @{manager=$chosenone} -Credential $user_credentials

$patharray = Get-ADObject -SearchBase $oued -Filter { ObjectClass -eq 'organizationalunit' } | Where-Object {($_.DistinguishedName | Select-String -NotMatch "OU=Disabled","OU=Distribution Groups","^OU=O365","OU=Skrzynki Udostępnione")} | Select-Object -Property Name,DistinguishedName
$oufinal = $patharray[$ch].DistinguishedName

if ($oufinal -notlike "OU=Korona Candles Inc.,OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl") {
    $def_upn = "@korona.wielun.pl"
    Set-ADUser $samusername -UserPrincipalName ($imiel + "." + $nazwiskol + $def_upn) -Credential $user_credentials
    Set-ADUser $samusername -Replace @{L=”Wieluń”} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{postalCode="98-300"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{st="Łódzkie"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{streetAddress="Fabryczna 10"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{c="PL"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{countryCode="616"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{Company="GALA POLAND Sp. z o.o."} -Credential $user_credentials
    Add-ADGroupMember -Identity "KoronaSp.zo.o" -Members $samusername -Credential $user_credentials
}
else {
    $def_upn = "@koronacandles.com"
    Set-ADUser $samusername -UserPrincipalName ($imiel + "." + $nazwiskol + $def_upn) -Credential $user_credentials
    Set-ADUser $samusername -Replace @{L=”Dublin”} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{postalCode="VA24084"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{st="Virginia"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{streetAddress="3994 Pepperell Way"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{c="US"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{countryCode="840"} -Credential $user_credentials
    Set-ADUser $samusername -Replace @{Company="GALA NORTH AMERICA Inc."} -Credential $user_credentials
    Add-ADGroupMember -Identity "Korona Candles INC" -Members $samusername -Credential $user_credentials
}
Get-ADUser -Identity $samusername | Move-ADObject -TargetPath $oufinal -Credential $user_credentials
New-Item -Name "result.txt" -Value "1" -Force