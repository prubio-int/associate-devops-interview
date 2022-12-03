<# 

Develop a script/program that outputs a csv report for all Azure Virtual Machines or AWS EC2 Instances with the following information:

- ID (e.g. Resource Id/Instance Id)
- Name
- Size/SKU (e.g. Standard_D2_v3/m5.large)
- Operating System (Windows or Linux is fine here, no need to get the version)
- Power State (e.g. Running/Stopped etc.)
- IP Address
- Tags (separated by semicolon)

#>


# Prompt user to login to their Azure account
az login



# Populate list of account names/subscription ids according to users login account
$UsersListOfAccounts = az account list --query [].name
$UsersListOfIDs = az account list --query [].id


cls
Write-Host "Welcome.  This script will generate a CSV report for all Azure Virtual Machines."


# Prompt for account name or id.  If invalid, ask again

$done = $false
do {
    
    $AccountName = Read-Host "Please enter Subscription name or Subscription ID"

    # Confirm if input is a valid ID by checking if it exists in the list of IDs
    foreach ($id in $UsersListOfIDs) {
        if ($id.Trim() -replace '"', "" -replace ',', "" -eq $AccountName) {
            $done = $true
            # Set the account with Subscription ID
            az account set -s $AccountName
            break
            # break out of loop if we found a match and skip the below loop
        }
    }

    # Proceed to below loop to check if user entered a Subscription name

    if (!$done) {

        # Check if input is valid in list of accounts
        foreach ($acc in $UsersListOfAccounts) {
            if ($acc.Trim() -replace '"', "" -replace ',', "" -eq $AccountName) {
                $done = $true
                # Set the account with Subscription name
                az account set --name $AccountName
                break
            }
        }
    }
    if (!$done) {
    Write-Host "Input is invalid.  Please re-check the subscription ID or Account name"
    }

} while (!$done)



# Specify user's desktop as the save file location
$DesktopPath = [Environment]::GetFolderPath("Desktop") + "\CSV_Report_Azure_VMs_" + (Get-Date -Format "yyyyMMdd") + "_" + (Get-Date).Hour + (Get-Date).Minute + (Get-Date).Second + ".csv"


$report = az vm list --show-details -d --query "[].{ID:id,Name:name,Size:hardwareProfile.vmSize,OperatingSystem:storageProfile.osDisk.osType,PowerState:powerState,PrivateIP:privateIps,PublicIP:publicIps,Tags:tags}" --output json | ConvertFrom-Json


$report | Export-Csv -Path $DesktopPath -NoTypeInformation

Write-Host "A file named --> "  $ReportName  "<-- has been generated and saved onto your Desktop."

