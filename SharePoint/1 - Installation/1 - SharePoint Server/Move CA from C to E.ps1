Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Import IIS Module
Import-Module WebAdministration
 
#Variables
$WebAppURL="http://collabtr030:2016/"
$NewPath="E:\inetpub\wwwroot\wss\VirtualDirectories\32553"    
$IISSiteName = "SharePoint Central Administration v4"
  
#Get Web Applications' IIS Settings
$WebApp = Get-SPWebApplication $WebAppURL
$IISSettings = $WebApp.IisSettings[[Microsoft.SharePoint.Administration.SPUrlZone]::Default]
$OldPath = $IISSettings.Path
 
#Check if destination folder exists already. If not, create the folder
if (!(Test-Path -path $NewPath))       
{           
    $DestFolder = New-Item $NewPath -type directory         
}
 
#***** Step 1 - Copy Current Virutal Directory to new location **** #
Copy-Item -Path $OldPath\* -Destination $NewPath -Force -Recurse
 
#***** Step 2 - Change IIS Web Site's Physical path ******
Set-ItemProperty "IIS:\Sites\$($IISSiteName)" -name PhysicalPath -value $NewPath
 
#***** Step 3 - Update SharePoint Web Application ******
#Change the Web App path
$IISSettings.Path = $NewPath
#Update Web Application
$WebApp.Update()

