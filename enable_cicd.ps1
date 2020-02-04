##################################################
########### LOAD THE AZURE CREDENTIALS ###########
##################################################

. .\GetAzCreds.ps1
$clientId = $spId
$clientPwd = ConvertTo-SecureString -String "$($spPwd)" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $clientPwd
Connect-AzAccount -ServicePrincipal -Credential $Credential -SubscriptionId $subId -TenantId $tenant_id

$location = Get-Location
$file = Get-Content $location"\secrets.txt"

[string] $gitrepo;
[string] $gittoken;

ForEach ($line in $file) {
    $lineSplit = $line.Split(' ')
    If ($lineSplit[0] -eq "gitrepo".ToString()) {
        $gitrepo = ($lineSplit[2]).Trim('"')
    }
    Else {
        $gittoken = ($lineSplit[2]).Trim('"')
        $gittoken = $gittoken | ConvertTo-SecureString -AsPlainText -Force # Making the token a secure string
    }
}

Write-Host "Our GitHub Repo is: $($gitrepo)"
Write-Host "Our GitHub Token is:..."
Write-Host "Stop tripping - ain't no one showing the Token, let's be real now... :)"


################################################
########### LOAD THE AZURE RESOURCES ###########
##################### &&& ######################
########### LOAD THE PYTHON_ON SCRIPT ##########
################################################

. .\GetAzResources.ps1
. .\Enable_Python.ps1

$waId = (Get-AzWebApp -Name $waName -ResourceGroupName $rgName).Id
$slotName = @{
    dev = $($dev_slot);
    feat = $($feat_slot);
}
$branch = @{
    dev = "develop";
    feat = "feature/az";
}



Read-Host "If everything looks cool, press ENTER to continue the script. Otherwise press CTRL+C..."

### INCLUDE AN ERROR HANDLE IN CASE VARS ARE NOT SCOPED CORRECTLY
If ( $null -ne ($waId -and $slotName)) {
    Write-Host "All good - resuming the script. :)"
} Else {
    Write-Host "Wrong call!!! Scope dem vars correctly, man... :("
}

### SET GitHub
$TokenObject = @{
    # .NET to retrieve the Secure String Objects's value
    token = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($gittoken))))
}
Set-AzResource -PropertyObject $TokenObject -ResourceId /providers/Microsoft.Web/sourcecontrols/GitHub `
-ApiVersion 2015-08-01 -Force

########################################################################
### Configure GitHub deployment on a branch per according slot logic ###
########################################################################

ForEach ($item in $slotName.Keys) {
    $PropertiesObject = @{
        repoUrl = $($gitrepo);
        branch = $($branch.$item);
    }

    $resourceName = ($waName).ToString() + "/" + ($slotName.$item).ToString() + "/web"

    Set-AzResource -PropertyObject $PropertiesObject -ResourceGroupName $rgName `
    -ResourceType Microsoft.Web/sites/slots/sourcecontrols -ResourceName $resourceName `
    -ApiVersion 2016-08-01 -Force
}
