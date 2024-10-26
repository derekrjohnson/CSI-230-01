. "C:\Users\champuser\CSI-230-01\Week 6\Event-Logs.ps1"
. "C:\Users\champuser\CSI-230-01\Week 7\configuration.ps1"
. "C:\Users\champuser\CSI-230-01\Week 7\Email.ps1"
. "C:\Users\champuser\CSI-230-01\Week 7\Scheduler.ps1"

# Obtaining configuration
$configuration = Get-Content "C:\Users\champuser\CSI-230-01\Week 7\configuration.txt"

# Parse the configuration file
$days = [int]$configuration[0]  # The first line contains the number of days
$time = $configuration[1]        # The second line contains the time

# Get at-risk users based on the number of days
$Failed = getFailedLogins $days | Group-Object User | Where-Object { $_.Count -gt 10 } | Select-Object Count, Name

# Send at-risk users as email
SendAlertEmail ($Failed | Format-Table | Out-String)

# Set the script to be run daily at the specified time
ChooseTimeToRun($time)