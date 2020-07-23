#admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
-Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking



# Работа с почтовых контактом.

New-MailContact -ExternalEmailAddress "irud@miaton.ru" -FirstName Ilya -LastName Rud -Name "Ilya Rud" -Alias irud
Set-MailContact -Identity irud -ModerationEnabled $true  -ModeratedBy "Bill Gates" -MailTip "The message will be moderated!"
Get-MailContact irud | fl 

# Работа с mailuser.

$password = Read-Host "Enter password" -AsSecureString;
New-MailUser -name Vasya -Password $password -ExternalEmailAddress "Vasya@test.com" -MicrosoftOnlineServicesID vasya@contoso8.ru


# Удаление mailuser и контактов.

Remove-MailUser -Identity Vasya -Confirm:$false
Remove-MailContact irud -Confirm:$false


# Работа с Distribution List

Get-DistributionGroup

New-DistributionGroup -Name "IT Administrators" -Alias itadmin -MemberJoinRestriction Closed `
-ModerationEnabled:$false -CopyOwnerToMember:$true  -PrimarySmtpAddress itadmin@contoso8.ru 

Get-DistributionGroupMember -Identity "IT Administrators" 

Add-DistributionGroupMember -Identity "IT Administrators" -Member "test" 
Remove-DistributionGroupMember -Identity "IT Administrators" -Member "test" -Confirm:$false

Get-DistributionGroup "IT Administrators" | fl RequireSenderAuthenticationEnabled

Set-DistributionGroup "IT Administrators" -RequireSenderAuthenticationEnabled:$false

# Manage Distribution Group using PowerShell in Office 365
# https://o365info.com/manage-distribution-group-using-powershell-in-office-365-adding-members-to-existing-distribution-group-part-3-5/


# Как посмотреть в какие группы входит пользователь.

$DN = (Get-Mailbox -Identity test).DistinguishedName
Get-DistributionGroup -Filter "Members -eq '$DN'"

# Работа с Dynamic Distribution List

New-DynamicDistributionGroup -Name "Operations" -Alias "Operations" -RecipientFilter {((RecipientType -eq 'UserMailbox') -and (ExtensionCustomAttribute1 -eq 'Operations' ))}
Set-Mailbox test -ExtensionCustomAttribute1 Operations
Set-Mailbox test -ExtensionCustomAttribute1 $null

# Посмотреть членство  Dynamic Distribution List

$i = Get-DynamicDistributionGroup "Operations" 
Get-Recipient -RecipientPreviewFilter $i.RecipientFilter

# Работа с mail enabled security groups.

New-DistributionGroup -Type Security -Name "File Server Managers" -Alias fsadmin -Members "test","bg" -CopyOwnerToMember -PrimarySmtpAddress "FileServer@contoso8.ru"
