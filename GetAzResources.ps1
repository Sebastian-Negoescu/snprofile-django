### Create a file for Terraform Output and then parse it for values
### Go to Terraform's location, write the output for Az Resources inside terraform_output.txt 
### Revert to the old workspace for further run of the script
$oldLocation = Get-Location
$path = (Get-Location).ToString() + "\azure_infra\paas\"
Set-Location -Path $path
$terraform_output = New-Item -Path $oldLocation -Name "terraform_output.txt" -ItemType File -Force
$command = & /Users/sebinegoescu/terraform/terraform output
Set-Content -Value $command -Path $terraform_output
Set-Location -Path $oldLocation

### Register the values inside variables that are going to be used forther in the script
$output_content = Get-Content -Path $terraform_output

[string]$rgName;
[string]$waName;
[string]$dev_slot;
[string]$feat_slot;
ForEach ($line in $output_content) {
    $lineSplit = $line.Split(' ')
    If ($lineSplit[0].ToString() -eq "rg_name") {
        $rgName = $lineSplit[2]
    } 
    Else {
        If ($lineSplit[0].ToString() -like "webapp_name") {
            $waName = $lineSplit[2]
        }
        elseif ($lineSplit[0].ToString() -like "*dev") {
            $dev_slot = $lineSplit[2]
        }
        elseif ($lineSplit[0].ToString() -like "*feature") {
            $feat_slot = $lineSplit[2]
        }
        Else {
            Write-Host "Get your options straight here... Ain't no other possibility."
        }
    }
}
Write-Host "RG's Name: $($rgName)" -ForegroundColor Black -BackgroundColor Yellow
Write-Host "WebApp's Name: $($waName)" -ForegroundColor Black -BackgroundColor Yellow
Write-Host "DEV Slot: $($dev_slot)" -ForegroundColor Black -BackgroundColor Yellow
Write-Host "FEAT Slot: $($feat_slot)" -ForegroundColor Black -BackgroundColor Yellow