    param($string)

    Import-Module ActiveDirectory


$ATSData=Get-Content -Path "\\servername\IT\Backup\Avaya\ADUsersATSNumbers.csv"


function readATS {
param (
    [String]$DisplayName
)
$r=@('','')
$r[0]= ($ATSData -match $DisplayName).split(";").trim('"')[1]
$r[1]= ($ATSData -match $DisplayName).split(";").trim('"')[2]
return $r
}

    $scope1='OU=RavenTower,DC=seanchan,DC=com'
#    $scope2=
#    $scope3=
#    $scope4=
#    $scope5=
    if ($string -eq '*') {$filter='*'} else {$filter="name -like '*$String*' -or displayname -like '*$String*' -or telephonenumber -like '*$String*' -or mobile -like '*$String*' -or title -like '*$String*' -or department -like '*$String*' -or samaccountname -like '*$String*' -or mail -like '*$String*'"}
    $obj=Get-ADUser -SearchBase $scope1 -Filter $filter -Properties CanonicalName, DisplayName, enabled, SamAccountName, mail, company, Department, title,  OfficePhone, LastLogonDate, Description,  City, Office,  MobilePhone, physicaldeliveryofficename, whencreated, employeeID, employeeNumber, mdbstoragequota, mdboverquotalimit, mdboverhardquotalimit, lockedout, AccountExpirationDate, PasswordLastSet, msDS-UserPasswordExpiryTimeComputed, passwordneverexpires
#    $obj+=Get-ADUser -SearchBase $scope2 -Filter $filter -Properties CanonicalName, DisplayName, enabled, SamAccountName, mail, company, Department, title,  OfficePhone, LastLogonDate, Description,  City, Office,  MobilePhone, physicaldeliveryofficename, whencreated, employeeID, employeeNumber, mdbstoragequota, mdboverquotalimit, mdboverhardquotalimit, lockedout, AccountExpirationDate, PasswordLastSet, msDS-UserPasswordExpiryTimeComputed, passwordneverexpires
#    $obj+=Get-ADUser -SearchBase $scope3 -Filter $filter -Properties CanonicalName, DisplayName, enabled, SamAccountName, mail, company, Department, title,  OfficePhone, LastLogonDate, Description,  City, Office,  MobilePhone, physicaldeliveryofficename, whencreated, employeeID, employeeNumber, mdbstoragequota, mdboverquotalimit, mdboverhardquotalimit, lockedout, AccountExpirationDate, PasswordLastSet, msDS-UserPasswordExpiryTimeComputed, passwordneverexpires
#    $obj+=Get-ADUser -SearchBase $scope4 -Filter $filter -Properties CanonicalName, DisplayName, enabled, SamAccountName, mail, company, Department, title,  OfficePhone, LastLogonDate, Description,  City, Office,  MobilePhone, physicaldeliveryofficename, whencreated, employeeID, employeeNumber, mdbstoragequota, mdboverquotalimit, mdboverhardquotalimit, lockedout, AccountExpirationDate, PasswordLastSet, msDS-UserPasswordExpiryTimeComputed, passwordneverexpires
#    $obj+=Get-ADUser -SearchBase $scope5 -Filter $filter -Properties CanonicalName, DisplayName, enabled, SamAccountName, mail, company, Department, title,  OfficePhone, LastLogonDate, Description,  City, Office,  MobilePhone, physicaldeliveryofficename, whencreated, employeeID, employeeNumber, mdbstoragequota, mdboverquotalimit, mdboverhardquotalimit, lockedout, AccountExpirationDate, PasswordLastSet, msDS-UserPasswordExpiryTimeComputed, passwordneverexpires
    $obj | sort FIO | select `
@{n='FIO';e={$_.DisplayName}},
@{n='Account';e={$_.SamAccountName -ne $null}},
@{n='Title';e={$_.title}},
@{n='Department';e={$_.department}},
@{n='Organization';e={$_.company}},
@{n='PhoneNumber';e={$_.OfficePhone}},
@{n='Mobilephone';e={$_.Mobilephone}},
@{n='Mail';e={$_.mail}},
@{n='Room';e={$_.physicaldeliveryofficename}},
@{n='City';e={$_.city}},
@{n='ID';e={$_.employeeID}},
@{n='CSUPDCreated';e={if ($_.employeenumber -eq $null -and $_.employeeID -ne $null) {'Да'} else {'Нет'}}},
@{n='Enabled';e={if ($_.enabled -eq $true) {'Да'} else {'Нет'}}},
@{n='Path';e={$_.canonicalname}},
@{n='Created';e={$_.whencreated}},
@{n="WarnQuota";e={if ($_.mdbstoragequota -ne $null) {[math]::Round($_.mdbstoragequota/1024)} else {""}}},
@{n="SendQuota";e={if ($_.mdboverquotalimit -ne $null) {[math]::Round($_.mdboverquotalimit/1024)} else {""}}},
@{n="ReceiveQuota";e={if ($_.mdboverhardquotalimit -ne $null) {[math]::Round($_.mdboverhardquotalimit/1024)} else {""}}},
#@{n='LastlogonHostname';e={(readlastpclogon $_.SamAccountName)[0]}},
#@{n='LastlogonDate';e={(readlastpclogon $_.SamAccountName)[1]}},
@{n='LastlogonHostname';e={if ($_.Info -ne $null) {if ($_.Info.indexof("logon") -ne -1) {$_.Info.substring($_.Info.indexof("logon - ")+8)}} else {""}}},
@{n='LastlogonDate';e={if ($_.Info -ne $null) {if ($_.Info.indexof("logon") -ne -1) {$_.Info.substring(0,$_.Info.indexof("logon")-1)}} else {""}}},
@{n='AccountExpires';e={if ($_.AccountExpirationDate -ne $null) {$_.AccountExpirationDate.tostring()} else {'Бессрочная'}}},
@{n='PasswordChanged';e={if ($_.PasswordLastSet -ne $null) {$_.PasswordLastSet.tostring()} else {'Никогда'}}},
@{n='PasswordExpires';e={if ($_.passwordneverexpires -eq $true -or $_.PasswordLastSet -eq $null) {'Никогда'} else {([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")).tostring()}}},
@{n='AccountLocked';e={if ($_.lockedout -eq $true) {'Да'} else {'Нет'}}},
@{n='ATSIP';e={(readATS $_.DisplayName)[0]}},
@{n='ATSNumber';e={(readATS $_.DisplayName)[1]}}