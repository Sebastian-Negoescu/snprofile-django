####################################################################
#################### CONNECT TO THE AZURE CLOUD ####################
####################################################################

$pwd = Read-Host "Your Service Principal's secret: " -AsSecureString
$creds = New-Object System.Management.Automation.PSCredential("http://AzDevOps", $pwd)
$subName = "VSEnterprise_DEV"
$tenant = "sebinego.onmicrosoft.com"
Connect-AzAccount -ServicePrincipal -Credential $creds -Tenant $tenant -Subscription $subName

#####################################################################
#################### GATHER FACTS FOR AUTOMATION ####################
#####################################################################

$stgPrefix = "sebinegovw"
$stgRg = $stgPrefix.ToString() + "_rg"
$stgAcctName = $stgPrefix.ToString() + "infra"
$container = "armtemplates"
$blob = "azure_infra/master.json"

$deploymentPrefix = "sebidummy"
$deploymentRG = $deploymentPrefix.ToString() + "_rg"

###########################################################
#################### TEST IF RG EXISTS ####################
###########################################################

Get-AzResourceGroup -Name $deploymentRG -ErrorAction SilentlyContinue
If ($?) {
    Write-Host "Looks like the $($deploymentRG) already exists. Let's continue with testing the deployment."
} Else {
    Write-Host "Resource Group $($deploymentRG) does not exist. Let me deploy it first..."
    New-AzResourceGroup -Name $deploymentRG -Location "West Europe"
    Write-Host "Cool, RG $($deploymentRG) is now created. Let's continue with testing the deployment."
}

##########################################################
#################### TEST MASTER JSON ####################
##########################################################
Write-Host "Current storage account used is: " -NoNewLine
Set-AzCurrentStorageAccount -ResourceGroupName $stgRg -Name $stgAcctName
$token = New-AzStorageContainerSASToken -Name $container -Permission r -ExpiryTime (Get-Date).AddMinutes(30.0)
$url = (Get-AzStorageBlob -Container $container -Blob $blob).ICloudBlob.Uri.AbsoluteUri
$templateUri = $url + $token
$masterLinked = Test-AzResourceGroupDeployment -ResourceGroupName $deploymentRG -TemplateUri $templateUri -prefix $deploymentPrefix -containerSasToken (ConvertTo-SecureString $token -AsPlainText -Force)

###############################################################
#################### DEPLOY MASTER LINKED #####################
###############################################################

If (!($masterLinked.Code)) {
    Write-Host "Looks like there are no errors. Let's deploy the environemnt..."
    New-AzResourceGroupDeployment -ResourceGroupName $deploymentRG -TemplateUri $templateUri -prefix $deploymentPrefix -containerSasToken (ConvertTo-SecureString $token -AsPlainText -Force)
    Write-Host "Everything deployed. Enjoy your Azure experience!"
} Else {
    Write-Host "Oopsie! There are some errors..."
    Write-Host "Error Code: " $masterLinked.Code -ForegroundColor "DarkYellow"
    Write-Host "Error Message: " $masterLinked.Message -ForegroundColor "DarkYellow"
}

Write-Host "Script finished. Disconnecting from the Azure session..."
# Disconnect-AzAccount