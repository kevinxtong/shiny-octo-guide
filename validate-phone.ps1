while ($true) {
    $phoneNumber = Read-Host "Enter phone number"
    #Remove any non-numeric characters
    $phoneNumber = $phoneNumber -replace '[^\d]'
    # Check if the phone number is in the correct format
    if ($phoneNumber -match '^(?:\+1)?(?:\d{10}|\d{11})$') {
        Write-Host "Valid phone number: $phoneNumber"
    } else {
        Write-Host "Invalid phone number: $phoneNumber"
    }
}
