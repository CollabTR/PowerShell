#This script will create a new Web Application

#Variables
$sp_webapp_name = "CollabTR Site QA"
$sp_webapp_port = "443"
$sp_webapp_url = "https://site.collabtr.local"
$sp_webapp_apppool = "site QA"
$sp_webapp_apppoolaccount = ""
$sp_webapp_databasename = ""
$sp_webapp_databaseserver = ""
$sp_webapp_hostheader = ""

#This is the Account which will be used for the Portal Super Reader Account
$PortalSuperReader = "i:0#.w|CollabTR\QA_SPSupUser"

#This is the Account which will be used for the Portal Super User Account
$PortalSuperUser = "i:0#.w|CollabTR\QA_SPSuperUser"


#Script
$appPoolAccount = Get-SPManagedAccount -Identity $sp_webapp_apppoolaccount -EA 0
  if($appPoolAccount -eq $null)
  {
      Write-Host "Please supply the password for the Service Account..."
      $appPoolCred = Get-Credential $sp_webapp_apppoolaccount
      $appPoolAccount = New-SPManagedAccount -Credential $appPoolCred -EA 0
  }
        
        $ap = New-SPAuthenticationProvider
        
        $webapp = new-spwebapplication -name $sp_webapp_name -Port $sp_webapp_port -URL $sp_webapp_url -ApplicationPool $sp_webapp_apppool -HostHeader $sp_webapp_hostheader -ApplicationPoolAccount $appPoolAccount -DatabaseName $sp_webapp_databasename -DatabaseServer $sp_webapp_databaseserver -AuthenticationProvider $ap -SecureSocketsLayer 

        
        Write-Progress -Activity "Creating Web Application" -Status "Configuring Object Cache Accounts"
        
        #Assign Object Cache Accounts
        $WebApp.Properties["portalsuperuseraccount"] = $PortalSuperUser
        $WebApp.Properties["portalsuperreaderaccount"] = $PortalSuperReader
        
        Write-Progress -Activity "Creating Web Application" -Status "Creating Object Cache User Policies for Web Application"
        
        #Create a New Policy for the Super User
        $SuperUserPolicy = $WebApp.Policies.Add($PortalSuperUser, "Portal Super User Account")
        #Assign Full Control To the Super User
        $SuperUserPolicy.PolicyRoleBindings.Add($WebApp.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullControl))

        #Create a New Policy for the Super Reader
        $SuperReaderPolicy = $WebApp.Policies.Add($PortalSuperReader, "Portal Super Reader Account")
        #Assign Full Read to the Super Reader
        $SuperReaderPolicy.PolicyRoleBindings.Add($WebApp.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullRead))
        
        Write-Progress -Activity "Creating Web Application" -Status "Updating Web Application Properties"
        #Commit changes to the web application
        $WebApp.update()

