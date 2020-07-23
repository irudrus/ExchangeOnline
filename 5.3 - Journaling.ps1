#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


#Список командлетов по журналированию.
Get-Command *Journal*


#Куда отпарвлять NDR
Get-TransportConfig | fl JournalingReportNdrTo


#Создание почтового ящика Journal NDR.

New-Mailbox -Alias NDR -Name NDR -FirstName NDR -LastName NDR -DisplayName "NDR" `
-MicrosoftOnlineServicesID NDR@contoso8.ru -Password (ConvertTo-SecureString -String 'P@ssw0rd212121' -AsPlainText -Force) `
-ResetPasswordOnNextLogon $false -PrimarySmtpAddress NDR@contoso8.ru

#Куда отпарвлять NDR
Set-TransportConfig -JournalingReportNdrTo NDR@contoso8.ru


#Новое правило журналирования

New-MailContact -ExternalEmailAddress "irud@miaton.ru" -FirstName Ilya -LastName Rud -Name "Ilya Rud" -Alias irud


New-JournalRule -Name "Journal External Emails" -JournalEmailAddress "irud@miaton.ru" -Scope External -Enabled $True


#Список правил журналирования.
Get-JournalRule 

