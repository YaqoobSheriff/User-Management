<#

.Synopsis
This PowerShell script can be used to logoff all the users from a computer except the Administrator.

.Description
This PowerShell Script gets the active and disconnected users and logs off all the users except the Administrator.


.Input
No imputs required. Run the script in the session host server or the appserver.

.Output
All users will be logged off from the computer except the Administrator.

.Notes
Name: logoffAllUsers.ps1
Author: Yaqoob Sheriff R

#>

$usersarray=@()
$userobjectarray=@()
$usersfinal=@()
    $computername=$env:COMPUTERNAME

    $users = qwinsta /server:$computername  2>&1
    if ($users -match "No user exists"){ 
         continue 
        }
    forEach($line in $users ){
        if($line -like "*Active*" -or $line -like "*Disc*"){
            $user=$line -replace '\s{2,}', ',' 
            $usersarray= $user.split(',')
            $object = New-Object -TypeName PSObject
            $object | Add-Member -Name 'userName' -MemberType Noteproperty -Value $usersarray[1]
            $object | Add-Member -Name 'sessionId' -MemberType Noteproperty -Value $usersarray[2]
            $object | Add-Member -Name 'computerName' -MemberType Noteproperty -Value $computername
            $userobjectarray += $object
  	    if($line -notlike "*Administrator*") {
            logoff /server:$computername $usersarray[2] /v
	    }
        }
    }