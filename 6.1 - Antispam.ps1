#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


# Работа с листами блокировки\разрешения.

Get-HostedConnectionFilterPolicy

Set-HostedConnectionFilterPolicy -Identity Default -IPAllowList 192.168.1.10,192.168.1.23 -IPBlockList 10.10.10.0/25,172.17.17.0/24

Set-HostedConnectionFilterPolicy -Identity Default -IPAllowList @{Add="192.168.2.10","192.169.3.0/24","192.168.4.1-192.168.4.5";Remove="10.10.10.0/25"}

Set-HostedConnectionFilterPolicy -Identity Default -IPBlockList @{Remove="172.17.17.0/24"}


# Работа  Anti-malware (Protection )

Get-MalwareFilterPolicy | fl 

Set-MalwareFilterPolicy -Identity "Default" ` -Action DeleteAttachmentAndUseDefaultAlertText -EnableInternalSenderNotifications $true `
 -EnableExternalSenderNotifications $true -EnableExternalSenderAdminNotifications $true -EnableInternalSenderAdminNotifications $true `
 -InternalSenderAdminAddress me@rudilya.ru -ExternalSenderAdminAddress irud@live.ru


# Добавление своего расширения.

$FileTypesAdd = Get-MalwareFilterPolicy -Identity Default | Select-Object -Expand FileTypes  
$FileTypesAdd += "pptm"  
Set-MalwareFilterPolicy -Identity Default -EnableFileFilter $true -FileTypes $FileTypesAdd


# Работа Allow/Blocked Senders/Domains  (Default spam filter policy (always ON)


Get-HostedContentFilterPolicy | fl 
Get-HostedContentFilterPolicy  | select -ExpandProperty AllowedSenderDomains
Get-HostedContentFilterPolicy  | select -ExpandProperty BlockedSenderDomains

Set-HostedContentFilterPolicy “Default” -AllowedsenderDomains  miaton.ru 

#Работа с карантином
Get-QuarantineMessage |fl Identity,SenderAddress,Subject,RecipientAddress
Get-QuarantineMessage -StartReceivedDate 06/02/2020 -EndReceivedDate 06/21/2020
Get-QuarantineMessage | Release-QuarantineMessage -ReleaseToAll
Release-QuarantineMessage -Identity c14401cf-aa9a-465b-cfd5-08d0f0ca37c5\4c2ca98e-94ea-db3a-7eb8-3b63657d4db7 -ReleaseToAll

#Данные по отдельому ящику.
Get-MailboxJunkEmailConfiguration -Identity "test"
Set-MailboxJunkEmailConfiguration "test" -BlockedSendersAndDomains @{Remove="me@rudilya.ru"}