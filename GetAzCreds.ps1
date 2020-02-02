$oldWs = Get-Location
$secret_file = $oldWs.ToString() + "\azure_infra\paas\secrets.tfvars"
$secret_content = Get-Content -Path $secret_file

[string]$subId;
[string]$tenant_id;
[string]$spId;
[string]$spPwd;
ForEach ($line in $secret_content) {
    $lineSplit = $line.Split(' ')
    If ($lineSplit[0].ToString() -eq "subscription_id") {
        $subId = ($lineSplit[2]).Trim('"')
    }
    elseif ($lineSplit[0].ToString() -eq "tenant_id") {
        $tenant_id = ($lineSplit[2]).Trim('"')
    }
    elseif ($lineSplit[0].ToString() -eq "client_id") {
        $spId = ($lineSplit[2]).Trim('"')
    }
    Else { #($lineSplit[0].ToString() -eq "client_secret")
        $spPwd = ($lineSplit[2]).Trim('"')
    }
}

Write-Host "Subscription ID: $($subId)" -ForegroundColor Black -BackgroundColor Yellow
Write-Host "Tenant ID: $($tenant_id)" -ForegroundColor Black -BackgroundColor Yellow
Write-Host "ServicePrincipal ID: $($spId)" -ForegroundColor Black -BackgroundColor Yellow
Write-Host "ServicePrincipal Secret: Is somone actually going to believe I was about to show my SP's secret...? :(" -ForegroundColor Black -BackgroundColor Yellow