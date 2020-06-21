Write-host "Adding SharePoint Snapin"
$Host.Runspace.ThreadOptions = "ReuseThread"
Add-PSSnapin microsoft.sharepoint.powershell -ErrorAction SilentlyContinue
Write-host "Importing AD module"
import-module activedirectory -ErrorAction SilentlyContinue

write-host "Starting work..."
#Hard coded variables for testing, 
# we need the name of the AD Group, the name of the corresponding group in Sharepoint to sync with, and the URL of the SPWeb where the SP group resides.
$ADgroupname = "CN=SP_16,OU=SharePoint,DC=CollabTR,DC=LOCAL"
#Get-ADGroup -Filter * | Select distinguishedName, Name
$SPGroupName = "Test group"
$spweburl = "https://collabtr.local/int/ICT/"
#note that it's reasonably easy to turn this hardcoded list into a CSV import and then loop through multiple groups

[Microsoft.ActiveDirectory.Management.ADPropertyValueCollection]$Type = Get-ADGroupMember $ADgroupname | select PropertyNames
#get a list of the AD Users in the AD Group
#$ADGroupMembers = get-adgroupmember -Identity $ADgroupname | select @{name="LoginName";expression={$_.samaccountname}}
$ADGroupMembers = Get-ADGroupMember $ADgroupname | select samaccountname, email, name
if ($ADGroupMembers -eq $null)
{
    write-host "The AD Group we're syncing with is empty - this is usually a problem or typo - the SP group will be left alone" -foregroundcolor red
    return;
}

#get the list of users in the SharePoint Group
$web = get-spweb $spweburl
$group = $web.groups[$SPGroupName]
if ($group -eq $null) {write-host "SPGroup Not found" ; return}
$spusers = $group.users | select @{name="LoginName";expression={$_.LoginName.toupper()}}
  
write-host "Debug: at this point we should have a list of user ID's from SharePoint in domain\user format, uppercase" 
foreach($x in $spusers)
{
write-host $x.LoginName -foregroundcolor green
}
  
if($spusers -eq $null)
{
    write-host "The SPgroup is empty" -foregroundcolor cyan
    write-host "Adding all AD group members to the SP group"
    foreach ($ADGroupMember in $ADGroupMembers)
    {
        #add the AD group member to the SP group. 
        #Please add code to get the domain or fix it if you have only one doain
        $Domain= "collabtr.local\"
        $SamAccountName = $ADGroupMember.samaccountname
        $UserName = $Domain + $ADGroupMember.samaccountname
        $DisplayName = $ADGroupMember.name
        $Email = (Get-ADUser $SamAccountName -Properties mail).mail
        write-host "Adding $()" 
        write-host "new-spuser -useralias $($UserName) -web $($web.url) -group $SPGroupName" -foregroundcolor green
        $SPUser = $web.EnsureUser($UserName)
        try
        {
            $group.AddUser($SPUser)
        }
        catch
        {
            Write-Host "User already exists..." -ForegroundColor Red
        }
        write-host "User is Added..." -ForegroundColor Green      
    }
    write-host "Done adding users - script will now exit" -foregroundcolor magenta



