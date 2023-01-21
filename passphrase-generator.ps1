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

    $wordListFilePath = "./AgileWords.txt"

    if (!(Test-Path -Path $wordListFilePath)) {
        Invoke-WebRequest "https://raw.githubusercontent.com/agilebits/crackme/master/doc/AgileWords.txt" -OutFile $wordListFilePath
    }

    $words = Get-Content $wordListFilePath

    # Select random words
    $randomWords = $words | Get-Random -Count $WordCount

    if (!$NoCapitalization) {
        $randomWords = $randomWords | ForEach-Object { [System.Globalization.CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($_) }
    }

    # Add random number if not disabled
    if (!$NoNumber) {
        # Select random word from list
        $randomWord = $randomWords | Get-Random
        $randomIndex = 0
        $flag = $false
        $randomWords | ForEach-Object -Process {
            if ($_ -eq $randomWord -and !$flag) {
                $randomIndex = $randomWords.IndexOf($_)
                $flag = $true
            }
        }
        $randomNumber = (Get-Random -Minimum 0 -Maximum 9).ToString()
        # Select random position for number
        $randomNumberPosition = Get-Random -Minimum 0 -Maximum 2

        # Append or prepend number to word
        if($randomNumberPosition -eq 0){
            $randomWords[$randomIndex] = "$randomNumber$randomWord"
        }
        elseif($randomNumberPosition -eq 1){
            $randomWords[$randomIndex] = "$randomWord$randomNumber"
        }
    }


    $passphrase = $randomWords -join $separator

    if($passphrase.Length -lt 15){

        $passphrase = New-Passphrase
    }

    $passphrase
}

function Show-PassPhraseForm
{
Add-Type -AssemblyName System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$form.TopMost = $true
$form.Text = "PassphraseGen"
$form.Width = 350
$form.Height = 150
$form.StartPosition = "CenterScreen"

# Passphrase input box
$passphraseBox1 = New-Object System.Windows.Forms.TextBox
$passphraseBox1.Width = 300
$passphraseBox1.Height = 20
$passphraseBox1.Font = New-Object System.Drawing.Font("Consolas", 13.5)
$passphraseBox1.Text = (New-PassPhrase)
$passphraseBox1.Dock = [System.Windows.Forms.DockStyle]::Fill

# Copy to clipboard button for passphraseBox1
$copyButton1 = New-Object System.Windows.Forms.Button
$copyButton1.Width = 75
$copyButton1.Height = 25
$copyButton1.Text = "Copy"
$copyButton1.Dock = [System.Windows.Forms.DockStyle]::Bottom
$copyButton1.Add_Click({
    [System.Windows.Forms.Clipboard]::SetText($passphraseBox1.Text)
})

# Regenerate passphrase button
$generateButton = New-Object System.Windows.Forms.Button
$generateButton.Width = 75
$generateButton.Height = 25
$generateButton.Text = "Regenerate"
$generateButton.Dock = [System.Windows.Forms.DockStyle]::Bottom
$generateButton.Add_Click({
    $passphraseBox1.Text = (New-PassPhrase)
})

$panel = New-Object System.Windows.Forms.Panel
$panel.Padding = New-Object System.Windows.Forms.Padding(10, 10, 10, 10)
$panel.Dock = [System.Windows.Forms.DockStyle]::Fill
$form.Controls.Add($panel)

$passphraseBox1.Dock = [System.Windows.Forms.DockStyle]::Fill
$panel.Controls.Add($passphraseBox1)

$copyButton1.Dock = [System.Windows.Forms.DockStyle]::Bottom
$panel.Controls.Add($copyButton1)

$generateButton.Dock = [System.Windows.Forms.DockStyle]::Bottom
$panel.Controls.Add($generateButton)



$form.ShowDialog()

}


Show-PassPhraseForm
