Function New-Passphrase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateScript({ if ($_ -lt 2) { throw "WordCount must be at least 2" } return $true })]
        [int]$WordCount = 2,
        [switch]$NoNumber,
        [switch]$NoCapitalization,
        [string]$Separator = "-"
    )

    # Download word list file if it doesn't exist
    $wordListFilePath = "$env:temp/AgileWords.txt"
    if (!(Test-Path -Path $wordListFilePath)) {
        Invoke-WebRequest "https://raw.githubusercontent.com/agilebits/crackme/master/doc/AgileWords.txt" -OutFile $wordListFilePath
    }

    # Get words from the file
    $words = Get-Content $wordListFilePath

    # Select random words
    $selectedWords = $words | Get-Random -Count $WordCount

    # Capitalize selected words if capitalization is not disabled
    if (!$NoCapitalization) {
        $selectedWords = $selectedWords | ForEach-Object { [System.Globalization.CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_) }
    }

    if (!$NoNumber) {
        $selectedIndexes = @()
        while ($selectedIndexes.Count -lt $selectedWords.Count) {
            $randomIndex = (Get-Random -Minimum 0 -Maximum $selectedWords.Count)
            if (!($selectedIndexes -contains $randomIndex)) {
                $selectedIndexes += $randomIndex
            }
        }

        # Select a random word and add the random number
        $randomIndex = $selectedIndexes | Get-Random
        $randomWord = $selectedWords[$randomIndex]
        $randomNumber = (Get-Random -Minimum 0 -Maximum 9).ToString()
        $randomNumberPosition = Get-Random -Minimum 0 -Maximum 2

        if ($randomNumberPosition -eq 0) { 
            $selectedWords[$randomIndex] = "$randomNumber$randomWord" 
        }
        elseif ($randomNumberPosition -eq 1) { 
            $selectedWords[$randomIndex] = "$randomWord$randomNumber" 
        }
    }

    # Join the selected words

    $passphrase = $selectedWords -join $separator

    $passphrase
}
 New-Passphrase
