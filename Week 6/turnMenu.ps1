function Get-LogInOuts {
    param ($lookback)

    $logInOuts = Get-EventLog -LogName System -InstanceID 7001, 7002 -After (Get-Date).AddDays($lookback)

    $logInOutsTable = @()
    for ($i=0; $i -lt $logInOuts.Count; $i++) {

        # Creating event property value
        $event = ""
        if ($logInOuts[$i].InstanceID -eq 7001) {$event="Logon"}
        if ($logInOuts[$i].InstanceID -eq 7002) {$event="Logoff"}

        # Creating event property value
        $SID = New-Object System.Security.Principal.SecurityIdentifier($logInOuts[$i].ReplacementStrings[1])
        $user = $SID.Translate([System.Security.Principal.NTAccount]).Value

        # Adding each new line to our empty array
        $logInOutsTable += [PSCustomObject]@{
            "Time" = $logInOuts[$i].TimeGenerated.ToString("MM/dd/yyyy hh:mm:ss tt");
            "Id" = $logInOuts[$i].InstanceID;
            "Event" = $event;
            "User" = $user;
        }
    }

    $logInOutsTable
}

# Call the function with the parameter and print the results on the screen
$logInOutsResult = Get-LogInOuts -lookback -14
$logInOutsResult | Format-Table






# Initiate the function
function GetApacheLogs {

    # Set parameters
    param (
        [string]$pageVisited,
        [int]$responseCode,
        [string]$webBrowser
    )

    # define regex pattern
    $regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}."

    # Get the logs that match
    $logEntries = Get-Content C:\xampp\apache\logs\access.log | Where-Object { $_ -like "*$pageVisited*" -and $_ -like "*$responseCode*" -and $_ -like "*$webBrowser*" }
    
    # Extract the ip address from the logs
    $ipAddresses = $regex.Matches($logEntries)
    return $ipAddresses

}

# Call the function
GetApacheLogs "index.html" 200 "Chrome"




# At risk users


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
