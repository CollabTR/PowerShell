Add-PSSnapin microsoft.sharepoint.powershell
$farm = Get-SPFarm
$cacheService = $farm.Services | where {$_.Name -eq "AppFabricCachingService"}
$accnt = Get-SPManagedAccount -Identity CORP\SVC_SP2016_SRVP
$cacheService.ProcessIdentity.CurrentIdentityType = "SpecificUser"
$cacheService.ProcessIdentity.ManagedAccount = $accnt
$cacheService.ProcessIdentity.Update()
$cacheService.ProcessIdentity.Deploy()