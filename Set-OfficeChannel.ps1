
# Set Office 2016 Click to Run Channel with PowerShell
#
# PowerShell sets the registry key for the appropriate update channel and kicks off the update process
# You can move back channels as you please
# Note if a GPO is set it might overide this
# Note, changing build/channel might cause issues, do it at your own risk
# Tom Arbuthnot tomtalks.uk

# Learn about the channels here: http://tomtalks.uk/2015/12/understanding-office-click-run-branches-msi-skype-business-client-versions/


# Simple Menu Credit: 
# http://www.tomsitpro.com/articles/powershell-interactive-menu,2-961.html
# Update exe command line switches: 
# https://blogs.technet.microsoft.com/odsupport/2014/03/03/the-new-update-now-feature-for-office-2013-click-to-run-for-office365-and-its-associated-command-line-and-switches/

#               Disclaimer   				You running this script means you won't blame me if this breaks your stuff. This script is
#  											provided AS IS without warranty of any kind. I disclaim all implied warranties including,
#  											without limitation, any implied warranties of merchantability or of fitness for a particular
#  											purpose. The entire risk arising out of the use or performance of the sample scripts and
#  											documentation remains with you. In no event shall I be liable for any damages whatsoever
#  											(including, without limitation, damages for loss of business profits, business interruption,
#  											loss of business information, or other pecuniary loss) arising out of the use of or inability
#  											to use the script or documentation.

function Show-Menu
{
     param (
           [string]$Title =  '  Set your Office 2016 Click to Run Channel  ',
           [string]$Title2 = "By Tom Arbuthnot tomtalks.uk Use at your own risk"
     )
     Write-host ""
     write-host ""
     Write-Host "================ $Title ================"
     Write-Host "=============== $Title2 ============="
     Write-host " "
     Write-Host "1: Press '1' for Office Insider Fast – weekly builds, not generally supported (Insiderfast)"
     Write-Host "2: Press '2' for Office Insider Slow / First Release Channel (FirstReleaseCurrent)"
     Write-Host "3: Press '3' for Current Channel (Current)"
     Write-Host "4: Press '4' for First Release for Deferred Channel (Validation)"
     Write-Host "5: Press '5' for Deferred Channel (previously Current Branch for Business) (Business)"
     Write-Host ""
     Write-Host "Q: Press 'Q' to quit."
}


     Show-Menu
     Write-Host ""
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                
                'You chose option #1 - Office Insider Fast – weekly builds, not generally supported (Insiderfast)'
                $Channel = "Insiderfast"
           } '2' {
                
                'You chose option #2 - Office Insider Slow / First Release Channel (FirstReleaseCurrent)'
                $Channel = "FirstReleaseCurrent"
           } '3' {
                
                'You chose option #3 - Current Channel (Current)'
                $Channel = "Current"
             } '4' {
                
                'You chose option #4 - First Release for Deferred Channel (Validation)'
                $Channel = "FirstReleaseDeferred"
             } '5' {
                
                'You chose option #5- for Deferred Channel (previously Current Branch for Business) (Business)'
                $Channel = "Business"
           } 'q' {
                return
           }
     }

 
# If Channel Variable is set, set the registry key  
IF ($Channel -ne $null)
{    
Write-Host " "
write-host "Setting Registry Key"

New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\ -Name officeupdate –Force

# Set-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate\updatebranch -Value “Current”

New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate -Name updatebranch -PropertyType String -Value $Channel

# Force Update

$UpdateEXE = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
$UpdateArguements = "/update user displaylevel=true"

start-process $UpdateEXE $UpdateArguements
} 
