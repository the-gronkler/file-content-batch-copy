param (
    [string]$directory
)

# Check if the directory exists
if (-not (Test-Path $directory)) {
    Write-Host "Directory does not exist."
    exit
}

# Set output directory and filename with current date and time
$outputDir = "$env:USERPROFILE\Desktop\CombinedFiles"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$outputFile = "$outputDir\CombinedFiles_$timestamp.txt"

# Create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Initialize an empty string to store the combined content
$combinedContent = ""

# Get all files in the selected directory (including subdirectories if desired)
$files = Get-ChildItem -Path $directory -File

foreach ($file in $files) {
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

# Save the combined content to a file
$combinedContent | Set-Content -Path $outputFile -Force

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

# say how files, lines, tokens are copied
Write-Host "Combined content from $($files.Count) files copied to clipboard with $($combinedContent.Split("`n").Count) lines and $($combinedContent.Split(" ").Count) tokens. Have a nice day :D"
