  <#

.Synopsis
  This script creates Active Directory users provided in the CSV file and assigns the home directory path to the user.

.Description
  This script fetches the usernames and passwords from the excel sheet then creates the users with the usernames and password provided.
  Later assigns the home directory path to the user. The CSV file shpould contain "Username" and "Password" as column heads.

.Input
  The path to the CSV file has to be provided. Before runnig the script create a network folder. Share and assign permissions for all the users to have access to the folder.

.Output
Users in the provided CSV file are created with their home directoty path assigned.

.Notes
Name: createUserAndAssignNetworkpath.ps1
Author: Yaqoob Sheriff R

#>

#Provide the path to the CSV file.
$dir = "C:\Users\admin\Desktop\users.csv"
$csv = Import-Csv -Path $dir
$usernames = $csv.Username
$passwords = $csv.Password
   
   
 #Change the path according to your domain.
 $path= "CN=Users,DC=example,DC=com"
 
 #Change the domain accordingly   
 $domainName= "example.com"
 
 for($i=0; $i -le $usernames.Length; $i++ )
    {
	
	$user=$usernames[$i]
    $userprincipalname = $user + "@"+$domainName
     $passwordString= $passwords[$i]
    $userprincipalname
	$output=New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName  $userprincipalname -Name $user -DisplayName $user -GivenName $user -SurName " " -Path $path -AccountPassword (ConvertTo-SecureString $passwordString -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru

    #Assigning user directory and granting permissions

    $samAccountName=$user
    #Change the path to shared path
    $fullPath = "\\networkFolder\Users\{0}" -f $samAccountName
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
     
