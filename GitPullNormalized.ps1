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

# Function to normalize directory names
function NormalizeDirectoryName {
    param (
        [string]$name
    )

    $name = $name -replace "_", ""
    $name = $name -replace "-", ""
    $name = $name -replace "comfyui", ""
    return $name
}

# Function to display directories and handle user selection
function DisplayDirectoriesAndHandleSelection {
    param (
        [array]$directories,
        [bool]$normalize
    )

    for ($i = 0; $i -lt $directories.Count; $i++) {
        $displayName = $directories[$i].Name
        if ($normalize) {
            $displayName = NormalizeDirectoryName $displayName
        }
        Write-Host "$($i+1): $displayName"
    }

    Write-Host ""  # Line break for better readability
    $selection = Read-Host "Enter the number of the directory to update, a search term, or 'exit' to quit"

    if ($selection -eq 'exit') {
        return "exit"
    }

    if ($selection -match "^\d+$") {
        $selectedIndex = $selection - 1
        if ($selectedIndex -ge 0 -and $selectedIndex -lt $directories.Count) {
            return $directories[$selectedIndex].FullName
        } else {
            Write-Host "`nInvalid selection. Please try again.`n"
            return $null
        }
    } else {
        # Handle as search term
        return "search:$selection"
    }
}

# Get the current directory
$rootDirectory = Get-Location

# Prompt user to choose normalization
$normalize = Read-Host "`nDo you want to normalize directory names by removing '_', '-', and 'comfyui'? (Y/N) [Default: Y]"
if ($normalize -eq '' -or $normalize.ToLower() -eq 'y') {
    $normalize = $true
} else {
    $normalize = $false
}

# Infinite loop to keep the script running
while ($true) {
    # Get all root directories and sort them alphabetically
    $subDirectories = Get-ChildItem -Directory | Sort-Object Name

    $result = DisplayDirectoriesAndHandleSelection -directories $subDirectories -normalize $normalize

    if ($result -eq "exit") {
        break
    } elseif ($result -eq $null) {
        continue
    } elseif ($result.StartsWith("search:")) {
        $searchTerm = $result.Substring(7)
        $filteredDirectories = $subDirectories | Where-Object { $_.Name -like "*$searchTerm*" }
        if ($filteredDirectories.Count -eq 0) {
            Write-Host "`nNo directories found with the term '$searchTerm'.`n"
        } else {
            Write-Host "`nDirectories matching '$searchTerm':`n"
            $selectedDirectory = DisplayDirectoriesAndHandleSelection -directories $filteredDirectories -normalize $normalize
            if ($selectedDirectory -eq "exit") {
                break
            } elseif ($selectedDirectory -ne $null) {
                # Confirm with user
                $confirmation = Read-Host "`nAre you sure you want to run git pull in '$(Split-Path -Leaf $selectedDirectory)'? (Y/N) [Default: Y]`n"
                if ($confirmation -eq '' -or $confirmation.ToLower() -eq 'y') {
                    RunGitPull -directory $selectedDirectory
                }
            }
        }
    } else {
        # Confirm with user
        $confirmation = Read-Host "`nAre you sure you want to run git pull in '$(Split-Path -Leaf $result)'? (Y/N) [Default: Y]`n"
        if ($confirmation -eq '' -or $confirmation.ToLower() -eq 'y') {
            RunGitPull -directory $result
        }
    }
}
