#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

#Посмотреть набор командлетов.
Get-ManagementRoleEntry "Mail Recipient Creation\*"

#Скопировать набор командлетов.
New-ManagementRole -Name "Mailbox Creation Only" -Description "Allows creating mailbox but not deletion." -Parent "Mail Recipient Creation"

#Посмотреть командлеты в наборе
Get-ManagementRoleEntry "Mailbox Creation Only\Remove-*"

#Удалить из набора командлеты
Remove-ManagementRoleEntry "Mailbox Creation Only\Remove-Mailbox"

#Создать область действия.
New-ManagementScope -Name "Moscow Scope" -RecipientRestrictionFilter {Office -Eq "Moscow"}

#Создать почтовый ящик.
New-Mailbox -Alias JoJo2 -Name Rabbit2 -FirstName Rabbit2 -LastName JoJo2 -DisplayName "Rabbit JoJo" `
-MicrosoftOnlineServicesID JoJo2@contoso8.ru -Password (ConvertTo-SecureString -String 'P@ssw0rd212121' -AsPlainText -Force) `
-ResetPasswordOnNextLogon $false -PrimarySmtpAddress Rabbit.JoJo2@contoso8.ru

#Удалить почтовый ящик
Get-Mailbox JoJo1 | Disable-Mailbox  -PermanentlyDisable

#Проверка работы областей.
Get-Mailbox | FL name,*Office*
Set-Mailbox test -CustomAttribute8 11
Set-Mailbox Elon -CustomAttribute8 11

