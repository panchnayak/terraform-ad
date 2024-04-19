Add-WindowsFeature RSAT-AD-PowerShell
Remove-WindowsFeature RSAT-AD-PowerShell


Import-Module ActiveDirectory
New-ADOrganizationalUnit -Name "Sales" -Path "DC=crit,DC=nessdemo,DC=local"


New-ADOrganizationalUnit -Name "Sales" -Path "OU=Departments,DC=crit,DC=nessdemo,DC=local"
Get-ADOrganizationalUnit -Filter * -SearchBase "DC=crit,DC=nessdemo,DC=local"

New-ADOrganizationalUnit -Name "UserAccounts" -Path "OU=Sales,DC=crit,DC=nessdemo,DC=local"
Get-ADOrganizationalUnit -Filter * -SearchBase "DC=crit,DC=nessdemo,DC=local"

New-GPO -Name TestGPO -Comment "This is a test GPO."
New-GPO -Name "FromStarterGPO" -StarterGPOName "Windows Vista EC Computer Starter GPO"

New-GPO -Name TestGPO | New-GPLink -Target "OU=UserAccounts,DC=crit,DC=nessdemo,DC=local" | 
    Set-GPPermissions -PermissionLevel gpoedit -TargetName "Marketing Admins" -TargetType Group

## Create a AD group
Import-Module ActiveDirectory
New-ADGroup -Name "SalesGroup" -GroupScope Global -GroupCategory Security -Path "OU=Sales,DC=crit,DC=nessdemo,DC=local"
Get-ADGroup -Filter * -SearchBase "OU=Sales,DC=crit,DC=nessdemo,DC=local"

### add an user to the sales group
Import-Module ActiveDirectory
New-ADUser -Name "Panchaleswar Nayak" -SamAccountName "panchaleswarnayak" -UserPrincipalName "Panchaleswar.Nayak@ness.com" -GivenName "Panchaleswar" -Surname "Nayak" -Path "OU=Sales,DC=crit,DC=nessdemo,DC=local" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "SalesGroup" -Members "panchaleswarnayak"
Get-ADGroupMember -Identity "SalesGroup"

### Add existing user to a Group

$user = Get-ADUser -Identity "PanchaleswarNayak"
Add-ADGroupMember -Identity "SalesGroup" -Members $user


### How to excute Powershell commmands on a remote server 
### Ensure Remoting is Enabled:
Enable-PSRemoting -Force
###Enable WinRM
Enable-WSManCredSSP -Role Server
### Configure Trusted Hosts on your local computer
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "3.21.126.135" -Concatenate
### Excute PowerShell Commands remotely
$credential = Get-Credential
Invoke-Command -ComputerName "3.21.126.135" -Credential $credential -ScriptBlock { Import-Module ActiveDirectory Get-ADGroupMember -Identity "SalesGroup" }

Invoke-Command -ComputerName "3.21.126.135" -Credential $credential -ScriptBlock { systeminfo }


