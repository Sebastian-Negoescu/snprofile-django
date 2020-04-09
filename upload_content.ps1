######################################################################
############## CONNECT TO AZURE ######################################
######################################################################

$pwd = ConvertTo-SecureString "3Microsoft." -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential("http://AzDevOps", $pwd)
Connect-AzAccount -ServicePrincipal -Credential $creds -Tenant "sebinego.onmicrosoft.com" -Subscription "VSEnterprise_DEV"

######################################################################
############## GATHER FACTS FOR AUTOMATION ###########################
######################################################################

$prefix = "sebinegovw"
$subId = (Get-AzSubscription).Id
$stgRg = $prefix.ToString() + "_rg"
$stgAcct = $prefix.ToString() + "infra"
$container = "armtemplates"
$localPath = "/Users/sebinegoescu/Desktop/azprofile/myprofile/azure_infra"

############## PRINT THE FACTS FOR CONFIRMATION ##############
Write-Host "PREFIX: $($prefix)" -BackgroundColor "Black" -ForegroundColor "DarkYellow"
Write-Host "SUBSCRIPTION ID: $($subId)" -BackgroundColor "Black" -ForegroundColor "DarkYellow"
Write-Host "RG NAME: $($stgRg)" -BackgroundColor "Black" -ForegroundColor "DarkYellow"
Write-Host "STORAGE ACCOUNT: $($stgAcct)" -BackgroundColor "Black" -ForegroundColor "DarkYellow"
Write-Host "CONTAINER: $($container)" -BackgroundColor "Black" -ForegroundColor "DarkYellow"
Write-Host "LOCAL PATH: $($localPath)" -BackgroundColor "Black" -ForegroundColor "DarkYellow"

############## GET STORAGE ACCOUNT KEY ##############
$stgAcctKey = (Get-AzStorageAccountKey -ResourceGroupName $stgRg -AccountName $stgAcct).Value[0]

############## SET STORAGE CONTEXT ##############
$destContext = New-AzStorageContext -StorageAccountName $stgAcct -StorageAccountKey $stgAcctKey

############## GENERATE SHARED ACCESS SIGNATURE URI ##############
$containerSasUri = New-AzStorageContainerSASToken -Context $destContext -ExpiryTime(Get-Date).AddSeconds(3600) -FullUri -Name $container -Permission "rw"

############## UPLOAD THE ALL THE CONTENT TO THE STORAGE CONTAINER ##############
azcopy copy $localPath $containerSasUri --recursive=true
