#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


#Команды для управления DKIM
Get-Command *DkimSigningConfig*

#Текущая конфигурация
Get-DkimSigningConfig -Identity contoso8.ru | fl Enabled,Selector1CNAME, Selector2CNAME
Get-DkimSigningConfig -Identity contoso8.ru | Format-List

#Включение DKIM
Set-DkimSigningConfig -Identity contoso8.ru -Enabled $true


#Формат записей.
selector1._domainkey  selector1-contoso8-ru._domainkey.contosorf.onmicrosoft.com
selector2._domainkey  selector2-contoso8-ru._domainkey.contosorf.onmicrosoft.com