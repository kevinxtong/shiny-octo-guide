#Declare variables
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logFile = "$env:temp\AD-reformat-userNames.log"
$ADDomainName = "example.local"
$o365TenantName = "exampleorganization"
$ou = "OU=exampleOUname,DC=example,DC=local"

# Get all users in the target OU
$users = Get-ADUser -Filter * -SearchBase $ou
# Loop through each user
foreach ($user in $users) {
    # Store the current username
    $oldSamAccountname = $user.SamAccountName
    $oldUPN = $user.UserPrincipalName

    # Get the first and last name of the user
    $firstName = $user.GivenName
    $lastName = $user.Surname

    # Construct the new UPN, SamAccountName, and Email
    $newUPN = $firstName + "." + $lastName + "@$ADDomainName"
    $newSamAccountName = $firstName + "."  + $lastName
    #$newSamAccountName = $newSamAccountName -replace '[^A-Za-z0-9]',''
    $newEmail = $newUPN
    # SamAccountName length limit 20
    if ($newSamAccountName.Length -gt 20) {
    $newSamAccountName = $newSamAccountName.Substring(0,20)
}

    # Construct the new proxy addresses
    $newProxyAddress = "smtp:" + $firstName + "." + $lastName + "@$o365TenantName.mail.onmicrosoft.com"
    $newLocalAddress = "SMTP:" + $firstName + "." + $lastName + "@$ADDomainName"
    $proxyAddresses = $user.proxyAddresses + $newProxyAddress + $newLocalAddress

    # Check if the user is already updated
    if ($oldSamAccountname -eq $newSamAccountName) {
        # Log a message indicating that the user is already updated
        $logMessage = "$timestamp - User $oldSamAccountname is already updated, skipping"
        Add-Content -Path $logFile -Value $logMessage
        continue
    } else {
        try {
            # Update the user's attributes with the new values
            Set-ADUser -Identity $user -UserPrincipalName $newUPN -SamAccountName $newSamAccountName -EmailAddress $newEmail -Add @{proxyAddresses=$proxyAddresses}
            # Log a message indicating the update was successful
            $logMessage = "$timestamp - SamAccountName: $oldSamAccountname = $newSamAccountName, UserPrincipalName: $oldUPN = $newUPN"
            Add-Content -Path $logFile -Value $logMessage
        } catch {
            # Log the error message generated by the Set-ADUser command
            $errorMessage = $Error[0].Exception.Message
            Add-Content -Path $logFile -Value "$timestamp - $oldSamAccountname - $errorMessage"
        }
    }
}

Start-Process -FilePath explorer.exe -ArgumentList "$env:temp"
Start-Process -FilePath notepad.exe -ArgumentList "$env:temp\AD-reformat-userNames.log"
