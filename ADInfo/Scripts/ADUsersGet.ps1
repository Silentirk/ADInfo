    param($string)
    Import-Module ActiveDirectory

    
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
@{n='FIO';e={if ($_.DisplayName -ne $null) {$_.DisplayName.tostring()} else {""}}},
@{n='Account';e={if ($_.SamAccountName -ne $null) {$_.SamAccountName.tostring()} else{""}}},
@{n='Title';e={if ($_.title -ne $null) {$_.title.tostring()} else {""}}},
@{n='Department';e={if ($_.department -ne $null) {$_.department.tostring()} else {""}}},
@{n='Organization';e={if ($_.company -ne $null) {$_.company.tostring()} else {""}}},
@{n='PhoneNumber';e={if ($_.OfficePhone -ne $null) {$_.OfficePhone.tostring()} else {""}}},
@{n='Mobilephone';e={if ($_.Mobilephone -ne $null) {$_.Mobilephone.tostring()} else {""}}},
@{n='Mail';e={if ($_.mail -ne $null) {$_.mail.tostring()} else {""}}},
@{n='Room';e={if ($_.physicaldeliveryofficename -ne $null) {$_.physicaldeliveryofficename.tostring()} else {""}}},
@{n='City';e={if ($_.city -ne $null) {$_.city.tostring()} else {""}}},
@{n='ID';e={if ($_.employeeID -ne $null) {$_.employeeID.tostring()} else {""}}},
@{n='CSUPDCreated';e={if ($_.employeenumber -eq $null -and $_.employeeID -ne $null) {'Да'} else {'Нет'}}},
@{n='Enabled';e={if ($_.enabled -eq $true) {'Да'} else {'Нет'}}},
@{n='Path';e={$_.canonicalname.tostring()}},
@{n='Created';e={$_.whencreated.tostring()}},
@{n="WarnQuota";e={if ($_.mdbstoragequota -ne $null) {[math]::Round($_.mdbstoragequota/1024)} else {""}}},
@{n="SendQuota";e={if ($_.mdboverquotalimit -ne $null) {[math]::Round($_.mdboverquotalimit/1024)} else {""}}},
@{n="ReceiveQuota";e={if ($_.mdboverhardquotalimit -ne $null) {[math]::Round($_.mdboverhardquotalimit/1024)} else {""}}}

