# Get IPv4 Address from Ethernet 0 Interface
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ilike "Ethernet0"} | Format-Table IPAddress

# Get IPv4 PrefixLength from Ethernet Interface
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ilike "Ethernet0"} | Format-Table PrefixLength

