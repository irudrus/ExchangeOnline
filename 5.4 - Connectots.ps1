#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


#Посмотреть коннекторы

Get-OutboundConnector 
Get-InboundConnector 


#Создание Outbound Connector
New-OutboundConnector -Name "Miaton Outbound Connector" -RecipientDomains miaton.ru -TlsSettings DomainValidation `
-TlsDomain *.miaton.ru -SmartHosts 87.117.134.148 -UseMXRecord $false


#Создание Inbound Connector
New-InboundConnector -Name "Miaton Inbound Connector" -SenderDomains miaton.ru -SenderIPAddresses 87.117.134.148 `
-RestrictDomainsToIPAddresses $true -RequireTLS $true -TlsSenderCertificateName *.miaton.ru


#Удалить коннекторы.
Get-OutboundConnector | Remove-OutboundConnector
Get-InboundConnector | Remove-InboundConnector

#Создание Inbound Connector c неправильным IP
New-InboundConnector -Name "Miaton Inbound Connector" -SenderDomains miaton.ru -SenderIPAddresses 87.117.134.111 `
-RestrictDomainsToIPAddresses $true -RequireTLS $true -TlsSenderCertificateName *.miaton.ru


#Your message couldn't be delivered because there is a partner connector configured that matched the message's recipient domain.
#The connector had either the RestrictDomainsToIPAddresses or RestrictDomainsToCertificate set.


<#
telnet contoso8-ru.mail.protection.outlook.com 25 
ehlo
mail from:printer@contoso8.ru 
rcpt to:test@contoso8.ru
rcpt to:irud@miaton.ru
Data
Subject:test
#>