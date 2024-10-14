& (Join-Path (Join-Path $parentDir "Week 4") "Apache-Logs.ps1")
& (Join-Path $PSScriptRoot "Event-Logs.ps1")
& (Join-Path (Join-Path $parentDir "Week 2") "Process-Management-4.ps1")

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - Display the last 10 apache logs`n"
$Prompt += "2 - Last 10 failed logons for all users`n"
$Prompt += "3 - Display at risk users`n"
$Prompt += "4 - Start chrome and go to champlain`n"
$Prompt += "5 - Exit`n"

$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 5){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        GetApacheLogs "index.html" 200 "Chrome" | Select-Object -Last 10 | Format-Table
    }

    elseif($choice -eq 2){
        getFailedLogins 10 | Select-Object -Last 10 | Format-Table
    }

    elseif($choice -eq 3){
        $failedLogons = getFailedLogins 10
        Write-Host ($failedLogins | Group User | Where-Object { $_.Count -gt 10 } | Select-Object Count, Name  | Format-Table | Out-String)
    }
    elseif($choice -eq 4){
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
    }
    else {
        Write-Host "Please choose a valid option 1-10"
    }
 }
