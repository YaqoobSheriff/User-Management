<#

.Synopsis
This PowerShell script can be used to collect the login and logoff time of the users bassed on the events.

.Description
This PowerShell Script uses the event logs to collect the user login time and logoff time.


.Input
No imputs required. Run the script in the session host server or the appserver.

.Output
Creates a CSV file with the user login and logoff time.

.Notes
Name: loginData.ps1
Author: Yaqoob Sheriff R

#>

$arr=@();
$arr1=@();
$arr2=@();

$UserProperty = @{n="User";e={(New-Object System.Security.Principal.SecurityIdentifier $_.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])}}
$TypeProperty = @{n="Action";e={if($_.EventID -eq 7001) {"Logon"} else {"Logoff"}}}
$TimeProperty = @{n="Time";e={$_.TimeGenerated}}
$MachineNameProperty = @{n="MachinenName";e={$_.MachineName}}

$computer = $env:COMPUTERNAME
Write-host "Gathering event data..."
$obj=Get-EventLog System -Source Microsoft-Windows-Winlogon -ComputerName $computer | select $UserProperty,$TypeProperty,$TimeProperty,$MachineNameProperty


$arr += $obj
foreach($i in $arr)
{
    if($i.MachinenName.Contains($computer)) 
    {
        $arr1 += $i;
    }
}
  

$arr1 | Export-Csv "C:\$computer.csv"
Write-Host "Done"

$csv  = import-csv "C:\$computer.csv"
$csv| ForEach-Object
{
    $temp=$_.User.split("\")
    $_.User=$temp[1]
}

$array= @()
$logon = $csv | Where-Object {$_ -like "*Logon*"}
$logoff = $csv | Where-Object {$_ -like "*Logoff*"}

$usernames = $csv.User
forEach($user in $usernames)
{

    $data = $csv|Where-Object {$_.User -like $user}
    $on = $data|where-object {$_.Action -like "Logon"}
    $logontime = $on.Time
    $off = $data|where-object {$_.Action -like "Logoff"}
    $logofftime = $off.Time

    if($logontime.count -eq 1)
    {
        $diff=New-TimeSpan -Start $logontime -End $logofftime
        $object = New-Object -TypeName PSObject
        $object| Add-Member -Name 'Username' -MemberType Noteproperty -Value  $user
        $object| Add-Member -Name 'Logon Time' -MemberType Noteproperty -Value  $logontime
        $object| Add-Member -Name 'Logoff Time' -MemberType Noteproperty -Value  $logofftime
        $object| Add-Member -Name 'Usage' -MemberType Noteproperty -Value  $diff.ToString()
        $array += $object
    }
    else
    {
        for($i=0;$i -lt $logontime.count; $i++)
        {
            $diff=New-TimeSpan -Start $logontime[$i] -End $logofftime[$i]
            $object = New-Object -TypeName PSObject
            $object| Add-Member -Name 'Username' -MemberType Noteproperty -Value  $user
            $object| Add-Member -Name 'Logon Time' -MemberType Noteproperty -Value  $logontime[$i]
            $object| Add-Member -Name 'Logoff Time' -MemberType Noteproperty -Value  $logofftime[$i]
            $object| Add-Member -Name 'Usage' -MemberType Noteproperty -Value  $diff.ToString()
            $array += $object

        }
    }

}

$c = $array|sort username -Unique

write-host "Total users = " $c.Count
$array | Export-Csv C:\"$computer"logindata.csv