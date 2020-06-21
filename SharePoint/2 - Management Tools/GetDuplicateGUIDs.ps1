

#foreach($site in Get-SPSite -WebApplication https://work.collabtr.local -Limit ALL) {
foreach($site in Get-SPSite -contentdatabase  ContentDB007 -Limit all) {
    #Write-Host $site.Url, $site.RootWeb.ID, $site.contentDatabase.name 
    
    $site.Url, $site.RootWeb.ID, $site.contentDatabase.name -join ';' | Out-File D:\Box\sitesGUID.csv -Append
       
    foreach($web in $site.allwebs)
    {

        Write-Host $web.Url,$web.id 
        $web.Url,$web.id -join ';' | Out-File D:\Box\sitesGUID.csv -Append


        foreach($list in $web.lists)
        {
           $list.DefaultViewUrl,$list.id -join ';' | Out-File D:\Box\sitesGUID.csv -Append
           #write-host $list.DefaultViewUrl,$list.id
           #write-host $list.id
        }
     }
         #echo $site.RootWeb.ID
        #anything else here
}

