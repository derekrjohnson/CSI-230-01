# initiate function
function parseLogs(){

    # pull the raw data
    $rawLog = Get-Content C:\xampp\apache\logs\access.log
    $tableLogs = @()

    # parse each line in the data
    foreach ($i in $rawLog) {

        # split the lines with the space delimiter
        $words = $i.Split(" ");

        # populate the custom object
        $tableLogs += [PSCustomObject]@{ "IP" = $words[0];
                                         "Time" = $words[3].Trim('['); 
                                         "Method" = $words[5].Trim('"');
                                         "Page" =  $words[6];
                                         "Protocol" = $words[5];
                                         "Response" = $words[8];
                                         "Referrer" = $words[10];
                                         "Client" = $words[11..($words.Length)]; }
    }
# return where ips like 10.*
return $tableLogs | Where-Object { $_.IP -like "10.*" }
}

# write the results
$tableRecords = parseLogs
$tableRecords | Format-Table -AutoSize -Wrap