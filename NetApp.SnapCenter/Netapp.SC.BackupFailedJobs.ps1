<#
.DESCRIPTION
Thsi cmdlet check for jobs with status failed or warning within SnapCenter's snaphot jobs
After checking, will re-run backup jobs and send notification via e-mail
Cmdlet can be run by scheduale task or on demand
.NOTES
Run this cmdelt from instance with SnapCenter installed on or from any PC with installed SnapCenter PowerShell  Module.
The PowerShell SnapCenter Module is intergited into SnapCenter and not come as stand alone module.
To install module on other PC without SnapCenter installed follow instructions bellow
For credentials you need account with privileges for SnapCenter and NetApp System.
// On instance with installed SnapCenter go to directory %systemroot%\System32\WindowsPowerShell\v1.0\Modules
// Copy from there folder SnapCenter to your PC machine
// Put the folder into directory %systemroot%\System32\WindowsPowerShell\v1.0\Modules
// Run command within PowerShell (run as admin)
// 'Import-Module SnapCenter -Verbose'
// Paths might very. Recheck with command 'Get-Module -ListAvailable' to get the path.
#>

$ErrorActionPreference = "Stop" 

# Getting Credentials
$cred = Get-Credential

# Connect to SnapCenter
Open-SmConnection -Credential $cred -SMSbaseUrl "https://ssnapcenter.yourdomain.com:8146"

# Condition for date and mail enconding
$dateYesterday = (Get-Date).AddHours(-12)
$dateToday = (Get-Date)
$enc = New-Object System.Text.utf8encoding

# Get failed jobs
$jobs = Get-SmBackupReport -FromDateTime $dateYesterday -ToDateTime $dateToday  | Where-Object { $_.status -eq "failed" -or $_.status -eq "Warning" }

# Backup failed jobs and send notification    
foreach ($job in $jobs) {
    $backupname = $job.ProtectionGroupName
    New-SmBackup -ResourceGroupName $backupname -Policy $job.PolicyName -Confirm:$false
    Start-Sleep -Seconds 120
    $newBackupStatus = (Get-SmBackupReport -ResourceGroup $backupname -FromDateTime $dateToday | Sort-Object | Select-Object -Last 1).status
    $messageBody = "backup of $backupname failed and resubmited again and comleted in status of $newBackupStatus"
    Send-MailMessage -From "SCRestore@yourdomain.com" -To "NetApp@yourdomain.com" -SmtpServer exchange.yourdomain.com -Subject "SC resubmit jobs" -Body $MessageBody -Encoding $enc  
}
