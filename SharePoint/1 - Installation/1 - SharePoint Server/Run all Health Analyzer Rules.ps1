Add-PsSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$jobs = Get-SPTimerJob | Where-Object {$_.Title -like "Health Analysis Job*"}
foreach ($job in $jobs)
{
  $job.RunNow()
}