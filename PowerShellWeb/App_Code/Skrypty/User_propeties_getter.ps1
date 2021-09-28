$imie = "$input1"
$nazwisko = "$input2"
$number = Get-Content -Path "number.txt"
$haslo = "$input3"
$pass = ConvertTo-SecureString -String $haslo -asplaintext -Force
$imiel = $imie.ToLower().Normalize("FormD") -replace '\p{M}', ''
$nazwiskol = $nazwisko.ToLower().Normalize("FormD") -replace '\p{M}', ''
$samusername = $imiel + "." + $nazwiskol
$shortsamusername = $imiel.Substring(0,1) + "." + $nazwiskol

$username = "$user_input"
$password = "$pass_input"
$password = ConvertTo-SecureString -String $password -asplaintext -Force
$user_credentials = New-Object System.Management.Automation.PSCredential $username,$password

if ($number -eq 1) {
	$data = Get-ADUser $samusername -Properties proxyAddresses,title,departmentNumber,department,proxyaddresses -Credential $user_credentials
}
if ($number -eq 2) {
	$data = Get-ADUser $shortsamusername -Properties proxyAddresses,title,departmentNumber,department,proxyaddresses -Credential $user_credentials
}

$proxyaddresses_array = $data.proxyaddresses
$proxyaddresses_string = ''
foreach ($line in $proxyaddresses_array) {
	$proxyaddresses_string += $line,'`n'
}

try {
	$data.userprincipalname -match "@.{1,}$" > $null
	$upn = $Matches[0]
}
catch {
	New-Item -Name "only friend no wife"
}

try {
	$yes = $data.departmentnumber -match "[0-9]{3}-[0-9]{2}"
	$dp_nb = $yes[0]
}
catch {
	try {
		$yes = $data.departmentnumber
	}
	catch {
		New-Item -Name "ばか"
	}
}

New-Item -Name "title.txt" -Value $data.title -Force
New-Item -Name "dp.txt" -Value $data.department -Force
New-Item -Name "dp_number.txt" -Value $dp_nb -Force
New-Item -Name "upn.txt" -Value $upn -Force
New-Item -Name "proxyaddresses.txt" -Value $proxyaddresses_string -Force
