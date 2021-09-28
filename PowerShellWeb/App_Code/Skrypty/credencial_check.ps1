$username = $user_input
$password = $pass_input
$password = ConvertTo-SecureString -String $password -asplaintext -Force
$user_credentials = New-Object System.Management.Automation.PSCredential $username,$password

function Credencial_check {
	$exist = $false
    try {
        try {
            $exist = [bool] (Get-ADUser temp.temp)
        }
        catch {
            $temp_bool = [bool] (New-ADUser temp.temp -Credential $user_credentials) #returns False if created
            if (!$temp_bool) {
                Remove-ADUser temp.temp -Credential $user_credentials -Confirm:$false
                New-Item -Name "Credencial_result.txt" -Value "1" # Credencials are correct
                return $false
            }
        }
        if ($exist) {
            Write-Host "Konto instnieje 'temp.temp' istnieje, nie można sprawdzić danych logowania"
            exit
        }
    }
    catch {
        New-Item -Name "Credencial_result.txt" -Value "0" # Credencial aren't correct
        return $true
    }
}

Credencial_check