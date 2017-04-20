# Deletes crap temp files, created by ChromeDriver
$sTemp = "scoped_dir" # file mask
$sTimeout = 1         # minutes to allow temp files to live before delete
$sEverySeconds = 60   # run every


function Get-TimeStamp {
    $timeStamp = "[" + (Get-Date).ToShortDateString() + " " + ((Get-Date).ToShortTimeString()) + "]"
    Return $timeStamp
}

for(;;) {
 try {
    Write-Host "$(Get-TimeStamp) Checking temp files with name $sTemp older then $sTimeout minutes"
    Get-ChildItem $env:temp/ |
    # file name template
    Where {$_.name -Match $sTemp} |
    # older then $sTimeout
    Where-Object {$_.CreationTime -lt (date).addminutes(-$sTimeout)} | 
    # Delete
    # Remove-Item -Force -Recurse 
    % { 
      ForEach-Object { 
        Write-Host "Deleting: $_" 
        Remove-Item -Force -Recurse $_.fullname
      }       
    }
 } catch [Exception] {
    Write-Host "$(Get-TimeStamp) Some exception on deleting files"
 }
 # wait for a minute
 Write-Host "$(Get-TimeStamp) Sleeping for $sEverySeconds seconds"
 Start-Sleep $sEverySeconds
}