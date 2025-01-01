# file-content-batch-copy

(Windows) Add a context menu command to directories, which will copy the content of all files in this directory to clipboard ;) \
Copies the content of text files, regardless of extension

**Usage:**
1. Download CombineTextFiles.ps1 - this is the script, and place it in "C:\Scripts\" folder
2. Download CombineTextFiles.reg and run it - this is the registry entry, will add a command to run the script to the context menu for directories. It will warn you not to run the file if you do not trust the source, and ask if you want to continue: Press Yes.
4. Select a directory, right click to open context meny, and click on 'Combine Text Files' (on windows 11 you might have to press 'Show More Options')

If you want to exclude some files, create a file called 'exclude.txt', and place it in the directory where you are running the script (not subdirectory!!) The path should be absolute, and it can be in "double quotes". You can select the files/directories you want to exclude in explorer, right click and select 'Copy as Path'. Then you can just paste it into exclude.txt

**Example:**

exclude.txt:\
C:\Users\thegronkler\OneDrive\Desktop\test\3.txt\
"C:\Users\thegronkler\OneDrive\Desktop\test\exclude.txt"\
"C:\Users\thegronkler\OneDrive\Desktop\test\stuff"

