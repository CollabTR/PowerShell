Add-pssnapin "Microsoft.SharePoint.Powershell"
$webapps = Get-SPWebApplication
foreach ($webapp in $webapps)
{
    $webapp.BrowserFileHandling = "permissive"
    $webapp.Update()
}