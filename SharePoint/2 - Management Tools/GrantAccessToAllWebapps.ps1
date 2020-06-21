$userOrGroup = "i:0#.w|collabtr\gokan_ozcifci" 
$displayName = "SharePoint Admin"

Get-SPWebApplication | foreach { 
    $webApp = $_ 
    $policy = $webApp.Policies.Add($userOrGroup, $displayName) 
    $policyRole = $webApp.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullControl) 
    $policy.PolicyRoleBindings.Add($policyRole) 
    $webApp.Update() 
}


$userOrGroup = "i:0#.w|collabtr\gokan_ozcifci" 
$displayName = "SharePoint Admin"

Get-SPWebApplication | foreach { 
    $webApp = $_ 
    $policy = $webApp.Policies.Remove($userOrGroup)
    #$policyRole = $webApp.PolicyRoles.GetSpecialRole([Microsoft.SharePoint.Administration.SPPolicyRoleType]::FullControl) 
    #$policy.PolicyRoleBindings.Add($policyRole) 
    $webApp.Update() 
}