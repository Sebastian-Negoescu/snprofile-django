#########################################################
### Enable Python 3.7 as Stack with Major version 3.7 ###
#########################################################

$djangoPrereq = @{
    pythonVersion = "3.7";
    linuxFxVersion = "PYTHON|3.7";
}

$apps = @{
    master = $waName;
    dev = $dev_slot;
    feat = $feat_slot;
}

ForEach ($key in $apps.Keys) {
    If ($key.ToString() -eq "master") {
        $fullAppName = $($apps.$key).ToString() + "/web"
        Set-AzResource -ResourceGroupName $rgName -PropertyObject $djangoPrereq -ResourceType Microsoft.Web/sites/config `
        -ResourceName $fullAppName -ApiVersion 2019-08-01 -Force
        $pythonStatus = (Get-AzWebApp -Name $($apps.$key) -ResourceGroupName $rgName).SiteConfig.PythonVersion
        $linuxStatus = (Get-AzWebApp -Name $($apps.$key) -ResourceGroupName $rgName).SiteConfig.LinuxFxVersion
        If ($null -ne $pythonStatus) {
            Write-Host "Successfully modified $($apps.$key)'s Python Version to: $pythonStatus." -ForegroundColor DarkRed -BackgroundColor Black
        }
        If ($null -ne $linuxStatus) {
            Write-Host "Successfully modified $($apps.$key)'s Linux FX Version to: $linuxStatus." -ForegroundColor DarkRed -BackgroundColor Black
        }
    }
    Else {
        $fullSlotName = $waName.ToString() + "/" + $($apps.$key) + "/web"
        Set-AzResource -ResourceGroupName $rgName -PropertyObject $djangoPrereq -ResourceType Microsoft.Web/sites/slots/config `
        -ResourceName $fullSlotName -ApiVersion 2019-08-01 -Force
        $pyStatus = (Get-AzWebAppSlot -ResourceGroupName $rgName -Name $waName -Slot $($apps.$key)).SiteConfig.PythonVersion
        $linuxFxVersionSlot = (Get-AzWebAppSlot -ResourceGroupName $rgName -Name $waName -Slot $($apps.$key)).SiteConfig.LinuxFxVersion
        If ($null -ne $pyStatus) {
            Write-Host "Successfully modified $waName/$($apps.$key)'s Python Version to: $pyStatus." -ForegroundColor DarkRed -BackgroundColor Black
        }
        If ($null -ne $linuxFxVersionSlot) {
            Write-Host "Successfully modified $waName/$($apps.$key)'s Linux FX Version to: $linuxFxVersionSlot." -ForegroundColor DarkRed -BackgroundColor Black
        }
    }
    
    # Write-Host $key;
    # Write-Host "$($apps.$key)";
}