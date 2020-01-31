$gitrepo="<replace-with-URL-of-your-own-GitHub-repo>"
$gittoken="<replace-with-a-GitHub-access-token>" 
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
