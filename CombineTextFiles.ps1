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
        if (Test-Path $line) {
            if ((Get-Item $line).PSIsContainer) {
                $excludedDirs += $line
            } else {
                $excludedFiles += $line
            }
        }
    }
}

# Get all files in the selected directory (including subdirectories)
$files = Get-ChildItem -Path $directory -File -Recurse

foreach ($file in $files) {
    # Check if the file is in the excluded files list
    if ($excludedFiles -contains $file.FullName) {
        Write-Host "Skipping excluded file: $($file.FullName)"
        continue
    }

    # Check if the file is in a directory that's excluded
    $excludeDirMatch = $false
    foreach ($excludeDir in $excludedDirs) {
        if ($file.FullName -like "$excludeDir\*") {
            $excludeDirMatch = $true
            Write-Host "Skipping file in excluded directory: $($file.FullName)"
            break
        }
    }

    if ($excludeDirMatch) { continue }

    # Resolve the file path
    $resolvedPath = Resolve-Path $file.FullName -ErrorAction SilentlyContinue
    if ($resolvedPath) {
        # Read the content of the file, preserving line breaks (CRLF)
        $fileContent = Get-Content -Path $resolvedPath -Raw
        # Append file path and content to combined content with proper CRLF
        $combinedContent += "`r`n[$resolvedPath]:`r`n$fileContent`r`n`r`n"
    } else {
        $combinedContent += "`r`n[$file]: File not found`r`n`r`n"
    }
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

# Print how files, lines, tokens are copied
Write-Host "Combined content from $($files.Count) files copied to clipboard with $($combinedContent.Split("`n").Count) lines and $($combinedContent.Split(" ").Count) tokens. Have a nice day :D"
