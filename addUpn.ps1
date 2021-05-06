<#
.Synopsis
This PowerShell script adds UPN suffixe in the trusted host of the Active Directory so that it can be used later to assign the user principle name.

.Description
This PowerShell Script fetches the UPN's in the trusted host of the Active Directory. 
If the UPN specified doesn't exist it adds the UPN to the trusted hosts.
Later user can be created with this UPN(domain). 
Example: If I add "abc.com" as a UPN Suffix in the trusted host. Then i can have user created as "user1@abc.com"

.Input
Parameter "upn passed to the script.
Example: addUPN.ps1 -upn abc.com

.Output
Adds the UPN to the trusted the trusted hosts.

.Notes
Name: addUPN.ps1
Author: Yaqoob Sheriff R
#>

param([String]$upn) 

$upns=Get-ADForest|select UPNSuffixes
$upnsuffixes=$upns.UPNSuffixes

   if($upnsuffixes -notcontains $upn)
    { 
	    write-host "The UPN doesn't exist hence adding UPN:$upn"
        Get-ADForest |Set-ADForest -UPNSuffixes @{Add=$upn}
	    write-host "Added $upn"
    }
    else
    {
        Write-host "The UPN $upn already exists."
    }