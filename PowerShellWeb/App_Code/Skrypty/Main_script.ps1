Import-Module ActiveDirectory
$user_credentials = Get-Credential

function Credential-check {
    $exist = $false
    try {
        try {
            $exist = [bool] (Get-ADUser temp.temp)
        }
        catch {
            $temp_bool = [bool] (New-ADUser temp.temp -Credential $user_credentials) #returns False if created
            if (!$temp_bool) {
                Remove-ADUser temp.temp -Credential $user_credentials -Confirm:$false
                return $false
            }
        }
        if ($exist) {
            Write-Host "Konto instnieje 'temp.temp' istnieje, nie można sprawdzić danych logowania"
            exit
        }
    }
    catch {
        return $true
    }
}

function Manager-search ($manager_surname) {
    $global:managerarray = Get-ADUser -SearchBase $oued_mng -Filter "(sn -eq '$manager_surname')" -Properties department,DistinguishedName | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,department,DistinguishedName
    $i = 1
    $global:manager_numbers = ''
    foreach ($line in $managerarray) {
        $global:manager_numbers += $i,', '
        $temp_manger_name = $managerarray[$i-1].name
        $temp_namager_department = $managerarray[$i-1].department
        Write-Host $i '.' $temp_manger_name '-' $temp_namager_department
        $i++
    }
}

function Giver-search ($giver_name) {
    $Global:giver_array = Get-ADUser -SearchBase $oued -Filter "(sn -eq '$giver_name')" -Properties Department | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,Department,SamAccountName
    $i = 1
    $global:giver_numbers = ''
    foreach ($line in $giver_array) {
        $global:giver_numbers += $i,', '
        $temp_giver_name = $giver_array[$i-1].name
        $temp_giver_department = $giver_array[$i-1].department
        Write-Host $i '.' $temp_giver_name '-' $temp_giver_department
        $i++
    }
}

function Reciver-search ($reciver_name) {
    $global:reciver_array = Get-ADUser -SearchBase $oued -Filter "(sn -eq '$reciver_name')" -Properties Department | Where-Object {$_.DistinguishedName -notlike "*OU=Disabled*"} | select Name,Department,SamAccountName
    $i = 1
    $Global:reciver_numbers = ''
    foreach ($line in $reciver_array) {
        $Global:reciver_numbers += $i,', '
        $temp_reciver_name = $giver_array[$i-1].name
        $temp_reciver_department = $reciver_array[$i-1].department
        Write-Host $i '.' $temp_reciver_name '-' $temp_reciver_department
        $i++
    }
}

function Upn-changer ($deafult_upn) {
    $upn_list = @('@korona.wielun.pl', '@koronacndles.com')
    $choice = Read-Host -Prompt "Dla tego OU ", $deafult_upn, " jest domyślnyą domeną, czy jest ona poprawna? (y/n)"
    $i = 1
    if ($choice -eq 'n') {
        foreach ($upn in $upn_list) {
            Write-Host $i '.' $upn
            $i++
        }
        $upn_choice = Read-Host -Prompt "Wpisz liczbe obok wybranej domany"
        while (($upn_choice -lt 1) -or ($upn_choice -gt $i)) {
            $upn_choice = Read-Host -Prompt "Podana liczba jest z poza zakresu, wprowadź poprawną liczbę"
        }
        Set-Variable -Name 'upn_choosen' -Value $upn_list[$upn_choice-1] -Scope Global
    }
    else {
        Set-Variable -Name 'upn_choosen' -Value $upn_list[$upn_choice-1] -Scope Global
    }
}

while (Credential-check) {
    Write-Host "Podano złe dane logowania lub są one nie wystarczające, wpisz je ponownie"
    $user_credentials = Get-Credential
}

