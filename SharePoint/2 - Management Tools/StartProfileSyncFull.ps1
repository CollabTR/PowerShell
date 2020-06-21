Add-PsSnapin Microsoft.SharePoint.PowerShell
$UPS= Get-SPServiceApplication | where { $_.DisplayName -eq “User Profile Service”}
$UPS.StartImport($true)  #$true for FULL