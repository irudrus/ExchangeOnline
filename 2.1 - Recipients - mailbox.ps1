#Подключение к Exchange Online


$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

#Создание почтового ящика.

New-Mailbox -Alias JoJo1 -Name Rabbit1 -FirstName Rabbit1 -LastName JoJo1 -DisplayName "Rabbit JoJo" `
-MicrosoftOnlineServicesID JoJo1@contoso8.ru -Password (ConvertTo-SecureString -String 'P@ssw0rd212121' -AsPlainText -Force) `
-ResetPasswordOnNextLogon $false -PrimarySmtpAddress Rabbit.JoJo1@contoso8.ru

#Enable-Mailbox теперь только для архивов.

Get-User -RecipientTypeDetails User -Filter "UserPrincipalName -ne `$null" -ResultSize unlimited | Enable-Mailbox

Get-Mailbox | Enable-Mailbox -Archive

#Работа с лицензиями.

Find-Module -Name MSOnline | Install-Module -Force
$O365Cred = Get-Credential
Connect-MsolService -Credential $O365Cred
Get-MsolAccountSku

$Users = Get-MsolUser -All -UnlicensedUsersOnly | Out-GridView -Title 'Select users to assign license plan to' -OutputMode Multiple

Get-MsolAccountSku

Set-MsolUserLicense -UserPrincipalName JoJo1@contoso8.ru -AddLicenses "contosorf:ENTERPRISEPREMIUM" 

Set-Msoluser -UserPrincipalName JoJo1@contoso8.ru -UsageLocation "US"

#Отключение почтового ящика не так как в 365

Get-Mailbox JoJo | Disable-Mailbox 

Get-Mailbox JoJo | Disable-Mailbox  -PermanentlyDisable

Remove-Mailbox -Identity JoJo

Get-MsolUser –ReturnDeletedUsers

Remove-MsolUser -UserPrincipalName JoJo -RemoveFromRecycleBin

