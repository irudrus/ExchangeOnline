#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


#Посмотреть, а есть ли что?
Get-OrganizationConfig | select RootPublicFolderMailbox 
Get-Mailbox -PublicFolder | select name,ExchangeGuid


#Создание почтовых ящиков.
New-Mailbox -PublicFolder -Name MasterHierarchy
New-Mailbox -PublicFolder -Name MoscowDocs


#Создание папок внутри ящиков.
New-PublicFolder -Name Arch -Mailbox MoscowDocs
New-PublicFolder -Name Common -Mailbox MoscowDocs


#Получить статистику по папкам.
Get-PublicFolder -Recurse | Get-PublicFolderStatistics | sort MailboxOwnerID | ft Name,ItemCount,MailboxOwnerID -AutoSize
Get-PublicFolder -Recurse | Get-PublicFolderStatistics | sort MailboxOwnerID | ft Name,ItemCount,*size,*MailboxOwnerID -AutoSize

#Данные по подключению.
Get-OrganizationConfig | select PublicFolderShowClientControl
#Если перевести в true можно будет контролировать на ящике.
Set-CASMailbox ben -PublicFolderClientAccess $true


#При желании можно сделать Mail Enable PF. Но руками.

Enable-MailPublicFolder -Identity "\Arch" 
Enable-MailPublicFolder -Identity "\Arch"  -HiddenFromAddressListsEnabled $true
Get-MailPublicFolder | ft identity,primarySmtpAddress,HiddenFromAddressListsEnabled -AutoSize


#Работа с разрешениями
Get-PublicFolder  -Recurse | Get-PublicFolderClientPermission
Add-PublicFolderClientPermission -Identity "\Arch" -user test -AccessRights PublishingEditor