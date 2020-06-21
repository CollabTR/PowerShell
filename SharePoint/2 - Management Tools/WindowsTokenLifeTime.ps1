$sts = Get-SPSecurityTokenServiceConfig
$sts.FormsTokenLifetime = (New-TimeSpan -minutes 2)
$sts.WindowsTokenLifetime = (New-TimeSpan -minutes 2)
$sts.LogonTokenCacheExpirationWindow = (New-TimeSpan -minutes 1)
$sts.Update()
iisreset /noforce