#admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
-Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking



Install-Module MSOnline

Connect-MsolService

$users = Import-Csv "C:\Users\irud\Documents\ExchangeOnlineScripts\users msol.csv"

$users | ForEach-Object {

New-MsolUser -UserPrincipalName $_.UserPrincipalName -City $_.city -State $_.State -Country $_.Country -DisplayName $_.DisplayName }

Set-Msoluser -UserPrincipalName irud@contoso8.ru -UsageLocation "US"
Set-MsolUserLicense -UserPrincipalName irud@contoso8.ru -AddLicenses "contosorf:ENTERPRISEPREMIUM" 

Get-Mailbox