systeminfo

Search the domain name from the systeminfo

```
systeminfo | findstr /B "Domain"
```

Execute a cmd remotely from another server

```
winrs -r:EC2AMAZ-55U300L.nessdemo.local cmd
```

To install RSAT

Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State

Install a specific RSAT feature by name

Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"

Active Directory Domain Services and Lightweight Directory Services Tools --- Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0


Install the following Jenkins Plugin
AWS Steps 
AWS Credentials

