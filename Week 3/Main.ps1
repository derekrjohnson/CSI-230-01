# Import the functions from the first script file
. (Join-Path $PSScriptRoot 'Get-LogInOuts.ps1')
. (Join-Path $PSScriptRoot 'Get-StartShuts.ps1')

# Call the functions and print the results on the screen
$logInOutsResult = Get-LogInOuts -lookback -14
$logInOutsResult 

$systemEventsResult = Get-SystemEvents -lookback -14
$systemEventsResult 