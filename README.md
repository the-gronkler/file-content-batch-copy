# file-content-batch-copy

(Windows) Add a context menu command to directories, which will copy the content of all files in this directory to clipboard, and to a .txt file on your Desktop ;) \
Copies the content of text files, regardless of extension

Useful for working on a large codebase with ai chat assistance (copilot is really bad at writing good code, unlike chatGPT or Gemini). With this tool you will be able to send a file containing all the relevant parts of the codebase quickly and easily, without having to open a bunch of files and copy them one by one, or searching for all the files you want to send in countless subdirectories.

**Usage:**
Select a directory, right click to open context menu, and click on 'Combine Text Files' \(on windows 11 you might have to press 'Show More Options' first)

**Setup:**
1. Download CombineTextFiles.ps1 - this is the script, and place it in "C:\Scripts\" folder
2. Download CombineTextFiles.reg and run it - this is the registry entry, once you run it, it will add a command to run the script to the context menu for directories. It will warn you not to run the file if you do not trust the source, and ask if you want to continue: Press Yes.
   
If you want to exclude some files, create a file called 'exclude.txt', and place it in the directory where you are running the script (not subdirectory!!) The path should be absolute, and it can be in "double quotes". You can select the files/directories you want to exclude in explorer, right click and select 'Copy as Path'. Then you can just paste it into exclude.txt

**Example:**

exclude.txt:\
C:\Users\thegronkler\OneDrive\Desktop\test\3.txt\
"C:\Users\thegronkler\OneDrive\Desktop\test\exclude.txt"\
"C:\Users\thegronkler\OneDrive\Desktop\test\stuff"

