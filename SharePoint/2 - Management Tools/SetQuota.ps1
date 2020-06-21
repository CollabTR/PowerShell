$SPWebApp = Get-SPWebApplication https://memopoint.collabtr.com
$maxinGB = 1gb * 100
$warninginGB = 1gb * 90

foreach ($SPSite in $SPWebApp.Sites)
{
    if ($SPSite -ne $null)
    {
        Set-SPSite -Identity $SPSite.url -MaxSize $maxinGB  -WarningSize  $warninginGB 

        $SPSite.Dispose()
    }
}