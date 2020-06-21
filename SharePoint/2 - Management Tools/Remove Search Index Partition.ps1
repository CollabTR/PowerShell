#Clone Active Search Topology
$ssa = Get-SPEnterpriseSearchServiceApplication
$active = Get-SPEnterpriseSearchTopology -SearchApplication $ssa -Active
$clone = New-SPEnterpriseSearchTopology -SearchApplication $ssa -Clone –SearchTopology $active

# Get the Index Search Component ID To Remove (Check this one with yours)
$indexComponentID = (Get-SPEnterpriseSearchComponent -SearchTopology $clone -Identity IndexComponent3).componentID

# Remove Search Component
Remove-SPEnterpriseSearchComponent -Identity $indexComponentID.GUID -SearchTopology $clone -confirm:$false

# Activate  Search Topology Again
Set-SPEnterpriseSearchTopology -Identity $clone

##############################################################################################
#                                                                                         
#IndexComponent3 > Peux-être modifié avec Crawler, Administration, >> Genre IndexComponent2
#Get-SPEnterpriseSearchComponent -SearchTopology $clone | where {$._Name -eq "*admin*"}
#
##############################################################################################