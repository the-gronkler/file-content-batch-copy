# file-content-batch-copy

(Windows) Add a context menu command to directories, which will copiy the content of all files in this directory to clipboard ;) \
Copies the content of text files, regardless of extension

Usage:
1. Download CombineTextFiles.ps1 - this is the script, and place it in "C:\Scripts\" folder
2. Download CombineTextFiles.reg - this is the registry entry, will add a command to run the script to the context menu for directories,
3. Open command prompt (press 'Win + R', type 'cmd' and press 'Ok'), navigate to the directory with the 'CombineTextFiles.reg' file ('cd path\to\files'), and run command 'reg import "CombineTextFiles.reg"'
4. Done :)
