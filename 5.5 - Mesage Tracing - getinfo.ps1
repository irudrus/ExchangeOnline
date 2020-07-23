#Accept input parameters 
Param( 
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)] 
    [string] $Office365Username, 
    [Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)] 
    [string] $Office365Password 
) 

$OutputFile = "DetailedMessageStats.csv" 

Write-Host "Connecting to Office 365 as $Office365Username..." 

#Connect to Office 365 
$SecurePassword = $Office365Password | ConvertTo-SecureString -AsPlainText -Force 
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Office365Username, $SecurePassword 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


Write-Host "Collecting Recipients..." 

#Collect all recipients from Office 365 
$Recipients = Get-Recipient -ResultSize Unlimited | select PrimarySMTPAddress 
$MailTraffic = @{} 
foreach($Recipient in $Recipients) 
{ 
    $MailTraffic[$Recipient.PrimarySMTPAddress.ToLower()] = @{} 
} 
$Recipients = $null 

#Collect Message Tracking Logs (These are broken into "pages" in Office 365 so we need to collect them all with a loop) 
$Messages = $null 
$Page = 1 
do 
{ 

    Write-Host "Collecting Message Tracking - Page $Page..." 
    $CurrMessages = Get-MessageTrace -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date)  -PageSize 5000  -Page $Page| Select Received,*Address,*IP,Subject,Status,Size

    if ($CurrMessages -ne $null)
      {
      $CurrMessages | Export-Csv C:\FILE-$PAGE.csv -NoTypeInformation
      }
    $Page++ 
    $Messages += $CurrMessages 


} 
until ($CurrMessages -eq $null) 

Remove-PSSession $session 