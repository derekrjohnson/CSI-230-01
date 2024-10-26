# URL of the web page containing the table
$url = "http://localhost/IOC.html"  # Replace with your actual URL

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

# Output the final table
$finalTable | Format-Table -AutoSize