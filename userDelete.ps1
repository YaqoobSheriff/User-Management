<#

.Synopsis
This PowerShell script can be used to delete a user from the Active Directory.

.Description
This PowerShell Script matches the user provide in the parameter and deletes it.

.Input
Parameters like username has to be provided.
Example: userDelete.ps1 -userName "user1"

.Output
Deletes the user from the Active Directory.

.Notes
Name: userDelete.ps1
Author: Yaqoob Sheriff R

#>

param([string]$userName)

$user=Remove-ADUser -Identity $username -Confirm:$false
$user