﻿############################################################################### 
# This script gets list of administrators for each site collection within  
# sharepoint farm and saves output in tab separated format (.csv) file.  
############################################################################### 
 
#Set file location for saving information. We'll create a tab separated file. 
$FileLocation = "d:\box\SiteCollectionOwnersReport.csv" 
 
#Load SharePoint snap-in 
Add-PSSnapin Microsoft.SharePoint.PowerShell 
 
#Fetches webapplications in the farm 
$WebApplications = Get-SPWebApplication -IncludeCentralAdministration 
Write-Output "URL `t ID `t Site Collection Owner `t Site Collection Owner Email `t Site Collection Secondary Owner `t Site Collection Secondary Owner Email " | Out-file $FileLocation 
 
foreach($WebApplication in $WebApplications){ 
    #Fetches site collections list within sharepoint webapplication 
    Write-Output "" 
    Write-Output "Working on web application $($WebApplication.Url)" 
    $Sites = Get-SPSite -WebApplication $WebApplication -Limit All     
 
    foreach($Site in $Sites){      
            #Fetches information for each  site 
            Write-Output "$($Site.Url) `t $($Site.Owner.Name) `t $($Site.Owner.Email) `t $($Site.SecondaryContact.Name) `t $($Site.SecondaryContact.Email)" | Out-File $FileLocation -Append 
            $Site.Dispose() 
    } 
} 
 
#Unload SharePoint snap-in 
Remove-PSSnapin Microsoft.SharePoint.PowerShell 
 
Write-Output "" 
Write-Output "Script Execution finished" 
     
############################################################################## 
## End of Script 
##############################################################################