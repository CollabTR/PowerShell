Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Load the assemblies required for the SQL database rename.
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended")
 
#Function to Rename Database in SQL Server
function Rename-SQLDatabase($DBServerName, $OldDatabaseName, $NewDatabaseName)
{
    try
    {
        Write-host Establishing connection with SQL Server... -foregroundcolor "Yellow"
        #Connect to the server
        $Server = new-Object Microsoft.SqlServer.Management.Smo.Server($DBServerName)
         
        Write-host Getting the Database in SQL Server... -foregroundcolor "Yellow"
        #Get the database
        $Database = $Server.Databases.Item($OldDatabaseName)
 
        #Kill all active connections to the SQL database
        $Server.KillAllprocesses($OldDatabaseName)
 
        Write-host Renaming  Database in SQL Server... -foregroundcolor "Yellow"
        #Rename the database
        $Database.Rename($NewDatabaseName)
        Write-host Database Renamed from $OldDatabaseName to $NewDatabaseName in SQL Server -ForegroundColor Green
    }
 
    catch
    {
        Write-Error $_.Exception.Message
        Write-Error "Error in Renaming Database in SQL Server!"
    }
}
 
#Function to Rename content database in SharePoint
function Rename-ContentDatabase($OldDBName, $NewDBName)
{
    try
    {
        Write-host Getting SharePoint Content Database ... -foregroundcolor "Yellow"
        $ContentDB = Get-SPContentDatabase | Where-object {$_.Name -eq $OldDBName}
 
        #Get Content Database settings
        $WebApp = $ContentDB.WebApplication.Url
        $DBServer = $ContentDB.Server
        $MaximumSites = $ContentDB.MaximumSiteCount
        $WarningSites = $ContentDB.WarningSiteCount
 
        #Dismount Content Database
        Write-host Dismounting Content Database ... -foregroundcolor "Yellow"
        Dismount-SPContentDatabase $OldDBName -Confirm:$False
 
  
        Write-host Renaming Database: $OldDBName to $NewDBName in SQL Server -foregroundcolor "Yellow"
 
        #Call function to rename Database in SQL Server
        Rename-SQLDatabase $DBServer $OldDBName $NewDBName
 
        Write-host Mounting SharePoint content Database... -foregroundcolor "Yellow"
        #Mount the database back
        Mount-SPContentDatabase -Name $NewDBName -WebApplication $WebApp -DatabaseServer $DBServer -MaxSiteCount $MaximumSites -WarningSiteCount $WarningSites | out-null
 
        Write-host Done!Content Database Renamed from $OldDBName to $NewDBName!! -ForegroundColor Green
    }
     catch
    {
 
        Write-Error $_.Exception.Message
    }
}
 
#Call the function to rename database
#Rename-ContentDatabase "OLD" "NEW"


