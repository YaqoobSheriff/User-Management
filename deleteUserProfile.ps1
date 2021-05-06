 <#

.Synopsis
  This script fetches all the user folders in the "C:\Users" folder and delete the user folder with corresponding resgistries.
  This can help in saving disk space.

.Description
  This script fetches the usernames and passwords from the excel sheet then creates the users with the usernames and password provided.
  Later assigns the home directory path to the user. The CSV file shpould contain "Username" and "Password" as column heads.

.Input
  Run the script in the app server or the session host server where the sessoins are hosted.

.Output
User profiles are deleted. Giving enough space on the C Drive. 

.Notes
Name: deleteUserProfile.ps1
Author: Yaqoob Sheriff R

#>

$f = (Get-ChildItem -Path "C:\Users\" -Directory -Force -ErrorAction SilentlyContinue | Select-Object Name).Name
$folders = New-Object -TypeName "System.Collections.ArrayList"
$folders = [System.Collections.ArrayList]@($f)

#Add the exclusion to users that you wish not to be delete the user profile 
$folders.Remove("Admin")
$folders.Remove("Administrator")

forEach($folder in $folders)
{
    $path = "C:\Users\$folder"
    $path

    if(test-path -path $path)

    {
        Write-Host "Deleting user profile for $folder" -ForegroundColor DarkGreen -BackgroundColor Black
        $start_time = Get-Date
        $user = $path
        Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $user } | Remove-CimInstance
        Write-Host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
        Write-Host "Deleted $folder profile" -ForegroundColor DarkYellow -BackgroundColor Black
    }
    else
    {
        Write-Host "Folder Not present"

    }
}
Write-Host "Completed"
