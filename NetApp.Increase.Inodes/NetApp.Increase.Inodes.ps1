<#
// Script for increase Inodes on CIFS Volume
// You need download and install the PowerShell Module for NetApp
// Can use the the DataONTAP or the newest one NetApp.ONTAP
// Module DataONTA on Powershell Gallery: https://www.powershellgallery.com/packages/DataONTAP/9.8.0
// Module NetApp.ONTAP on PowerShell Gallery : https://www.powershellgallery.com/packages/NetApp.ONTAP/9.15.1.2407 
#>

# Connect to Cluster and SVM 
Import-Module DataONTAP
$cred = Get-Credential
$Controller = Read-Host "Insert Controler Name"
$SVM = Read-Host "Insert VServer Name" 
Connect-NcController -Name $Controller -Vserver $SVM -Credential $cred -HTTPS

# Let's get current situation on volume 
$volume = Read-Host "Insert Volume Name"
Get-NcVol -Name $volume | Select-Object Name, FilesTotal, FilesUsed
Write-Host -ForegroundColor DarkYellow "FilesTotal = Total Inodes"

# In background will pull the FilesTotal and increase by 10%
$inodes = (Get-NcVol -Name $volume).FilesTotal.ToString()
$pct = $inodes / 100 * 10
$size = $pct + $inodes
$newsize = [math]::Round($size)
Set-NcVolTotalFiles -Name $volume -TotalFiles $newsize
Write-Host -ForegroundColor DarkGreen "The new size of inodes is $newsize"
