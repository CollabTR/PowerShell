param()

function Get-SPServerList
{
    $spServerList=@()
    $serverList = Get-SPServer
    foreach ($server in $serverList)
    {
        if ($server.Role -ne [Microsoft.SharePoint.Administration.SPServerRole]::Invalid)
        {
            $spServerList += $server.Address
        }
    }
    return $spServerList
}

function Get-SPApplicationPoolUser
{
    $appPoolUsers = @()

    $svcAppPools = Get-SPServiceApplicationPool
    foreach ($svcAppPool in $svcAppPools)
    {
        if ($appPoolUsers.IndexOf($svcAppPool.ProcessAccountName) -eq -1)
        {
            $appPoolUsers += $svcAppPool.ProcessAccountName
        }
    }

    $spWebApps = Get-SPWebApplication -IncludeCentralAdministration
    foreach ($spWebApp in $spWebApps)
    {
        if ($appPoolUsers.IndexOf($spWebApp.ApplicationPool.UserName) -eq -1)
        {
            $appPoolUsers += $spWebApp.ApplicationPool.UserName
        }
    }
    return $appPoolUsers
}

function IsMemberOfGroup([string]$serverName,[string]$groupName,[string]$userName)
{
    $userNameAdsPath = "WinNT://" + $userName.Replace("","/")
    $server = [ADSI]("WinNT://$serverName,computer")
    $group = $server.psbase.children.find($groupName)

    $members = $group.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Adspath", "GetProperty", $null, $_, $null)}
    return $members.IndexOf($userNameAdsPath) -gt -1

}

$spServerList = Get-SPServerList
$spUserList = Get-SPApplicationPoolUser

Write-Host "Checking Performance Log Users group membership for SharePoint Application Pool accounts..." -ForegroundColor Yellow

foreach ($server in $spServerList)
{
    Write-Host "Server: $server" -ForegroundColor Green
    foreach ($user in $spUserList)
    {
        Write-Host "`t User: $user - " -NoNewLine
        if (!(IsMemberOfGroup $server "Performance Log Users" $user))
        {
            Write-Host "Missing" -ForegroundColor Red
        }
        else
        {
            Write-Host "OK" -ForegroundColor Green
        }
    }
    Write-Host ""
}
