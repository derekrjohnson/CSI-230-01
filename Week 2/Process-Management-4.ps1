# Set chrome variables
$pathToChrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
$tempFolder = '--user-data-dir=c:\temp' # pick a temp folder for user data
$startmode = '--start-fullscreen' # '--kiosk' is another option
$startPage = 'https://champlain.edu'

# get the running chrome processes
$chromeRunningProcesses = Get-Process | Where-Object { $_.ProcessName -like "chrome" } 

if ($chromeRunningProcesses -eq $null -or $chromeRunningProcesses.Count -eq 0) {
    Start-Process -FilePath $pathToChrome -ArgumentList $tempFolder, $startmode, $startPage
} 
else {
    Get-Process | Where-Object { $_.ProcessName -like "chrome" } | Stop-Process -Force
}
