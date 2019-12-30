# Force UAC
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Path where all the files should be Archived to
$path = "$env:USERPROFILE\Documents\_Archive"

# Start Transcript
Write-Host ""
Start-Transcript -path "$path\trans.txt" -Append
Write-Host ""
Write-Host ""

# Get Date
$CDT = Get-Date
$CDT = $CDT.ToString('yyyy-MM-dd HH.mm.ss')

# Create Folders to move files into
$confirmfolder = Test-Path -PathType Container "$Path\_Other"
    if ($confirmfolder -ne $true){New-Item "$Path\_Other" -ItemType Directory -Force -EA SilentlyContinue}

### Extension List ###
# List of extension that will be moved into folders based on the extension
$extlist = "*.ps1","*.txt","*.pdf","*.docx","*.doc","*.xlsx","*.xls","*.png","*.jpg","*.csv","*.exe","*.msi","*.zip","*.rar","*.tar","*.log","*.cfg","*.iso","*.rdp","*.mp4","*.mp3","*.wav","*.msg","*.cer","*.deb","*.bat","*.pfx","*.img","*.ini","*.xlsm","*.pptx","*.msu","*.tbxml","*.pcapn","*.drawio"

### Exclude List ###
# List of files, folders and shortcuts that will not be moved into the archived folders
$exclude = "AutoSort.ps1","NetAdapter_v1.ps1","PS WorkShop","LPCMID002.ink","PS Online.ps1","PSW","Scripting","YD-v1","Telkom LTE","AutoSort-P.ps1","IPBH"

# Create folders based on extension list & Move files from Desktop & Downloads
foreach($ext in $extlist)
    {
        # Remove '*.'
        $folder = $ext.TrimStart("*.")
        $folder = $folder.ToUpper()

        # Create Folders
        $confirmfolder = Test-Path -PathType Container "$Path\$folder" -Verbose
            if ($confirmfolder -ne $true){New-Item "$Path\$folder" -ItemType Directory -Force -EA SilentlyContinue -Verbose}

        # Get the file
        $pDown = "$env:USERPROFILE\Downloads\$ext"
        $pDesk = "$env:USERPROFILE\Desktop\$ext"

        # Folder location where file will be moved to
        $Archive = "$Path\$folder"

        # Move file
        Move-Item -Path $pDown -Destination $Archive -Exclude $exclude -Force -Verbose -EA SilentlyContinue
        Move-Item -Path $pDesk -Destination $Archive -Exclude $exclude -Force -Verbose -EA SilentlyContinue

            }

# Move all unspesified files & folders into one folder
Move-Item -Path "$env:USERPROFILE\Downloads\*" -Destination "$Path\_Other" -Exclude $exclude -Force -Verbose -EA SilentlyContinue
Move-Item -Path "$env:USERPROFILE\Desktop\*" -Destination "$Path\_Other" -Exclude $exclude -Force -Verbose -EA SilentlyContinue

# Stop Transcript
Write-Host ""
Write-Host ""
Stop-Transcript
Write-Host ""
Write-Host ""
Write-Host ""
pause
exit
