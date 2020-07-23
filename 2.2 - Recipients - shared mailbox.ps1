#admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
-Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

Get-Mailbox -RecipientTypeDetails SharedMailbox

New-Mailbox -Shared -Name "Sales Department" -DisplayName "Sales Department" -Alias Sales -PrimarySmtpAddress "ContosoSales@contoso8.ru" 

# Все настройки можно сделать в ECP.
# Ящик подключается автоматически для тех у кого есть полный доступ.
# Права SendAS не включаются в FullAccess.

Get-Mailbox "Sales Department"

# Дать права через PowerShell.

Add-MailboxPermission "Sales Department" –User test –AccessRights FullAccess –InheritanceType all
Add-RecipientPermission "Sales Department" –Trustee test –AccessRights SendAs –confirm:$false
Add-RecipientPermission "Sales Department" –Trustee test –AccessRights SendOnBehalf –confirm:$false

# Проверь права через PowerShell.

Get-MailboxPermission "Sales Department"  | Where-Object { ($_.IsInherited -eq $False) -and -not ($_.User -like “NT AUTHORITY\SELF”) } | `
Select-Object Identity, user, AccessRights

Get-RecipientPermission "Sales Department"  | Where-Object {($_.IsInherited -eq $False) -and -not ($_.Trustee -like “NT AUTHORITY\SELF”) } | `
Select-Object Trustee, AccessRights

# Конвертация ящиков

Set-Mailbox "Sales Department"  –Type shared
Set-Mailbox "Sales Department" –Type Regular

# Решение проблемы SendAS
# Особенности https://www.michev.info/Blog/Post/1430

# Сохранение копии в исходном ящике.

Set-mailbox "Sales Department" -MessageCopyForSentAsEnabled $True
Get-Mailbox -Identity "Sales Department" | select MessageCopy*
Get-Mailbox -RecipientTypeDetails shared | Where-Object{$_.messagecopyforsentasenabled -eq "true"}

# Отключение автомапинга.
Remove-MailboxPermission -Identity "Sales Department" -User test -AccessRights FullAccess
Add-MailboxPermission -Identity "Sales Department" -User test -AccessRights FullAccess -AutoMapping:$false 

# Перенаправление писем.
Set-Mailbox -Identity "Sales Department" -ForwardingAddress test@contoso8.ru  -DeliverToMailboxAndForward $true