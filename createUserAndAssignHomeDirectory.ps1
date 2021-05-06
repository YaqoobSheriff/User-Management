  <#
.Synopsis
This PowerShell script can be used for bulk user creation and assigning the network drive for all th users.

.Description
This PowerShell Script uses a for loop and creates the users for testing.


.Input
Before runnig the script create a network folder. Share and assign permissions for all the users to have access to the folder.

.Output
Creates the user with the provided password and assigns the nerwork drive.

.Notes
Name: createUserAndAssignHomeDirectory.ps1
Author: Yaqoob Sheriff R
#>

  #Change the path according to your domain.
 $path= "CN=Users,DC=example,DC=com"
 
 #Change the domain accordingly   
 $domainName= "example.com"

 #Change the password accordingly
 $passwordString = "p@$$aword"

 #Change the limit to the number of users required.
 for($i=1; $i -le 50; $i++ )
    {
	
	$user="user"+$i
    $userprincipalname = $user + "@"+$domainName
    $userprincipalname
	$output=New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName  $userprincipalname -Name $user -DisplayName $user -GivenName $user -SurName " " -Path $path -AccountPassword (ConvertTo-SecureString $passwordString -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru

    #Assigning user directory and granting permissions

    $samAccountName=$user
    #Change the path to shared path
    $fullPath = "\\networkFolder\Users$\{0}" -f $samAccountName
    $driveLetter = "E:"
 
    $User = Get-ADUser -Identity $samAccountName
 
    if($User -ne $Null) {
    Set-ADUser $User -HomeDrive $driveLetter -HomeDirectory $fullPath -ea Stop
    $homeShare = New-Item -path $fullPath -ItemType Directory -force -ea Stop
 
    $acl = Get-Acl $homeShare
 
    $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"Modify"
    $AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
    $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
 
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
    $acl.AddAccessRule($AccessRule)
 
    Set-Acl -Path $homeShare -AclObject $acl -ea Stop
 
    Write-Host ("HomeDirectory created at {0}" -f $fullPath)
    } 
}
     
