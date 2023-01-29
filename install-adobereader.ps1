# Check latest version of Reader for Windows
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$result = Invoke-RestMethod -Uri "https://rdc.adobe.io/reader/products?lang=mui&site=enterprise&os=Windows%2011&country=US&nativeOs=Windows%2010&api_key=dc-get-adobereader-cdn"
$version = $result.products.reader[0].version
$version = $version.replace('.','')

# Check if the file is already downloaded
$OutFile = ".\AcroRdrDCx64$($version)_MUI.exe"
if (!(Test-Path $OutFile)) {
$URI = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/$Version/AcroRdrDCx64$($Version)_MUI.exe"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $URI -OutFile $OutFile
}

Start-Process -FilePath $OutFile -ArgumentList "/sAll /rs /msi EULA_ACCEPT=YES" -Wait