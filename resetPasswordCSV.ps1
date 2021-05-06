<#

.Synopsis
This PowerShell script can be used to reset passwordsfor all the users given in the CSV file.

.Description
This PowerShell Script gets the Usernames and Passwords from the CSV file. And then resets all the passwords for the users given the CSV file.

.Input
Path to the CSV file has to be provided to the script. The CSV file should contain "Username" and "Password" as the column heads
Example: resetPasswordCSV.ps1 -path C:\userDetails.csv

.Output
Pasword would be reset for all the users in the CSV file provided.

.Notes
Name: resetPasswordCSV.ps1
Author: Yaqoob Sheriff R

#>

param($path)
$excel = Import-csv -Path $path
$a = $excel."Username"
$b = $excel."Password"
$j = 1
for($i=0;$i -le $a.length-1;$i++)
{
    $u = get-aduser $a[$i]
    if($u)
    {
        Set-ADAccountPassword -Identity $a[$i] -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $b[$i] -Force)
        Write-Host "Password changed successfully for user" $a[$i] "to" $b[$i]
        $j++
    }
    else 
    {
        Write-host "User doesn't exist."
    }
}

write-host "total users = $j"