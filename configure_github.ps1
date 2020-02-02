$location = Get-Location
$file = Get-Content $location"\secrets.txt"

[string] $gitrepo;
[string] $gittoken;

ForEach ($line in $file) {
    $lineSplit = $line.Split(' ')
    If ($lineSplit[0] -eq "gitrepo".ToString()) {
        $gitrepo = $lineSplit[2]
    }
    Else {
        $gittoken = $lineSplit[2]
    }
}

Write-Host "Our GitHub Repo is: $($gitrepo)"
Write-Host "Our GitHub Token is:..."
Write-Host "Stop tripping - ain't no one showing the Token, let's be real now... :)"

$rgName = ""
$waName = ""
$waId = (Get-AzWebApp -Name $waName -ResourceGroupName $rgName).Id
$slotName = ""
$location="West Europe"

# SET GitHub
$PropertiesObject = @{
    token = $gittoken;
}
Set-AzResource -ResourceId -PropertyObject $PropertiesObject `
-ResourceId /providers/Microsoft.Web/sourcecontrols/GitHub -ApiVersion 2015-08-01 -Force

# Configure GitHub deployment from your GitHub repo and deploy once.
$PropertiesObject = @{
    repoUrl = "$gitrepo";
    branch = "<my_specific_branch>";
}
Set-AzResource -PropertyObject $PropertiesObject -ResourceGroupName myResourceGroup `
-ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $webappname/$slotName `
-ApiVersion 2015-08-01 -Force
