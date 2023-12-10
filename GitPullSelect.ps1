# Function to run git pull in a selected directory
function RunGitPull {
    param (
        [string]$directory
    )

    Set-Location -Path $directory
    Write-Host "Updating $directory..."
    Invoke-Expression "git pull"
    Set-Location -Path $rootDirectory
    Write-Host "Completed pulling repository in $directory."
}

# Get the current directory
$rootDirectory = Get-Location

# Infinite loop to keep the script running
while ($true) {
    # Get all root directories and sort them alphabetically
    $subDirectories = Get-ChildItem -Directory | Sort-Object Name

    # Display directories with numbers
    for ($i = 0; $i -lt $subDirectories.Count; $i++) {
        Write-Host "$($i+1): $($subDirectories[$i].Name)"
    }

    # Ask for user input
    $selection = Read-Host "Enter the number of the directory to update (or 'exit' to quit)"
    if ($selection -eq 'exit') {
        break
    }

    $selectedIndex = $selection - 1
    if ($selectedIndex -ge 0 -and $selectedIndex -lt $subDirectories.Count) {
        $selectedDirectory = $subDirectories[$selectedIndex].FullName

        # Confirm with user
        $confirmation = Read-Host "Are you sure you want to run git pull in '$($subDirectories[$selectedIndex].Name)'? (Y/N)"
        if ($confirmation -eq '' -or $confirmation.ToLower() -eq 'y') {
            RunGitPull -directory $selectedDirectory
        }
    }
    else {
        Write-Host "Invalid selection. Please try again."
    }
}
