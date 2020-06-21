$allsites = Get-SPSite -Limit ALL # -WebApplication https://collaborate.collabtr.local



$logfileALLSCs = "D:\Box\Migration\ALLSC_" +  (get-date).ToString("yyyyMMdd_HHmmss") + ".csv"
"Date", "Site","LoginName 1", "DisplayName 1","LoginName2", "DisplayName 2","LoginName 3", "DisplayName 3" -join ';' | Out-File $logfileALLSCs -Append

foreach($site in $allsites)
{
    Write-Host $site.Url
    $SCadmins = ""
    $users = Get-SPUser -web $site.url -Limit ALL | where {$_.IsSiteAdmin} # |Format-Table UserLogin, Displayname
    foreach ($user in $users) 
    {
        Write-Host $user.LoginName $user.DisplayName 
        if ($user.DisplayName -ne "sp16ProdmyPool")
        {
        $SCadmins = $SCadmins + $user.LoginName + ";" + $user.DisplayName + ";"
        }
        
    }
    (Get-Date -Format G), $site.url, $SCadmins  -join ';' | Out-File $logfileALLSCs -Append
}






