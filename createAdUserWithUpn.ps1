<#
.Synopsis
This powershell script is used to create ADUser with their desired domain.
Example: "user1@something.com"   

.Description
This PS Script fetches the UPN's in the trusted host of the Active Directory. If the UPN specified doesn't exist it adds the UPN to the trusted hosts and then creates the user with that UPN(domain).

.Input
Params such as "userprefix", "password", "apps" and "upn" has to be passed to the script.
Example: createAdUserWithUpn.ps1 -userprefix user1 -password1 mobilenerd@1 -apps1 office365basic,office365premium,chrome,notepad++ -upn google.com

.Output
creates the ADUser with their desired domain.

.Notes
Name: createAdUserWithUpn.ps1
Author: Yaqoob Sheriff R


#>
param([string[]]$userPrefix,[string[]]$password1,$upn)

#$u = get-aduser $name

    $password=$password1.split(",")
    $user=$userPrefix.split(",")
    $users
    $up=$upn.split(",")
    
 #Change the path according to your domain.
 $path= "CN=Users,DC=example,DC=com"
 
 #Change the domain accordingly   
 $domainName= "example.com"
    
    foreach($name in $up){
    if($up)
    {
    #Adding UPN to the trusted hosts if it isn't already added.
    $name
    $upns=Get-ADForest|select UPNSuffixes
    $upnsuffixes=$upns.UPNSuffixes
        if($upnsuffixes -notcontains $name)
            { 
            $upn
	        $upnMsg="The UPN doesn't exist hence adding UPN:$name"
            Get-ADForest | Set-ADForest -UPNSuffixes @{Add=$name}
	        $upnMsg="Added $name"
            }
            $upnMsg
        }
        }   
        #Create multiple users with the given UPN.
    if($user.Count -gt 1){
        $arr = new-object System.Collections.arrayList
        for($i=0;$i -lt $user.count;$i++)
        {
        
            $passwordString=$password[$i].ToString();
            #Get-ADForest | Set-ADForest -UPNSuffixes @{add=$upn[$i]}
            $userprincipalname = $user[$i] + "@"+$upn[$i]
            $user[$i]
            $output=New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName  $userprincipalname -Name $user[$i] -DisplayName $user[$i] -GivenName $user[$i] -SurName " " -Path $path -AccountPassword (ConvertTo-SecureString $passwordString -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru 
            $object = New-Object -TypeName PSObject
            $object | Add-Member -Name 'userName' -MemberType Noteproperty -Value $output.GivenName
            $arr+=$object
 
        }
        }
        else
        {
            $passwordString=$password.ToString();
            $userprincipalname = $user+ "@"+$upn
            $user
            $output=New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName  $userprincipalname -Name $user -DisplayName $user -GivenName $user -SurName " " -Path $path -AccountPassword (ConvertTo-SecureString $passwordString -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru 
            $object = New-Object -TypeName PSObject
            $object | Add-Member -Name 'userName' -MemberType Noteproperty -Value $output.GivenName
            $arr+=$object
        }

   
$usersfinal=$arr | ConvertTo-Json
return $usersfinal