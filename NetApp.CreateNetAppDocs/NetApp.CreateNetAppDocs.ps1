<#
// To create a set of Word and Excel documents with detailed information about the NetApp environment.
// This script requires Module NetAppDocs wich can be only downloaded from Tools on official NetApp Support Site,
// you will need account associated with corporate license to do that.
#>

# Create path and folder for NetApp Documents
$Base = "<Path_Directory_NetApp_Documents>"
$d = Get-Date -Format "yyyy-MM-dd"
$Folder = $Base + $d

# If the folder doesn't exist then create it
if (!(Test-Path $Folder)) {
    New-Item -Path $Base -Name $d -ItemType Directory
    Write-Host -ForegroundColor Yellow "Created folder $Folder for the new output files"
}

# Import Module
Import-Module NetAppDocs

# Enter Credential for user with administrator privileges on NetApp Systems
$cred = Get-Credential 

# Add NetApp clusters to variable
$clusters = "<cluster1>", "<cluster2>", "<cluster3>"

foreach ($cluster in $clusters) {
    
    # Create Excel Doc
    Get-NtapClusterData -Name $cluster -Credential $cred -Verbose | Format-NtapClusterData -Verbose | Out-NtapDocument -ExcelFile "$Folder\$Cluster.xlsx" -Verbose

    #Create Word Doc
    Get-NtapClusterData -Name $cluster -Credential $cred -Verbose | Format-NtapClusterData -Verbose | Out-NtapDocument -WordFile "$Folder\$CLuster.docx" -Verbose
}

# Send a mail to let us know we have some new docs
$m = Get-Date -UFormat "%B %Y"
$To = "admin@yourdomain.com"
$From = "NetAppDocs@yourdomain.com"
$Smtp = "exchange.yourdomain.com"
Send-MailMessage -BodyAsHtml -Encoding UTF8 -To $To -From $From -SmtpServer $Smtp -Subject "NetApp Docs $m" `
    -Body "We had just generated a fresh set of NetApp Docs. The files are located <a href=$Folder>here</a>"