$h = Get-SPServiceHostconfig
$h.Provision()
foreach ($service in $services) { $service.provision();

write-host $service.name}