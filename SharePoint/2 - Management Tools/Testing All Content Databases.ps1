Add-PSSnapin Microsoft.SharePoint.PowerShell -EA SilentlyContinue
Foreach ($WebApp in (Get-SPWebApplication))
 {"Testing Web Application - " + $WebApp.Name | Write-Host -ForegroundColor Green ;
 Foreach ($CDB in $WebApp.ContentDatabases) 
  {Test-SPContentDatabase -Name $CDB.Name -WebApplication $WebApp.URL -ServerInstance $CDB.Server | ConvertTo-Csv | Out-File -Encoding default -FilePath $("D:\Box\TestDatabases\" + $CDB.Name + ".csv")}}