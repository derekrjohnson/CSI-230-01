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