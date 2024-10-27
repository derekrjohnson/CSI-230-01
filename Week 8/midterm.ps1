function Scrape-TableFromWebsite {
    param (
        [string]$url  # The URL of the web page to scrape
    )

    # Use Invoke-WebRequest to fetch the HTML content
    $response = Invoke-WebRequest -Uri $url

    # Load the HTML document
    $htmlDocument = $response.ParsedHtml

    # Initialize the final table (collection to store valid rows)
    $finalTable = @()

    # Assuming the table is the first table in the document
    $rows = $htmlDocument.getElementsByTagName("tr")

    foreach ($tr in $rows) {
        $tds = $tr.getElementsByTagName("td")
        
        # Skip the row if there are no <td> elements
        if ($tds.length -eq 0) {
            continue
        }

        $i = 0
        $rowData = New-Object PSObject -Property @{
            Pattern = $null
            Explanation = $null
        }

        foreach ($td in $tds) {
            if ($i -eq 0) {
                $rowData.Pattern = $td.innerText.Trim()
            } elseif ($i -eq 1) {
                $rowData.Explanation = $td.innerText.Trim()
            }
            $i++
        }

        # Only add to final table if both Pattern and Explanation have valid data
        if ($rowData.Pattern -and $rowData.Explanation) {
            $finalTable += $rowData
        }
    }

    # Output the final table directly
    return $finalTable
}

# Example of how to call the function
Scrape-TableFromWebsite -url "http://localhost/IOC.html"  # Replace with your actual URL

# Initiate the function
function GetApacheLogs {

    # Define regex pattern for log entry
    $regexPattern = '^(?<ip>[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) - - \[(?<time>[^\]]+)\] "(?<method>[A-Z]+) (?<page>[^\s]+) (?<protocol>[^\s]+)" (?<response>[0-9]+) [0-9]+ "(?<referer>[^"]*)"'

    # Get all log entries from the file
    $logEntries = Get-Content C:\Users\champuser\Downloads\access.log

    # Initialize an array to hold the results
    $results = @()

    # Process each log entry
    foreach ($entry in $logEntries) {
        if ($entry -match $regexPattern) {
            # Create a custom object for the matched log entry
            $result = [PSCustomObject]@{
                IP        = $matches['ip']
                Time      = $matches['time']
                Method    = $matches['method']
                Page      = $matches['page']
                Protocol  = $matches['protocol']
                Response  = $matches['response']
                Referer   = $matches['referer']
            }
            $results += $result
        }
    }

    # Return the results
    return $results
}

# Call the function without filtering
GetApacheLogs | Format-Table

# Function to filter logs based on indicators
function FilterLogsByIndicators {
    param (
        [array]$logs,        # Array of log entries from GetApacheLogs
        [array]$indicators   # Array of indicators from Scrape-TableFromWebsite
    )

    # Initialize an array to hold the filtered results
    $filteredResults = @()

    $patterns = @()  # Initialize an empty array
    foreach ($indicator in $indicators) {
        $patterns += $indicator.Pattern # Add each pattern to the array
    }

    # Loop through each log entry
    foreach ($log in $logs) {
        # Check if the Page property contains any of the patterns
        foreach ($pattern in $patterns) {
            if ($log.Page -like "*$pattern*") {
                $filteredResults += $log
                break  # Exit the inner loop if a match is found
            }
        }
    }

    # Return the filtered results
    return $filteredResults
}

# Example usage
$url = "http://localhost/IOC.html"  # Replace with your actual URL
$indicators = Scrape-TableFromWebsite -url $url  # Get indicators from the web page
$logs = GetApacheLogs  # Get logs from the log file

# Filter logs based on indicators
$filteredLogs = FilterLogsByIndicators -logs $logs -indicators $indicators

# Display the filtered logs in a table format
$filteredLogs | Format-Table -AutoSize