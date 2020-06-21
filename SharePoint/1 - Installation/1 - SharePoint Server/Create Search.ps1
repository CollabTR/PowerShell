

$dbName = "SharePoint16_SSA"
Get-SPServiceApplicationPool
$svcAppPool = "SharePoint Web Services System"
#Create Search Application and Initial Topology

    Start-SPEnterpriseSearchServiceInstance $env:COMPUTERNAME -ErrorAction SilentlyContinue
    Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $env:COMPUTERNAME -ErrorAction SilentlyContinue
    $searchSvc = New-SPEnterpriseSearchServiceApplication -Name "Search Service Application" -DatabaseName $dbname -ApplicationPool "SharePoint Web Services System" -AdminApplicationPool "SharePoint Web Services System"
    New-SPEnterpriseSearchServiceApplicationProxy -Name "Search Service Application" -SearchApplication $searchSvc
    $clone = $searchSvc.ActiveTopology.Clone()
    $si = Get-SPEnterpriseSearchServiceInstance -Local
    New-SPEnterpriseSearchAdminComponent -SearchTopology $clone -SearchServiceInstance $si
    New-SPEnterpriseSearchContentProcessingComponent -SearchTopology $clone -SearchServiceInstance $si
    New-SPEnterpriseSearchAnalyticsProcessingComponent -SearchTopology $clone -SearchServiceInstance $si
    New-SPEnterpriseSearchCrawlComponent -SearchTopology $clone -SearchServiceInstance $si
    New-SPEnterpriseSearchIndexComponent -SearchTopology $clone -SearchServiceInstance $si
    New-SPEnterpriseSearchQueryProcessingComponent -SearchTopology $clone -SearchServiceInstance $si
    $clone.Activate()
    #Set the Content Access (Crawl) Account
    $content = New-Object Microsoft.Office.Server.Search.Administration.Content($searchSvc)
    $content.SetDefaultGatheringAccount("$env:USERDOMAIN\$crawlAcct",(ConvertTo-SecureString $crawlAcctPwd -AsPlainText -Force))

    #Enable Crawl Schedule (Including Continous Crawls)
    $csource = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $searchSvc
    Set-SPEnterpriseSearchCrawlContentSource -Identity $csource -ScheduleType Full -WeeklyCrawlSchedule `
    -CrawlScheduleRunEveryInterval 1 -CrawlScheduleDaysOfWeek "Saturday" -CrawlScheduleStartDateTime "10:30 PM"
    #Set-SPEnterpriseSearchCrawlContentSource -Identity $csource -ScheduleType Incremental -DailyCrawlSchedule `
    #-CrawlScheduleRunEveryInterval 1 -CrawlScheduleRepeatInterval 15 -CrawlScheduleRepeatDuration 1440 -Confirm:$false
    $csource.EnableContinuousCrawls = $true
    $csource.Update()