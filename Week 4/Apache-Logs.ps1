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


