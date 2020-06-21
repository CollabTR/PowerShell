$oneSiteCol = "https://collab.collabtr.local"
          foreach ($oneUser in Get-SPUser -Web $oneSiteCol)
          {
              if ($oneUser.UserLogin -gt "collabtr") 
              {
                  Write-Host $oneUser
                  #$user = Get-SPUser -web $oneSiteCol -Identity $oneUser.UserLogin 
                  Move-SPUser -IgnoreSID -Identity $oneUser -NewAlias "i:0#.w|$oneUser" -Confirm:$false
              }
          }
