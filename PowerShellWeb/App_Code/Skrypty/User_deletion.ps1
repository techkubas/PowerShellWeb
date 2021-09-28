$nazwisko = "$input1"
$index = "$input2"

$username = "$user_input"
$password = "$pass_input"
$password = ConvertTo-SecureString -String $password -asplaintext -Force
$user_credentials = New-Object System.Management.Automation.PSCredential $username,$password

$oufinal = "OU=Disabled,OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"

$oued_mng = "OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
$array = Get-ADUser -SearchBase $oued_mng -Filter "(sn -eq '$nazwisko')" -Properties department,DistinguishedName | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,department,DistinguishedName
$deleted_san = $array[$index]

Get-ADUser -Identity $samusername | Move-ADObject -TargetPath $oufinal -Credential $user_credentials
Set-ADUser $samusername -Clear MemberOf -Credential $user_credentials
Set-ADUser $samusername -Replace @{manager="Administrator"} -Credential $user_credentials