Add-PSSnapin Microsoft.SharePoint.PowerShell

$sourceWebURL = "https://site.collabtr.local/Demo-community"
$sourceListName = "Communication"

$spSourceWeb = Get-SPWeb $sourceWebURL
$spSourceList = $spSourceWeb.Lists[$sourceListName]
$spSourceItems = $spSourceList.Items | where {$_['ID'] -eq 1}
$spSourceItems | ForEach-Object {
     Write-Host $_['Title']
     Write-Host $_['Body']
     Write-Host $_['Send to']

send-mailmessage -from "gokan@collabtr.com" -to $_['Send to']
    -subject $_['Title'] 
    -bodyAsHtml $_['Body']
    -Attachments "data.csv" 
    -priority High 
    -dno onSuccess, onFailure 
    -smtpServer SERVERSMTP.collabtr.local
}