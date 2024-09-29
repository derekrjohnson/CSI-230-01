# Import the functions from the first script file
. (Join-Path $PSScriptRoot 'gatherClasses.ps1')

$results = gatherClasses

# List all the classes of Instructor Furkan Paligu
$results | Where-Object {$_.Instructor -like "Furkan Paligu"} | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End"

# List all the classes of JOYC 310 Mondays
$results | Where-Object { ($_.Location -like "JOYC 310") -and ($_.days -contains "Monday") } | Sort-Object "Time Start" | Format-Table "Time Start", "Time End", "Class Code"

# Get ITS instructors
$ITSInstructors = $results | Where-Object {($_."Class Code" -ilike "SYS*") -or ($_."Class Code" -ilike "NET*") -or ($_."Class Code" -ilike "SEC*") -or ($_."Class Code" -ilike "FOR*") -or ($_."Class Code" -ilike "CSI*") -or ($_."Class Code" -ilike "DAT*")}

# output just the ITS instructors
$ITSInstructors | Format-Table -Property Instructor

# List ITS instructors and list in decending order by class count
$ITSInstructors | Group-Object -Property Instructor | 
    Select-Object @{Name='Instructor';Expression={$_.Name}}, 
                  @{Name='Count';Expression={$_.Count}} | 
    Sort-Object -Property Count -Descending | 
    Format-Table -AutoSize