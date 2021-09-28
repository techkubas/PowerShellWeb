$reciver_surname = "$input1"
$reciver_number = $input2
$donor_surname = "$input3"
$donor_number = $input4

$username = "$user_input"
$password = "$pass_input"
$password = ConvertTo-SecureString -String $password -asplaintext -Force
$user_credentials = New-Object System.Management.Automation.PSCredential $username,$password

$oued_mng = "OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
$array = Get-ADUser -SearchBase $oued_mng -Filter "(sn -eq '$donor_surname')" -Properties department,DistinguishedName -Credential $user_credentials | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,department,DistinguishedName,SamAccountName
$donor_san = $array[$donor_number].SamAccountName
$donor_name = $array[$donor_number].Name

$array = Get-ADUser -SearchBase $oued_mng -Filter "(sn -eq '$reciver_surname')" -Properties department,DistinguishedName -Credential $user_credentials | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,department,DistinguishedName,SamAccountName
$reciver_san = $array[$reciver_number].SamAccountName
$reciver_name = $array[$reciver_number].Name

$temp = ''
$groups_to_copy = (Get-ADUser $donor_san -Properties memberof).memberof
    foreach ($group in $groups_to_copy) {
        $group | Add-ADGroupMember -Members $reciver_san
        $group_name = (Get-ADGroup $group).name
        $temp += "Dodano $reciver_name do grupy $group_name`n"
    }

New-Item -Name "result.txt" -Value $temp -Force