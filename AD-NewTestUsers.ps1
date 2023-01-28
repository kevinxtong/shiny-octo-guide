Import-Module ActiveDirectory

$ouPath = "OU=exampleOUname,DC=example,DC=local"
$numUsers = 10

# Generic employee names and jobs
$firstNames = @("Kevin", "Mark", "John", "Amy", "Michael", "Jessica", "David", "Ashley", "Chris", "Samantha", "Daniel", "Emily", "Jacob", "Emma", "Joshua", "Madison", "Matthew", "Olivia", "Ethan", "Ava", "Andrew", "Isabella", "Justin", "Natalie", "Nicholas", "Sofia", "Ryan", "Alyssa", "William", "Mia", "George", "Harry", "Oliver", "Charlie", "Jack", "Edward", "Emily", "Lily", "Alfie", "Harvey", "Grace")
$lastNames = @("Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "White", "Martin", "Anderson", "Lewis", "Scott", "Young", "King", "Green", "Baker", "Adams", "Nelson", "Carter", "Mitchell", "Peters", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Stewart", "Cooper", "Morris", "Rogers", "Cook", "Greene", "Graham", "Moore", "Mills")
$initialLetters = "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
$middleInitial = (Get-Random -InputObject $initialLetters)
$jobTitles = @("Manager", "Director", "Supervisor", "Analyst", "Consultant", "Developer", "Specialist", "Assistant", "Associate", "Coordinator", "Representative", "Advisor", "Officer", "Lead", "Architect", "Executive", "Consultant", "Instructor")
$departments = @("Accounting", "Marketing", "Human Resources", "IT", "Finance", "Legal", "Quality Control", "Product Development", "Logistics", "Procurement", "Facilities", "Training", "Public Relations", "Creative")
$companyName = "example.com"

for ($i = 1; $i -le $numUsers; $i++) {
    $firstName = Get-Random -InputObject $firstNames
    $lastName = Get-Random -InputObject $lastNames

    # 25% chance to add hyphenated surname
    if((Get-Random -Minimum 1 -Maximum 100) -le 25){
        $lastName2 = Get-Random -InputObject $lastNames
        $lastName += "-"+$lastName2
    }

    $name = $firstName + " " + $lastName
    $username = $firstName.Substring(0,1) + $lastName
    $username = $username -replace '[^A-Za-z0-9]',''
    
    $userPrincipalName = $username + "@example.local"

    $jobTitle = Get-Random -InputObject $jobTitles
    $department = Get-Random -InputObject $departments

    $password = ConvertTo-SecureString -String "P@ssword1" -AsPlainText -Force

    New-ADUser -Name $name -SamAccountName $username -UserPrincipalName $userPrincipalName -Path $ouPath -AccountPassword $password -Enabled $true -GivenName $firstName -Surname $lastName -Initials $middleInitial -Title $jobTitle -Department $department -Company $companyName -Description $jobTitle
}
