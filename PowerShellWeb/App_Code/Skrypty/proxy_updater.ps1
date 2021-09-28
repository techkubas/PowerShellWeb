$imie = "$input1"
$nazwisko = "$input2"

$imiel = $imie.ToLower().Normalize("FormD") -replace '\p{M}', ''
$nazwiskol = $nazwisko.ToLower().Normalize("FormD") -replace '\p{M}', ''
$pierwszyinicial = $imie.Substring(0, 1).ToLower()

$username = "$user_input"
$password = "$pass_input"
$password = ConvertTo-SecureString -String $password -asplaintext -Force
$user_credentials = New-Object System.Management.Automation.PSCredential $username,$password

$samusername = Get-Content "powershell_functions/san.txt"
Remove-Item "powershell_functions/san.txt"

if (Test-Path "keep.txt") {
    $keep = Get-Content "keep.txt"
}

$temp_proxy = (Get-ADUser $samusername -Properties proxyaddresses).proxyaddresses
Set-ADUser $samusername -Clear ProxyAddresses -Credential $user_credentials
Set-ADUser $samusername -Replace @{ProxyAddresses="SMTP:" + $imiel + "." + $nazwiskol + "@gala-group.com"} -Credential $user_credentials
Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $imiel + "." + $nazwiskol + "@koronacandles.com"} -Credential $user_credentials
Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $imiel + "." + $nazwiskol + "@korona.wielun.pl"} -Credential $user_credentials
Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $pierwszyinicial + "." + $nazwiskol + "@gala-group.com"} -Credential $user_credentials
Set-ADUser $samusername -EmailAddress ($imiel + "." + $nazwiskol + "@gala-group.com") -Credential $user_credentials

if ($keep -eq "yes") {
    foreach($address in $temp_proxy){
        $temp = $address.tolower()
        Set-ADUser $samusername -Add @{ProxyAddresses=$temp} -Credential $user_credentials
    }
}