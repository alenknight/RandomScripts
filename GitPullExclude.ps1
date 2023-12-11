# Function to run git pull in a selected directory
function RunGitPull {
    param (
        [string]$directory
    )

    Set-Location -Path $directory
    Write-Host "`nUpdating $directory..."
    Invoke-Expression "git pull"
    Set-Location -Path $rootDirectory
    Write-Host "Completed pulling repository in $directory.`n"
}

# Function to display directories and handle user selection
function DisplayDirectoriesAndHandleSelection {
    param (
        [array]$directories
    )

    for ($i = 0; $i -lt $directories.Count; $i++) {
        Write-Host "$($i+1): $($directories[$i].Name)"
    }

    Write-Host ""  # Line break for better readability
    $selection = Read-Host "Enter the numbers of directories to exclude from 'git pull' separated by commas, a search term, or 'done' to finish"

    if ($selection -eq 'done') {
        return , "done"
    }

    $selections = $selection -split ',' | ForEach-Object { $_.Trim() }
    $selectedIndexes = @()
    foreach ($sel in $selections) {
        if ($sel -match "^\d+$") {
            $selectedIndex = [int]$sel - 1
            if ($selectedIndex -ge 0 -and $selectedIndex -lt $directories.Count) {
                $selectedIndexes += $directories[$selectedIndex].FullName
            } else {
                Write-Host "`nInvalid selection '$sel'. Please try again.`n"
            }
        } else {
            Write-Host "`nInvalid selection. Please enter only numbers separated by commas.`n"
            return , $null
        }
    }

    return , $selectedIndexes
}

# Get the current directory
$rootDirectory = Get-Location

# Get all subdirectories in the current directory
$subDirectories = Get-ChildItem -Directory | Sort-Object Name

# Create an empty list to store excluded directories
$excludedDirectories = @()

# Infinite loop to keep the script running
while ($true) {
    $result = DisplayDirectoriesAndHandleSelection -directories $subDirectories

    if ($result -contains "done") {
        break
    } elseif ($result -contains $null) {
        continue
    } else {
        $excludedDirectories += $result
        # Display current excluded directories
        Write-Host "`nCurrently excluded directories:"
        $excludedDirectories | ForEach-Object { Write-Host $_ }
        Write-Host ""
    }
}

# Show final list of excluded directories and ask for confirmation
Write-Host "`nFinal list of Excluded Directories:"
$excludedDirectories | ForEach-Object { Write-Host $_ }
$confirmation = Read-Host "Press Enter to confirm and proceed with 'git pull' on remaining directories, or type 'cancel' to abort"
if ($confirmation -eq 'cancel') {
    Write-Host "Operation cancelled. Exiting script."
    return
}

# Loop through each subdirectory and run 'git pull' if not in the excluded list
foreach ($subDirectory in $subDirectories) {
    if ($excludedDirectories -notcontains $subDirectory.FullName) {
        # Change to the subdirectory
        Set-Location -Path $subDirectory.FullName
        
        # Display the name of the subdirectory being updated
        Write-Host "Updating $($subDirectory.Name)..."
        
        # Run 'git pull'
        Invoke-Expression "git pull"
        
        # Change back to the root directory
        Set-Location -Path $rootDirectory
    }
}

# Indicate completion
Write-Host "Completed pulling all repositories (excluding selected ones)."
