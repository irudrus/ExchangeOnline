#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


#Получить события административного аудита.
Get-AdminAuditLogConfig
Search-AdminAuditLog
Search-AdminAuditLog -StartDate "07/20/2020 0:00:00 AM" | ft RunDate,Caller,CmdletName,ObjectModified,CmdletParameters  -AutoSize

$Search = Search-AdminAuditLog -StartDate "07/20/2020 0:00:00 AM"
$Search | C:\Users\iroot\Documents\GitHub\ExchangeOnlineScripts\8.1-Get-SimpleAuditLogReport.ps1 -Agree

#Конфигурация административного аудита.
#https://docs.microsoft.com/ru-ru/microsoft-365/compliance/search-the-audit-log-in-security-and-compliance?view=o365-worldwide

#Получить Mailbox Audit

Get-Mailbox sales | ft AuditEnabled,AuditOwner,AuditAdmin,AuditDelegate

Set-Mailbox sales -AuditEnabled $true -AuditOwner "Create,HardDelete,Move,MoveToDeletedItems,SoftDelete,Update"
Set-Mailbox sales -AuditEnabled $true -AuditAdmin "Create,HardDelete,Move,MoveToDeletedItems,SoftDelete,Update"
Set-Mailbox sales -AuditEnabled $true -AuditDelegate "Create,HardDelete,Move,MoveToDeletedItems,SoftDelete,Update"

Search-mailboxAuditLog sales -StartDate "07/01/20" -EndDate "07/22/20" -LogonTypes  Delegate -ShowDetails 

#Или через "search for mailboxes accessed by non-owners"
#Или через скрипты.


#UnifiedAuditLog


Get-AdminAuditLogConfig | fl UnifiedAuditLogIngestionEnabled 
Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true
Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $false



#UnifiedAuditLog

Get-OrganizationConfig | fl AuditDisabled 

Search-UnifiedAuditLog

$Audit = Search-UnifiedAuditLog -EndDate "07/23/20" -StartDate "07/21/20" -UserIds "admin@contoso8.ru" -ResultSize 5000
$ConvertAudit = $Audit | Select-Object -ExpandProperty AuditData | ConvertFrom-Json
$ConvertAudit | Select-Object CreationTime,UserId,Operation,Workload,ObjectID,SiteUrl,SourceFileName,ClientIP,UserAgent > C:\Data\2.txt

$ConvertAudit > C:\Data\2.txt 


