$Url = "https://download.videolan.org/pub/videolan/vlc/last/win64/"

$LatestFile = (Invoke-WebRequest -Uri $Url -UseBasicParsing).Links | ? { $_.href -match "\.msi$"} | Select-Object -First 1

$FileName = ($LatestFile.href)
$DownloadLink = "$Url$($FileName)"

$OutFile = $LatestFile.href
if (!(Test-Path $OutFile)) {
$URI = "$Url$($FileName)"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $URI -OutFile $OutFile
}

Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $FileName /qn" -Wait

Remove-Item "$env:Public\Desktop\VLC media player.lnk"
