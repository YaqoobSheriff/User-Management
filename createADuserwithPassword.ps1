<#
.Synopsis
This PowerShell script creates AD user with the usernames and passwords provided in the text file. 

.Description
This PowerShell Script fetches the Usernames and Passwords from the text file.
If the UPN specified doesn't exist it adds the UPN to the trusted hosts.
Later creates the user with the added UPN(domain). And removes all the logon hours for the user.
Example: If I add "abc.com" as a UPN Suffix in the trusted host. Then i can have user created as "user1@abc.com"

.Input
Text files with the usernames and passwords should be created seperately.

.Output
Creates the user with the provided password and UPN.

.Notes
Name: createADuserWithPassword.ps1
Author: Yaqoob Sheriff R
#>


$users = get-content -Path "C:\Users\Admin\Desktop\users.txt"
$p = Get-Content -Path "C:\Users\Admin\Desktop\pass.txt"

[byte[]]$hours = @(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
 
 #Change the path according to your domain.
 $path= "CN=Users,DC=example,DC=com"
 
 #Change the domain accordingly   
 $domainName= "example.com"

    for($i=0;$i -le $users.length-1;$i++)
       {
	        $users[$i]
	        $a1=$users[$i].Split('@')
	        $user=$a1[0]
	        $upn=$a1[1].ToString()
    	    $passwordString=$p[$i]
	        $upns=Get-ADForest|select UPNSuffixes
    	    $upnsuffixes=$upns.UPNSuffixes

        	if($upnsuffixes -notcontains $upn)
            { 
            	$upn
	       	    $upnMsg="The UPN doesn't exist hence adding UPN:$upn"
                Get-ADForest | Set-ADForest -UPNSuffixes @{Add=$upn}
	        	$upnMsg="Added $upn"
            }

            $upnMsg
            $userprincipalname = $user + "@"+$upn

    $output=New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName  $userprincipalname -Name $user -DisplayName $user -GivenName $user -SurName " " -Path $path -AccountPassword (ConvertTo-SecureString $passwordString -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru 
    if($i -eq $users.count-1)
    {
        Write-Host "Users created Successfully" -ForegroundColor Green
    }
    get-ADUser -Identity $user | Set-ADUser -Replace @{Logonhours = [Byte[]]$hours}

}