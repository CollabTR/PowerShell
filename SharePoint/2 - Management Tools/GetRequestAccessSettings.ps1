     
    # Get all sharePoint web applications  
$WebApp = Get-SPWebApplication https://my.collabtr.local
$count = 0

  
# Get all site collections within each webapp  
foreach ($Site in $WebApp.Sites){  
  
    # Get all sites within each sitecollection  
    foreach($Web in $Site.AllWebs){  
  
        # if a site inherits permissions, then the Access request mail setting also will be inherited  
        if($Web.HasUniquePerm){  
        if($Web.RequestAccessEmail -eq "someone@example.com"){  
          #if($Web.url -like '*ozcifci*'){   
            $count = $count + 1
            #Write-Output $web.url # $Web.RequestAccessEmail $count
            $Web.RequestAccessEmail =""
             Write-Host $web.url " updated"
           # }
        }  
        elseif($Web.RequestAccessEmail -eq "someone@example.comxxxxx"){  
            
            
            Write-Output "$site *** " $web.url $Web.RequestAccessEmail
            
            #$Web.RequestAccessEmail = "spadmins@contoso.com"  
            #$Web.Update()  
        }  }
    }  
}
$count