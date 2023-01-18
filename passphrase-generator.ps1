$filePath = "./AgileWords.txt"
if (!(Test-Path -Path $filePath)) {
    Invoke-WebRequest "https://raw.githubusercontent.com/agilebits/crackme/master/doc/AgileWords.txt" -OutFile $filePath
}

$wordList = Get-Content -Path $filePath
$words = $wordList.Split("`n")
$wordCount = $words.Count

$randomIndex1 = Get-Random -Minimum 0 -Maximum ($wordCount-1)
$randomIndex2 = Get-Random -Minimum 0 -Maximum ($wordCount-1)
$randomIndexNum = Get-Random -Minimum 0 -Maximum 2

$word1 = $words[$randomIndex1].Substring(0,1).ToUpper() + $words[$randomIndex1].Substring(1)
$word2 = $words[$randomIndex2].Substring(0,1).ToUpper() + $words[$randomIndex2].Substring(1)

$randomNum = Get-Random -Minimum 0 -Maximum 9

switch ($randomIndexNum)
{
    0 {$word1 += $randomNum}
    1 {$word2 += $randomNum}
}

$passphrase = $word1 + "-" + $word2
Write-Output $passphrase
