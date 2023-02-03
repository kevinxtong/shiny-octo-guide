
$ProgressPreference = 'SilentlyContinue'
$cdnAzul = "https://cdn.azul.com/zulu/bin"
$html = Invoke-WebRequest -UseBasicParsing -Uri $cdnAzul
# Get latest x64 jre .msi
$ZuluFileName = ($html.Links | Select-Object -ExpandProperty Href) -replace '^.href="|".$', '' | Where-Object { $_.EndsWith(".msi") -and $_ -match "^zulu\d{2}.*ca-jre.*x64" } | Select-Object -Last 1
$ZuluUrl = "$cdnAzul/$ZuluFileName"

# Download and install Azul Zulu JRE
$ZuluOutFile = ".\$ZuluFileName"
Invoke-WebRequest -Uri $ZuluUrl -OutFile $ZuluOutFile
Start-Process msiexec.exe -Wait -Verb RunAs -ArgumentList '/qn /i', (Resolve-Path -Path $ZuluOutFile).Path, 'ADDLOCAL=ZuluInstallation,FeatureEnvironment,FeatureOracleJavaSoft,FeatureJavaHome'

# Get DataLoader URL and file name
$ProgressPreference = 'SilentlyContinue'
$DataLoaderUrl = ((Invoke-WebRequest -UseBasicParsing -Uri  "https://developer.salesforce.com/tools/data-loader").Links.Href | Select-String -Pattern 'dataloader_win_.+\.zip').ToString()

# Download, extract, install
mkdir c:\temp
Invoke-WebRequest -Uri $DataLoaderUrl -OutFile "C:\temp\dataloader.zip"
Expand-Archive -Path "C:\temp\dataloader.zip" -DestinationPath "C:\temp\dataloader" -Force
Start-Process -Wait cmd.exe -ArgumentList '/c', 'C:\temp\dataloader\install.bat'
Remove-Item c:\temp -Recurse
