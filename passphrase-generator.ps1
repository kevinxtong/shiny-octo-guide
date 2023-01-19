function New-Passphrase {
param(
    [Parameter(Mandatory=$false)]
    [ValidateScript({ if ($_ -lt 2) { throw "WordCount must be at least 2" } return $true })]
    [int]$WordCount = 2,
    [switch]$NoNumber 
)
    $filePath = "./AgileWords.txt"
    if (!(Test-Path -Path $filePath)) {
        Invoke-WebRequest "https://raw.githubusercontent.com/agilebits/crackme/master/doc/AgileWords.txt" -OutFile $filePath
    }

    $words = Get-Content $filePath
    $randomWords = $words | Get-Random -Count $WordCount
    $randomWords = $randomWords | ForEach-Object { [System.Globalization.CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_) }
    if (!$NoNumber) {
        $randomWord = $randomWords | Get-Random
        $randomNumber = (Get-Random -Minimum 0 -Maximum 99).ToString().PadLeft(2, "0")
        $randomNumberPosition = Get-Random -Minimum 0 -Maximum 1
        if($randomNumberPosition){
            $randomWords[$randomWords.IndexOf($randomWord)] = "$randomWord$randomNumber"
        }else{
            $randomWords[$randomWords.IndexOf($randomWord)] = "$randomNumber$randomWord"
        }
    }
    $passphrase = $randomWords -join "-"
    if($passphrase.Length -lt 15){
        $passphrase = New-Passphrase
    }
    $passphrase
}
