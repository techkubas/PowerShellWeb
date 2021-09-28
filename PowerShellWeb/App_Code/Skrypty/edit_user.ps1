$imie = "$input1"
$nazwisko = "$input2"

$username = "$user_input"
$password = "$pass_input"
$password = ConvertTo-SecureString -String $password -asplaintext -Force
$user_credentials = New-Object System.Management.Automation.PSCredential $username,$password

$imiel = $imie.ToLower().Normalize("FormD") -replace '\p{M}', ''
$nazwiskol = $nazwisko.ToLower().Normalize("FormD") -replace '\p{M}', ''
$samusername = $imiel + "." + $nazwiskol

if (Test-Path "edit_title.txt") {
	$title = Get-Content "edit_title.txt"
	Set-ADUser $samusername -Replace @{title = $title} -Credential $user_credentials
}
if (Test-Path "edit_department.txt") {
	$department = Get-Content "edit_department.txt"
	Set-ADUser $samusername -Replace @{department=$department} -Credential $user_credentials
}
if (Test-Path "edit_department_number.txt") {
	$dp_nb = Get-Content "edit_department_number.txt"
	Set-ADUser $samusername -Replace @{departmentNumber=$dp_nb} -Credential $user_credentials
}
if (Test-Path "edit_upn.txt") {
	$upn_name = Get-Content "edit_upn.txt"
	$new_principalname = $samusername + $upn_name
	Set-ADUser $samusername -UserPrincipalName $new_principalname
}
if (Test-Path "edit_password.txt") {
	$new_password = Get-Content "edit_password.txt"
	$new_password = ConvertTo-SecureString -String $new_password -AsPlainText -Force
	Set-ADAccountPassword -Identity $samusername -Reset -NewPassword $new_password
}