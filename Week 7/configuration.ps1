function readConfiguration {
    # This function reads and displays the configuration from the file
    $filePath = Join-Path $PSScriptRoot "configuration.txt"
    
    if (Test-Path $filePath) {
        Write-Host "Current Configuration:`n"
        Get-Content $filePath
    } else {
        Write-Host "Configuration file not found."
    }
}

function changeConfiguration {
    # This function prompts the user for new values and updates the configuration file
    $days = Read-Host "Lookback in days?"
    $time = Read-Host "Time to run? (format HH:MM PM/AM)"

    # File path
    $filePath = Join-Path $PSScriptRoot "configuration.txt"

    # Create the new contents with the updated values
    $newContents = "$days`n$time"

    # Write the new contents to the file
    Set-Content $filePath -Value $newContents
    Write-Host "Configuration updated successfully."
}

function configurationMenu {
    # This function presents the menu and handles user choices
    $Prompt = "`n"
    $Prompt += "Please choose your operation:`n"
    $Prompt += "1 - Show configuration`n"
    $Prompt += "2 - Change configuration`n"
    $Prompt += "3 - Exit`n"
    $operation = $true

    while ($operation) {
        Write-Host $Prompt | Out-String
        $choice = Read-Host 

        if ($choice -eq 1) {
            readConfiguration
        } elseif ($choice -eq 2) {
            changeConfiguration
        } elseif ($choice -eq 3) {
            Write-Host "Goodbye" | Out-String
            $operation = $false 
        } else {
            Write-Host "Please choose a valid option 1-3"
        }
    }
}
