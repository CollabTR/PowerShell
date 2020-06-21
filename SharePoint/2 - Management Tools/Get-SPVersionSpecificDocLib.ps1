$siteURL = "https://thehub.collabtr.local/fenerbahce"
$site = Get-SPSite($siteURL)
foreach($web in $site.AllWebs) {
 Write-Host "Inspecting " $web.Title
 foreach ($list in $web.Lists | where {$_.EntityTypeName -eq "PM_x0020_Governance"}) {
 if($list.BaseType -eq "DocumentLibrary") {
 Write-Host $list.EntityTypeName
 write-host "================================================="
 Write-Host "Versioning enabled: " $list.EnableVersioning
 $host.UI.WriteLine()
 Write-Host "MinorVersioning Enabled: " $list.EnableMinorVersions
 $host.UI.WriteLine()
 Write-Host "EnableModeration: " $list.EnableModeration
 $host.UI.WriteLine()
 Write-Host "Major Versions: " $list.MajorVersionLimit
 $host.UI.WriteLine()
 Write-Host "Minor Versions: " $list.MajorWithMinorVersionsLimit
 $list.MajorVersionLimit = 255
 $list.update()
 }
 }}