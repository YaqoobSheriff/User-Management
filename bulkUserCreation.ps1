<#

.Synopsis
This PowerShell script can be used for bulk user creation.

.Description
This PowerShell Script uses a for loop and creates the users for testing.


.Input
Change the limit for the for loop to the number of users required

.Output
Creates the user with the provided password.

.Notes
Name: bulkUserCreation.ps1
Author: Yaqoob Sheriff R

#>

 #Change the path according to your domain.
 $path= "CN=Users,DC=example,DC=com"
 
 #Change the domain accordingly   
 $domainName= "example.com"

#Change the password accordingly
 $passwordString = "p@$$aword"

 for($i=1; $i -le 100; $i++ )
    {
	
	$user="user"+$i
    $userprincipalname = $user + "@"+$domainName
    $userprincipalname
	$output=New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName  $userprincipalname -Name $user -DisplayName $user -GivenName $user -SurName " " -Path $path -AccountPassword (ConvertTo-SecureString $passwordString -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru -HomeDirectory "\\WIN-EPT5DMUGTKN\Students Files\%username%" -HomeDrive "Z:"
     if($output)
     {
        Write-Host "user $user created successfully."
     }
}