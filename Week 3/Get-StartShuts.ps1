function Get-SystemEvents {
    param ($lookback)

    $systemEvents = Get-EventLog -LogName System -InstanceID 6005, 6006 -After (Get-Date).AddDays($lookback)

    $systemEventsTable = @()
    for ($i=0; $i -lt $systemEvents.Count; $i++) {

        # Creating event property value
        $event = ""
        if ($systemEvents[$i].InstanceID -eq 6005) {$event="Start"}
        if ($systemEvents[$i].InstanceID -eq 6006) {$event="Shut-down"}

        # Adding each new line to our empty array
        $systemEventsTable += [PSCustomObject]@{
            "Time" = $systemEvents[$i].TimeGenerated.ToString("MM/dd/yyyy hh:mm:ss tt");
            "Id" = $systemEvents[$i].EventID;
            "Event" = $event;
            "User" = "System";
        }
    }

    $systemEventsTable
}

# Call the function with the parameter and print the results on the screen
$systemEventsResult = Get-SystemEvents -lookback -14
$systemEventsResult | Format-Table


