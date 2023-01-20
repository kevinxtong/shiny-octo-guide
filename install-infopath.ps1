try {
    # Create a new directory in C:\temp\infopath2013-install
    New-Item -ItemType directory -Path C:\temp\infopath2013-install

    # Suppress progress output
    $ProgressPreference = 'SilentlyContinue'

    # Download infopath_4753-1001_x64_en-us.exe from specified URL and save to new directory
    $fileUrl = 'https://download.microsoft.com/download/1/C/5/1C5F47E1-48B4-4877-A4A3-B794B01323A6/infopath_4753-1001_x64_en-us.exe'
    $filePath = 'C:\temp\infopath2013-install\infopath_4753-1001_x64_en-us.exe'
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($fileUrl, $filePath)

    # Check if the file has been downloaded successfully 
    if(!(Test-Path $filePath)){
        throw "File download failed, please check your internet connection and try again"
    }

    # Re-enable progress output
    $ProgressPreference = 'Continue'

    # Extract contents of the .exe file to the new directory
    Start-Process -Wait -FilePath $filePath -ArgumentList "/Extract:C:\temp\infopath2013-install /quiet"

    # Create XML configuration file
    $configXml = 'C:\temp\infopath2013-install\infopath2013-config.xml'
    Add-Content -Value '<Configuration Product="InfoPathr">
    <Display Level="none" CompletionNotice="No" SuppressModal="Yes" AcceptEula="Yes" />
    <Setting Id="SETUP_REBOOT" Value="NEVER" />
    <Setting Id="REBOOT" Value="ReallySuppress"/>
    <Setting Id="AUTO_ACTIVATE" Value="1" />
    </Configuration>' -Path $configXml

    # Check if the current user has administrative rights
    if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){
        throw "Please run the script as an administrator"
    }

    # Run setup.exe with the created XML configuration file
    $setupPath = 'C:\temp\infopath2013-install\setup.exe'
    Start-Process -Wait -FilePath $setupPath -ArgumentList "/config $configXml"

    # Remove the entire infopath2013-install directory
    Remove-Item -Path C:\temp\infopath2013-install\ -Force -Recurse
} catch {
    Write-Error $_.Exception
}
