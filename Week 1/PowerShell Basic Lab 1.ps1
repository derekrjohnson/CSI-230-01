# Get IPv4 Address from Ethernet 0 Interface
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ilike "Ethernet0"} | Format-Table IPAddress

# Get IPv4 PrefixLength from Ethernet Interface
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ilike "Ethernet0"} | Format-Table PrefixLength

# Classes sorted alphabetically
Get-WmiObject -List | Where-Object {$_.Name -like "win32_Net*"} | Sort-Object Name

# Get dhcp server ip and hide the table headers
Get-CimInstance win32_networkadapterconfiguration -Filter "DHCPEnabled = $true" | Select DHCPServer | Format-Table -HideTableHeaders

# Get DNS Server IPs for Ethernet Interface and only display the first one
(Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ilike "Ethernet*"}).ServerAddresses

# choose a directory where you have some .ps1 files
cd $PSScriptRoot

# list files based on the file name 
$files = Get-ChildItem

for ($j=0; $j -lt $files.Count; $j++){

    if ($files[$j].Name -ilike "*ps1"){
        Write-Host $files[$j].Name
    }

}

# Create folder 
$folderpath="PSScriptRoot\outfolder"
if (Test-Path $folderpath){
    Write-Host "Folder Already Exists"
}
else {
    New-Item -ItemType Directory -path $folderpath
}

# Navigate to the CSI-230-01 folder, needs to be run in CSI folder
cd $PSScriptRoot

# List all the files in the CSI-230-01 folder
$files = Get-ChildItem -Recurse -File
$files

# Create the outfolder directory if it doesn't exist
$folderPath = "$PSScriptRoot\outfolder"
$filePath = Join-Path -Path $folderPath -ChildPath "output.csv"
$filePath

# List all the files that have the extension ".ps1" and save the results to output.csv file
$files | Where-Object Extension -eq ".ps1" | Export-Csv -Path $filePath


# Without changing the diectory find every .csv file and change their extensions to .log then recursively display all the files
$files = Get-ChildItem -Path . -Filter *.csv -Recurse
$files
$files | ForEach-Object { Rename-Item -Path $_.FullName -NewName ($_.Name -replace 'csv', 'log') }
Get-ChildItem -Path . -Recurse