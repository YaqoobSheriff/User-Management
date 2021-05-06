<#

.Synopsis
This PowerShell script can be used to get the user list which were created between the dates provided to the script.

.Description
This PowerShell Script gets the User properties of the users that were created between the given date range.

.Input
Parameters like fromDate and toDate has to be provided to run the script.
Example: userCreatoinData.ps1 -fromDate "01/01/2021" -toDate "30/01/2020"

.Output
Outputs the users with their creation time in JSON format. This file can be found in the C:\userData.json

.Notes
Name: userCreationData.ps1
Author: Yaqoob Sheriff R

#>

param($fromDate,$toDate)
#date format "02/23/2020"

[datetime]$fromDate = $fromDate
[datetime]$toDate = $toDate

$usersarray=@()
$userobjectarray=@()
$usersfinal=@()
$i=1
#$ADuserInmonth = Get-ADUser -Filter * -Properties whencreated | select name,whenCreated 
$list= Get-ADUser -Filter {(whenCreated -ge $fromDate) -and (whenCreated -le $toDate)} -Properties whenCreated

foreach($a in $list)
{
    $aa=$a.name
    $bb=$a.whenCreated.ToString()
    $cc= $a.UserPrincipalName
   
    $object = New-Object -TypeName PSObject
    $object | Add-Member -Name 'userName' -MemberType Noteproperty -Value $aa
    $object | Add-Member -Name 'userEmail' -MemberType Noteproperty -Value $cc
    $object | Add-Member -Name 'creationTime' -MemberType Noteproperty -Value $bb.ToString()
    
    $userobjectarray += $object
    $i++
}

$z = New-Object -TypeName PSObject
$z | Add-Member -Name "users" -MemberType NoteProperty -Value $userobjectarray -Force
         
$usersfinal=ConvertTo-Json $z
$usersfinal | Out-File -FilePath 'C:\userData.json'  
$usersfinal

           