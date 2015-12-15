$enddate = (Get-Date).tostring("dd.MM.yyyy")
$baseDir = "C:\PerfLogs\"
$bakFile = "C:\Backup\Backup_$enddate.zip"
$TodayDate=(Get-Date).ToString("yyyy-MM-dd")
$tempFile = [io.path]::GetTempFileName()

# Create zip Backup
7z.exe a -bd -y -tzip $bakFile $baseDir

# Upload file to GDrive
drive.exe upload --file $bakFile

# Get filelist from GDrive and save to file
drive list > $tempFile
$file = Get-Content $tempFile
$text = $file | select -Skip 1 

#Parsing filelist and delete old files from GDrive
foreach ( $char in $text ) { 
    $char -match '\d{4}-\d{2}-\d{2}'
    $dline = $matches.Values
    $idline = $char.Substring(0,28)
    $fdate = [datetime]::ParseExact($dline, "yyyy-MM-dd", $null)
        if ((Get-Date $TodayDate) -gt (Get-Date $fdate)) {
            drive.exe delete -i $idline
            } 
    }

#Delete temp backup file
Remove-Item $bakFile