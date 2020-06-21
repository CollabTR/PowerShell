<#    IIS-Reset.ps1
Run IISReset on Multiple Servers #>

#Specify servers in an array variable
[array]$servers = "SERVER1,SERVER2"

#Step through each server in the array and perform an IISRESET
foreach ($server in $servers)
{
    Write-Host "Restarting IIS on server $server..."
    IISRESET $server /noforce
    Write-Host "IIS status for server $server"
    IISRESET $server /status
}
Write-Host IIS has been restarted on all servers