# Get the current directory
$rootDirectory = Get-Location

# Get all subdirectories in the current directory
$subDirectories = Get-ChildItem -Directory

# Loop through each subdirectory and run 'git pull'
$subDirectories | ForEach-Object {
    # Change to the subdirectory
    Set-Location -Path $_.FullName
    
    # Display the name of the subdirectory being updated
    Write-Host "Updating $_.Name..."
    
    # Run 'git pull'
    Invoke-Expression "git pull"
    
    # Change back to the root directory
    Set-Location -Path $rootDirectory
}

# Indicate completion
Write-Host "Completed pulling all repositories."

