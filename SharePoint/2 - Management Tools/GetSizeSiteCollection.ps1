$CurrentDate = Get-Date -format d

$WebApps = Get-SPWebApplication

#foreach($WebApp in $WebApps)
#{

#$Sites = Get-SPSite -WebApplication $WebApp -Limit All
#foreach($Site in $Sites)
#{

$Site = Get-SPSite https://my.collabtr.local/personal/gokan_ozcifci

$SizeInB = $Site.Usage.Storage
$SizeInGB = $SizeInB/1024/1024/1024
$SizeInGB = [math]::Round($SizeInGB,3)
$SizeInGB

#$CSVOutput = $Site.RootWeb.Title + "*" + $Site.URL + "*" + $Site.ContentDatabase.Name + "*" + $SizeInGB + "*" + $CurrentDate
#$CSVOutput | Out-File $SizeLog -Append

#}
#}

$Site.Dispose()
