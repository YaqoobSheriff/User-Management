<#

.Synopsis
This PowerShell script sends a logoff message to all the active users in the computer.

.Description
This PowerShell Script queries all the users and then sends message to save their progress. This script can be scheduled in the Task Scheduler to run on specif times.

.Input
No inputs required to run the scripts. Change the message as required.

.Output
Message will be sent to all the active users.

.Notes
Name: userLogoffNotification.ps1
Author: Yaqoob Sheriff R

#>

$userobjectarray=@()
$computers= get-adcomputer -Filter *
foreach($computer in $computers)
{
$computername= $computer.Name
    
      $users = qwinsta /server:$computername  2>&1
        forEach($line in $users ){
        if($line -like "*Active*"){
            $line
            $user=$line -replace '\s{2,}', ',' 
            $usersarray= $user.split(',')
            $usersarray[1]
            $usersarray[2]
            $computername
            $msg = "You will be logged off in 5 minutes. Save your progress."
            Send-RDUserMessage -HostServer $computername -UnifiedSessionID $usersarray[2] -MessageTitle "Message from Administrator" -MessageBody $msg
            
    }
   }
  
}




