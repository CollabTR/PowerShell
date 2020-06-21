Add-PSSnapin microsoft.sharepoint.powershell

$instanceName ="SPDistributedCacheService Name=AppFabricCachingService"
$serviceInstance = Get-SPServiceInstance | ? {($_.service.tostring()) -eq $instanceName -and ($_.server.name)}
$serviceInstance.Provision()
Use-CacheCluster
Get-AFCacheHostConfiguration -ComputerName TECBEPW030 -CachePort "22233"
Update-SPDistributedCacheSize -CacheSizeInMB 7168
Get-AFCacheHostConfiguration -ComputerName TECBEPW030 -CachePort "22233"
Get-CacheHost