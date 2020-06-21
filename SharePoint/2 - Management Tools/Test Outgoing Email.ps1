$sd = New-Object System.Collections.Specialized.StringDictionary
$sd.Add("to","gokan@collabtr.com")
$sd.Add("from","hasan@collabtr.com")
$sd.Add("subject","Test Email")
$w = Get-SPWeb https://hub.collabtr.com
$body = "This is a test email sent from SharePoint, Wowee!!"
 
try {
    [Microsoft.SharePoint.Utilities.SPUtility]::SendEmail($w,$sd,$body)
}
finally {
    $w.Dispose()
}