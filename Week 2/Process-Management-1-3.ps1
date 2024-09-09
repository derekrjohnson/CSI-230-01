Get-Process | Where-Object { $_.ProcessName -like "C*"}

Get-Process | Where-Object { $_.Path -notlike "*system32*"}

$csvContents = Get-Service | Where-Object { $_.Status -like "Stopped" } | Sort-Object
Get-Service | Where-Object { $_.Status -like "Stopped" } | Sort-Object | Export-Csv -Path "C:\Users\champuser\CSI-230-01\Week 2\stoppedProcesses.csv"