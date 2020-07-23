#Подключение к Exchange Online

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking




#Поcмотреть текущие MailboxPlan
Get-MailboxPlan | ft  Name,Alias,ProhibitSendQuota,IsDefault -AutoSize


#Поcмотреть параметры текущего MailboxPlan
Get-MailboxPlan  ExchangeOnlineEnterprise-2088d9ed-f24f-4ef2-b370-5cb7ecab1a91 | fl 


#Поcмотреть примененные MailboxPlan
Get-Mailbox | ft  Name,MailboxPlan


#Внести изменения  в MailboxPlan
Set-MailboxPlan -Identity ExchangeOnlineEnterprise-2088d9ed-f24f-4ef2-b370-5cb7ecab1a91 -RetainDeletedItemsFor 30.00:00:00  `
-IssueWarningQuota 20GB -ProhibitSendQuota 22GB -ProhibitSendReceiveQuota 30GB

#Явное указание  MailboxPlan
New-Mailbox -Alias Titov -Name Boris -FirstName Boris -LastName Titov -DisplayName "Boris Titov" `
-MicrosoftOnlineServicesID Titov@contoso8.ru -Password (ConvertTo-SecureString -String 'P@ssw0rd212121' -AsPlainText -Force) `
-ResetPasswordOnNextLogon $false -PrimarySmtpAddress Titov@contoso8.ru -MailboxPlan ExchangeOnlineEnterprise-2088d9ed-f24f-4ef2-b370-5cb7ecab1a91


#Посмотреть список  CASMailboxPlan
Get-CASMailboxPlan | ft  Name

#Посмотреть параметры Imap  CASMailboxPlan
Get-CASMailboxPlan  ExchangeOnlineEnterprise-2088d9ed-f24f-4ef2-b370-5cb7ecab1a91  | Select Imap*

#Посмотреть параметры ящика
Get-CASMailbox Titov | Select Imap*

#Изменения настрое CASMailboxPlan
Set-CASMailboxPlan  ExchangeOnlineEnterprise-2088d9ed-f24f-4ef2-b370-5cb7ecab1a91 -ImapEnabled:$false
Set-CASMailboxPlan  ExchangeOnlineEnterprise-2088d9ed-f24f-4ef2-b370-5cb7ecab1a91 -ImapEnabled:$true
