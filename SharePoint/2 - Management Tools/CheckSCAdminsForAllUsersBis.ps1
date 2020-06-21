$spWebApp = Get-SPWebApplication "https://collabtr.local"

foreach($oneSite in $spWebApp.Sites)
{ 
            $i = $i + 1

    #write-host $oneSite.url
 

    $bSCadminFound = $false
    $users = Get-SPUser -web  $oneSite.url -Limit All | where {$_.IsSiteAdmin} # |Format-Table UserLogin, Displayname
    foreach ($user in $users)
    { 
        if($user.UserLogin -ne "i:0#.w|collabtr\sp16prodmypool")
        {
            #write-host $user.UserLogin";"$user.displayname
            $bSCadminFound = $true
        }
    }
    if(!$bSCadminFound)
        {
        write-host $oneSite.url
        write-host "NO SCadmin for" $oneSite.url -ForegroundColor Red
        $oneSite.url -join ';' | Out-File $logfileSCAdminsMissing -Append

        $j = $j+1
        }  
} 

 write-host "NoSCadmins found number:" $j


