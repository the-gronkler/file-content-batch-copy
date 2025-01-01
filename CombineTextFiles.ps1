param (
    [string]$directory
)

# Check if the directory exists
if (-not (Test-Path $directory)) {
    Write-Host "Directory does not exist."
    exit
}

# Initialize an empty string to store the combined content
$combinedContent = ""

# Define path for the exclude file (you can change the name if needed)
$excludeFilePath = Join-Path -Path $directory -ChildPath "exclude.txt"

# Initialize arrays to store excluded files and directories
$excludedFiles = @()
$excludedDirs = @()

# Check if the exclude file exists, and read its contents if it does
if (Test-Path $excludeFilePath) {
    Write-Host "Exclude file found, reading excluded files and directories..."
    $excludeLines = Get-Content -Path $excludeFilePath
    foreach ($line in $excludeLines) {
        # Trim leading and trailing spaces, and remove quotes around paths
        $line = $line.Trim().Trim('"')

        # Skip empty lines
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            if (Test-Path $line) {
                if ((Get-Item $line).PSIsContainer) {
                    $excludedDirs += $line
                } else {
                    $excludedFiles += $line
                }
            } else {
                Write-Host "Warning: Exclude path does not exist: $line"
            }
        }
    }
}

# Get all files in the selected directory (including subdirectories), but exclude files in excluded directories
$allFiles = Get-ChildItem -Path $directory -File -Recurse
$filteredFiles = $allFiles | Where-Object {
    # Skip files in excluded directories
    $inExcludedDir = $false
    foreach ($excludeDir in $excludedDirs) {
        if ($_.FullName.StartsWith($excludeDir)) {
            $inExcludedDir = $true
            break
        }
    }
    # Return the file if it's not in an excluded directory and it's not an excluded file
    -not $inExcludedDir -and (-not ($excludedFiles -contains $_.FullName))
}

$filesProcessed = 0

# Iterate over the filtered list of files
foreach ($file in $filteredFiles) {
    # Resolve the file path
    $resolvedPath = Resolve-Path $file.FullName -ErrorAction SilentlyContinue
    if ($resolvedPath) {
        # Read the content of the file, preserving line breaks (CRLF)
        $fileContent = Get-Content -Path $resolvedPath -Raw
        # Append file path and content to combined content with proper CRLF
        $combinedContent += "`r`n[$resolvedPath]:`r`n$fileContent`r`n`r`n"
        
        # Print each copied file
        Write-Host "Copied file: $resolvedPath"
        $filesProcessed++
    } else {
        $combinedContent += "`r`n[$file]: File not found`r`n`r`n"
    }
}

# Save the combined content to a file on the Desktop
$desktopPath = [environment]::GetFolderPath("Desktop")
$directoryName = Split-Path -Path $directory -Leaf
$outputFilePath = Join-Path -Path $desktopPath -ChildPath "${directoryName}_combined.txt"

try {
    Set-Content -Path $outputFilePath -Value $combinedContent -Force
    Write-Host "Combined content saved to file: $outputFilePath"
}
catch {
    Write-Host "Failed to save the combined content to file: $outputFilePath"
}

# Double-check that the combined content is valid and fully captured
if ($combinedContent.Length -gt 0) {
    try {
        # Use Add-Type to reference clipboard for direct Windows API call
        Add-Type -AssemblyName PresentationCore
        [Windows.Clipboard]::SetText($combinedContent)
        
        Write-Host "Combined text copied to clipboard."
    }
    catch {
        Write-Host "Failed to copy to clipboard."
        Add-Type -AssemblyName PresentationFramework
        [System.Windows.MessageBox]::Show("An error occurred while copying to the clipboard.", "Clipboard Copy Error")
    }
} else {
    # If content is empty, notify the user
    Write-Host "No content to copy to clipboard."
}

$combinedContentSizeInBytes = [System.Text.Encoding]::UTF8.GetByteCount($combinedContent)
$combinedContentSizeInMB = [math]::Round($combinedContentSizeInBytes / 1MB, 2)

# Print how many files were processed and the details of combined content
Write-Host "Processed $filesProcessed files. 
Combined content copied to clipboard and saved to file '${directoryName}_combined.txt' on your Desktop.
with $($combinedContent.Split("`n").Count) lines, 
$($combinedContent.Split(" ").Count) tokens, 
and weighing $combinedContentSizeInMB MB.
Have a nice day! :D"