$managerpath = "OU=Management,OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
$fastgroupassing = 0
$edit_mode = 0
$no_ou_change = 0
$no_mg_change = 0
Write-Host "`n1. Utworzyć nowy profil użytkownika"
Write-Host "2. Skopiować grupy jednego użytkownika do drugiego"
$akcja = Read-Host -Prompt "Co chcesz zrobić?"
if ($akcja -eq 1) { # Tworzenie nowego konta AD
    $imie = Read-Host -Prompt "`nWpisz Imię"
    $pierwszyinicial = $imie.Substring(0, 1).ToLower()
    $nazwisko = Read-Host -Prompt "Wpisz Nazwisko"
    $imiel = $imie.ToLower().Normalize("FormD") -replace '\p{M}', ''
    $nazwiskol = $nazwisko.ToLower().Normalize("FormD") -replace '\p{M}', ''
    $samusername = $imiel + "." + $nazwiskol
    $shortsamusername = $imiel.Substring(0,1) + "." + $nazwiskol
    $oued = "OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
    $oued_mng = "OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl"
    $correct = 0
    $short = 0
    while ($correct -eq 0) {
        if ([bool] (Get-ADUser -Filter { SamAccountName -eq $samusername })) {
            Get-ADUser $samusername -Properties proxyAddresses
            Write-Host "`nUżytkownik o podanym imieniu i nazwisku już istnieje."
            Write-Host "Co chesz zrobić`n1.Zaktualizować istniejący profil`n2.Utworzyć inny"
            $akcja = Read-Host -Prompt "Wpisz numer akcji"
            if ($akcja -eq 1) {
                $quickedit = 1
                $short = 1
                break
            }
            elseif ($akcja -eq 2 ) {
                $short = 1
                $imie = Read-Host -Prompt "Podaj Imię"
                $nazwisko = Read-Host -Prompt "Podaj Nazwisko"
                $imiel = $imie.ToLower().Normalize("FormD") -replace '\p{M}', ''
                $nazwiskol = $nazwisko.ToLower().Normalize("FormD") -replace '\p{M}', ''
                $samusername = $imiel + "." + $nazwiskol
            }
        }
        elseif (([bool] (Get-ADUser -Filter { SamAccountName -eq $shortsamusername })) -and ((Get-ADUser $shortsamusername).givenname -eq $imie )) -and ($short -eq 0)) {
            Write-Host "Znaleziono użytkownika o podanym iminiu i nazwisku.`n"
            Get-ADUser $shortsamusername -Properties proxyAddresses -Credential $user_credentials
            Write-Host "Co chcesz zrobić?`n1.Zaktualizować istniejący profil`n2.Utworzyć inny"
            $akcja = Read-Host -Prompt "Wpisz numer akcji`n"
            if ($akcja -eq 1) {
                Set-ADUser -Identity $shortsamusername -Replace @{samaccountname=$samusername} -Credential $user_credentials
                $quickedit = 1
                $short = 1
                break
            }
            elseif ($akcja -eq 2 ) {
                $short = 1
            }
        }
        else {
            $password = Read-Host -Prompt "Podaj hasło (min. 8 znaków, 1 duża litera, 1 mała litera, 1 liczba oraz 1 znak specjalny.)"
            $correct = 0
            while ($correct -eq 0) {
                if ($password -match "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$") {
                    $correct = 1
                    break
                }
            $password = Read-Host -Prompt "Podano złe hasło, spróbuj podobnie"
            }
            $correct = 1
            New-ADUser -name($imie + " " + $nazwisko) -GivenName $imie -Surname $nazwisko -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -Credential $user_credentials
            break
        }
    }
    if ($quickedit -eq 1) {
        $quickedit = Read-Host -Prompt "`nJak chcesz zaktualizować profil`n1.Zaktualizować wszystkie dane`n2.Zaktualizować adresy e-mail`n3.Nic nie zaktualizować`nWybierz numer"
        if ($quickedit -eq 1) {
            $quickedit = 0
            $edit_mode = 1    
        }
        elseif ($quickedit -eq 2 -or 1) {
            $temp_proxy = (Get-ADUser $samusername -Properties proxyaddresses).proxyaddresses
            Set-ADUser $samusername -Replace @{ProxyAddresses="SMTP:" + $imiel + "." + $nazwiskol + "@gala-group.com"} -Credential $user_credentials
            Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $imiel + "." + $nazwiskol + "@koronacandles.com"} -Credential $user_credentials
            Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $imiel + "." + $nazwiskol + "@korona.wielun.pl"} -Credential $user_credentials
            Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $pierwszyinicial + "." + $nazwiskol + "@gala-group.com"} -Credential $user_credentials
            Set-ADUser $samusername -EmailAddress ($imiel + "." + $nazwiskol + "@gala-group.com") -Credential $user_credentials
            foreach($address in $temp_proxy){
                $temp = $address.tolower()
                Set-ADUser $samusername -Add @{ProxyAddresses=$temp} -Credential $user_credentials
            }
            if ($quickedit -eq 2) {exit}
        }
        elseif ($quickedit -eq 3) {exit}

    }
    if ($edit_mode -eq 1) {
        $temp = (Get-ADUser $samusername -Properties title | select title).title
        Write-Host "`nTwój poprzedni tytuł to $temp. Jeżeli chcesz go zachować zostaw to pole puste"
    }
    $title = Read-Host -Prompt "Podaj tytuł stanowiska"
    if ($edit_mode -eq 1) {
        $temp = (Get-ADUser $samusername -Properties department | select department).department
        Write-Host "`nTwoja poprzednia nazwa działu to $temp. Jeżeli chcesz ją zachować zostaw to pole puste"
    }
    $dp = Read-Host -Prompt "Podaj nazwę działu"
    while (($dp -eq "") -and ($edit_mode -eq 0)) {
        $dp = Read-Host -Prompt "Pole to jest wymagane, podaj nazwe działu"
    }
    if ($edit_mode -eq 1) {
        $temp = (Get-ADUser $samusername -Properties departmentNumber).departmentNumber
        Write-Host "`nTwój poprzedni 'numer MPK' to $temp. Jeżeli chcesz go zachować zostaw to pole puste"
    }
    $dpnumber = Read-Host -Prompt "Podaj 'numer MPK' (format xxx-xx)"
    while ($dpnumber -notmatch '^[0-9]{3}-[0-9]{2}$') {
        $dpnumber = Read-Host "Błąd formatu, podaj poprawny numer MPK"
    }
    Write-Host "`nPodaj grupe OU w której chcesz umieścić użytkownika"
    $t = 2
    if ($t -eq 2) { # Dodawanie do wybranego OU
        $patharray = @(),@()
        $patharray = Get-ADObject -SearchBase $oued -Filter { ObjectClass -eq 'organizationalunit' } | Where-Object {($_.DistinguishedName | Select-String -NotMatch "OU=Disabled","OU=Distribution Groups","^OU=O365","OU=Skrzynki Udostępnione")} | Select-Object -Property Name,DistinguishedName
        Write-Host ""
        $i = 1
        $temp = 0
        $ou_numbers = ''
        foreach ($line in $patharray) {
            $ou_numbers += $i,', '
            $temp = $patharray[$i-1].Name
            Write-Host $i $temp
            $i++
        }
        if ($edit_mode -eq 1) {
            $temp = (Get-ADUser $samusername | select DistinguishedName).DistinguishedName
            $temp -match '(?<=U=)(.*)(?=,OU=O)' > $null
            $temp = $Matches[1]
            $temp -match '(?<=)(.*)(?=,)' > $null
            $path_name = $Matches[1]
            Write-Host "`nTwoja poprzednia ścieżka to $path_name. Jeżeli nie chcesz jej zmieniać zostaw to pole puste"
        }
        $ch = Read-Host -Prompt "Wybierz liczbę obok wybranej ścieżki"
        while (($ou_numbers -notmatch $ch) -and ($ch -ne "")) {
            $ch = Read-Host "Podana liczba jest nieprawidłowa, wpisz nową"
        }
        if ($ch -eq "") {
            $no_ou_change = 1
        }
        else {
            $oufinal = $patharray[$ch-1].DistinguishedName
        }
    }
    $managernumber = 0
    $man_choice = 0
    while ($managernumber -eq 0) { # Wybieranie menedżera
        if ($edit_mode -eq 1) {
            $temp = Get-ADUser $samusername -Properties manager | select manager
            $temp = (Get-ADUser -Filter * -SearchBase $temp.manager).name
            Write-Host "`nTwój obecny menedżer to $temp"
            $man_choice = Read-Host -Prompt "Jeżeli chcesz go zmienić wpisz 1, w przeciwnym razie zostaw to pole puste"
            if ($man_choice -eq "") {
            $no_mg_change = 0
            $managernumber = -1
            }
        }
        if (($edit_mode -eq 0) -or ($man_choice -eq 1)) {
            $mansur = Read-Host -Prompt "`nPodaj nazwisko menedżera"
            Manager-search($mansur)
            $managernumber = Read-Host -Prompt "`nWpisz liczbę obok wybranego menedżera lub wpisz inne nazwisko"
            while ($managernumber -match '^[A-Z]{1}[a-z]{1,}') {
                Manager-search($managernumber)
                $managernumber = Read-Host -Prompt "`nWpisz liczbę obok wybranego menedżera lub wpisz inne nazwisko"
            }
            while (($manager_numbers -notmatch $managernumber) -and ($managernumber -ne 0)) {
                $managernumber = Read-Host "Podana liczba jest nieprawidłowa, podaj nową"
            }
            $chosenone = $managerarray[$managernumber-1].DistinguishedName
        }
    }
    $displayname = $imie + " " + $nazwisko
    $temp_san = $imiel + "." + $nazwiskol
    if ($edit_mode -eq 0) {Set-ADUser -Identity($imiel + " " + $nazwiskol) -Replace @{samaccountname=$samusername} -Credential $user_credentials}
    if ($no_mg_change -eq 0) {Set-ADUser $samusername -Replace @{manager=$chosenone} -Credential $user_credentials}
    
    if ($oufinal -notlike "OU=Korona Candles Inc.,OU=O365,OU=Users,OU=MyBusiness,DC=korona,DC=wielun,DC=pl") {
        $def_upn = "@korona.wielun.pl"
        Upn-changer($def_upn)
        $def_upn = $upn_choosen
        Set-ADUser $samusername -UserPrincipalName ($imiel + "." + $nazwiskol + $def_upn) -Credential $user_credentials
        Set-ADUser $samusername -Replace @{L=”Wieluń”} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{postalCode="98-300"} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{st="Łódzkie"} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{streetAddress="Fabryczna 10"} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{c="PL"} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{countryCode="616"} -Credential $user_credentials
        Add-ADGroupMember -Identity "KoronaSp.zo.o" -Members $samusername -Credential $user_credentials
    }
    else {
        $def_upn = "@koronacandles.com"
        Upn-changer($def_upn)
        $def_upn = $upn_choosen
        Set-ADUser $samusername -UserPrincipalName ($imiel + "." + $nazwiskol + $def_upn) -Credential $user_credentials
        Set-ADUser $samusername -Replace @{L=”Dublin”} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{postalCode="VA24084"} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{st="Virginia"} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{streetAddress="3994 Pepperell Way"} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{c="US"} -Credential $user_credentials
        Set-ADUser $samusername -Replace @{countryCode="840"} -Credential $user_credentials
        Add-ADGroupMember -Identity "Korona Candles INC" -Members $samusername -Credential $user_credentials
    }
    if ($no_ou_change -eq 0) {Get-ADUser -Identity $samusername | Move-ADObject -TargetPath $oufinal -Credential $user_credentials}

    Set-ADUser $samusername -Replace @{ProxyAddresses="SMTP:" + $imiel + "." + $nazwiskol + "@gala-group.com"} -Credential $user_credentials
    Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $imiel + "." + $nazwiskol + "@koronacandles.com"} -Credential $user_credentials
    Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $imiel + "." + $nazwiskol + "@korona.wielun.pl"} -Credential $user_credentials
    Set-ADUser $samusername -Add @{ProxyAddresses="smtp:" + $pierwszyinicial + "." + $nazwiskol + "@gala-group.com"} -Credential $user_credentials
    Set-ADUser $samusername -EmailAddress ($imiel + "." + $nazwiskol + "@gala-group.com") -Credential $user_credentials
    if ($dpnumber -ne "") {Set-ADUser $samusername -Replace @{departmentNumber=$dpnumber} -Credential $user_credentials}
    if ($title -ne "") {Set-ADUser $samusername -Replace @{title = $title} -Credential $user_credentials}
    if ($dp -ne "") {Set-ADUser $samusername -Replace @{department=$dp} -Credential $user_credentials}
    if ($displayname -ne "") {Set-ADUser $samusername -Replace @{displayName=$displayname} -Credential $user_credentials}
    
    $akcja = Read-Host -Prompt "Czy chcesz również skopiować grupy od innego użytkownika(y/n)"
    if ($akcja -eq 'y') {
        $akcja = 2
        $fastgroupassing = 1
        $final_reciver = $samusername
        $reciver_name = (Get-ADUser $samusername).name
    }
    else {
        $fastgroupassing = 0
    }
}
if ($akcja -eq 2) { # Kopiowanie grup
    $new_surname = 1
    while ($new_surname -eq 1) {
        $giver_surname = Read-Host -Prompt "Podaj nazwisko 'dawcy'"
        Giver-search($giver_surname) # Dane 'dawcy'
        $giver_surname = Read-Host -Prompt "`nWpisz liczbę obok wybranego 'dawcy' lub wpisz inne nazwisko"
        while ($giver_surname -match '^[A-Z]{1}[a-z]{1,}') {
                Giver-search($giver_surname)
                $giver_surname = Read-Host -Prompt "`nWpisz liczbę obok wybranego 'dawcy' lub wpisz inne nazwisko"
        }
        while (($giver_number -match $giver_surname) -and ($giver_surname -ne 0)) {
            $giver_surname = Read-Host "Podana liczba jest nieprawidłowa, podaj nową"
        }
        if ($giver_surname -match $giver_number) {
            $new_surname = 0
        }
    }
    $giver_array[$giver_number-1] -match '(?<=tName=)(.*)(?=})' > $null
    $donorgroups = $giver_array[$giver_number-1].SamAccountName
    $donor_san = $donorgroups

    $new_surname = 1
    while (($new_surname -eq 1) -and ($fastgroupassing -eq 0)) { # Dane odbiorcy
        $reciver_surname = Read-Host -Prompt "Podaj nazwisko 'odbiorcy'"
        Reciver-search($reciver_surname)
        $reciver_surname = Read-Host -Prompt "`nWpisz liczbę obok wybranego 'odbiorcy' lub wpisz inne nazwisko"
        while ($reciver_surname -match '^[A-Z]{1}[a-z]{1,}') {
            Reciver-search($reciver_surname)
            $reciver_surname = Read-Host -Prompt "`nWpisz liczbę obok wybranego 'odbiorcy' lub wpisz inne nazwisko"
        }
    }

    if ($fastgroupassing -ne 1) {
        $reciver_san = $reciver_array[$reciver_number-1].SamAccountName
        $reciver_name = (Get-ADUser $reciver_san).name
    }
    else {
        $reciver_name = (Get-ADUser $samusername).name
        $reciver_san = $final_reciver
    }
    $groups_to_copy = (Get-ADUser $donor_san -Properties memberof).memberof
    foreach ($group in $groups_to_copy) {
        $group | Add-ADGroupMember -Members $reciver_san
        $group_name = (Get-ADGroup $group).name
        Write-Host "Dodano $reciver_name do grupy $group_name"
    }
}