<#

.Synopsis
This PowerShell script can be used to logoff specif users that can be provided in the array.

.Description
This PowerShell Script uses invoke_RDUserLogoff to logoff all the users provided in the array of users.

.Input
Parameters like userArray has to be provided to run the script.
Example: bulkUserLogoff.ps1 -userArray ["user1","user2","user3"]

.Output
Outputs the users with their creation time in JSON format. This file can be found in the C:\userData.json

.Notes
Name: userCreationData.ps1
Author: Yaqoob Sheriff R

#>

param([String[]]$userArray)

forEach($user in $userArray)
{

    $s = Get-RDUserSession -ConnectionBroker "PFBITS-CB01.wilp.bits-pilani.ac.in" | ?{$_.UserName -match $user}
    $sid = $s.UnifiedSessionId 
    $hostServer = $s.HostServer

    Invoke-RDUserLogoff -HostServer $hostServer -UnifiedSessionID $sid -Force
    }