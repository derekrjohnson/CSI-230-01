# List the logs
Get-Content C:\xampp\apache\logs\access.log

# List the last 5
Get-Content C:\xampp\apache\logs\access.log -last 5 

# List the logs with 404 or 400
Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 ',' 400 '

# Display only logs that does not contain 200
Get-Content C:\xampp\apache\logs\access.log | Select-String ' 200 ' -NotMatch

# From every .log file in the directory, only get logs that contain "error"
$A = Get-Content C:\xampp\apache\logs\*.log | Select-String 'error'
$A[-5..-1]

# Display only ip addresses for 404
$notFounds = Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 '

# Define a regex for IP addresses
$regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}."

#Get $notFounds records that match to the regex 
$ipsUnorganized = $regex.Matches($notFounds)
$ipsUnorganized

# Get ips and put in custom object
$ips = @()
for ($i=0; $i -lt $ipsUnorganized.Count; $i++){
    $ips += [PSCustomObject]@{ "IP" = $ipsUnorganized[$i].Value;}
}
$ips | where-Object { $_.IP -ilike "10.*" }