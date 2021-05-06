<#

.Synopsis
This PowerShell script gives the list of active users and disconnected users in the computer.

.Description
This PowerShell Script queries all the users and segregates the user based on the user state.

.Input
No inputs are required to run this script.

.Output
Outputs the users active and disconnected list into the C drive.

.Notes
Name: UserSessionState.ps1
Author: Yaqoob Sheriff R

#>

$Results = qwinsta /server:$env:computername
		$ObjMembers = ($Results[0].trim(" ") -replace ("\b *\B")).split(" ")
		$Results = $Results[1..$($Results.Count - 1)]
$Active = @()
$Disc=@()
		foreach ($Result in $Results) {
            if($result -like "*Active*")
            {
			$ActiveMember = New-Object Object
			Add-Member -InputObject $ActiveMember -MemberType NoteProperty -Name $ObjMembers[1] -Value $Result.Substring(19,22).Trim()
			Add-Member -InputObject $ActiveMember -MemberType NoteProperty -Name $ObjMembers[2] -Value $Result.Substring(41,7).Trim()
			Add-Member -InputObject $ActiveMember -MemberType NoteProperty -Name $ObjMembers[3] -Value $Result.Substring(48,8).Trim()
			if ($full) {
				Add-Member -InputObject $ActiveMember -MemberType NoteProperty -Name $ObjMembers[0] -Value $Result.Substring(1,18).Trim()
				Add-Member -InputObject $ActiveMember -MemberType NoteProperty -Name $ObjMembers[4] -Value $Result.Substring(56,12).Trim()
				Add-Member -InputObject $ActiveMember -MemberType NoteProperty -Name $ObjMembers[5] -Value $Result.Substring(68,8).Trim()
			}
			$Active += $ActiveMember
		    }        
}
$Ausers= $Active 
$Ausers|ConvertTo-Json| Out-file -FilePath "C:\active.txt"  
Invoke-Item "C:\active.txt"



		foreach ($line in $Results) {
            if($line -like "*Disc*")
            {
			$DiscMember = New-Object Object
			Add-Member -InputObject $DiscMember -MemberType NoteProperty -Name $ObjMembers[1] -Value $line.Substring(19,22).Trim()
			Add-Member -InputObject $DiscMember -MemberType NoteProperty -Name $ObjMembers[2] -Value $line.Substring(41,7).Trim()
			Add-Member -InputObject $DiscMember -MemberType NoteProperty -Name $ObjMembers[3] -Value $line.Substring(48,8).Trim()
			if ($full) {
				Add-Member -InputObject $DiscMember -MemberType NoteProperty -Name $ObjMembers[0] -Value $line.Substring(1,18).Trim()
				Add-Member -InputObject $DiscMember -MemberType NoteProperty -Name $ObjMembers[4] -Value $line.Substring(56,12).Trim()
				Add-Member -InputObject $DiscMember -MemberType NoteProperty -Name $ObjMembers[5] -Value $line.Substring(68,8).Trim()
			}
			$Disc += $DiscMember
		}
}
$Dusers= $Disc 
$Dusers|ConvertTo-Json| Out-file -FilePath "C:\disc.txt"
Invoke-Item "C:\disc.txt"
       