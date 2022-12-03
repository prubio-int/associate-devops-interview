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



# Populate list of account names/subscription ids
$UsersListOfAccounts = az account list --query [].name
$UsersListOfIDs = az account list --query [].id


cls
Write-Host "Welcome.  This script will generate a CSV report for all Azure Virtual Machines."


# Prompt for account name or id.  If invalid, ask again

$done = $false
do {
    
    $AccountName = Read-Host "Please enter account name or ID"

    # Check if input is valid in list of IDs
    foreach ($id in $UsersListOfIDs) {
        if ($id.Contains($AccountName)) {
            $done = $true
            break
        }
    }

    if (!$done) {

        # Check if input is valid in list of accounts
        foreach ($acc in $UsersListOfAccounts) {
            if ($acc.Contains($AccountName)) {
                $done = $true
                break
            }
        }
    }
    if (!$done) {
    Write-Host "Input is invalid.  Please re-check the subscription ID or Account name"
    }

} while (!$done)


$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ReportName = "\\CSV_Report_Azure_VMs_" + (Get-Date -Format "yyyyMMdd") + "_" + (Get-Date).Hour + (Get-Date).Minute + (Get-Date).Second + ".csv"

$report = az vm list --show-details -d --query "[].{ID:id,Name:name,Size:hardwareProfile.vmSize,OperatingSystem:osType,PowerState:powerState,PrivateIP:privateIps,PublicIP:publicIps,Tags:tags}" --output json | ConvertFrom-Json
#$report | Export-Csv -Path C:\Users\p-r\Desktop\test.csv -NoTypeInformation

$report | Export-Csv -Path $DesktopPath + $ReportName -NoTypeInformation

Write-Host "Report " + $ReportName + " has been generated and saved onto your Desktop."

