#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


# Как посмотреть какие retention policy применяются.

Get-mailbox| ft name,RetentionPolicy

# Посмотреть все Retention Policy
Get-RetentionPolicy

# Сделать так, чтобы показывало длинные поля в PowerShell.
$FormatEnumerationLimit=-1

# Посмотреть какие теги входят в политику.
Get-RetentionPolicy "Default MRM Policy" | fl  RetentionPolicyTagLinks 

# Посмотреть тэги и их действия.
Get-RetentionPolicyTag
Get-RetentionPolicyTag  | ft id,Type,RetentionAction


# Скрипт оработки Managed Folder Assistant.

$Mbx = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited
$Report = @()
ForEach ($M in $Mbx) {
   $LastProcessed = $Null
   Write-Host "Processing" $M.DisplayName
   $Log = Export-MailboxDiagnosticLogs -Identity $M.Alias -ExtendedProperties
   $xml = [xml]($Log.MailboxLog)  
   $LastProcessed = ($xml.Properties.MailboxTable.Property | ? {$_.Name -like "*ELCLastSuccessTimestamp*"}).Value   
   $ItemsDeleted  = $xml.Properties.MailboxTable.Property | ? {$_.Name -like "*ElcLastRunDeletedFromRootItemCount*"}
   If ($LastProcessed -eq $Null) {
      $LastProcessed = "Not processed"}
   $ReportLine = [PSCustomObject]@{
           User          = $M.DisplayName
           LastProcessed = $LastProcessed
           ItemsDeleted  = $ItemsDeleted.Value}      
    $Report += $ReportLine
  }
$Report | Select User, LastProcessed, ItemsDeleted


# Работа с Архивами, посмотреть архивы.

Get-Mailbox  -Archive | ft DisplayName,ArchiveName


# Работа информация по размеру ящика.
Get-MailboxStatistics -Identity "Bill Gates" | Select TotalItemSize

# Работа информация по размеру архива.
Get-MailboxStatistics -Identity "Bill Gates" -Archive


# Включить архив для ящика.
Enable-Mailbox "Elon  Musk" -Archive

# Задать свою Retention Policy.
Set-Mailbox "Elon  Musk" -RetentionPolicy CustomRP 

# Отключить архив.
Disable-Mailbox "Bill Gates"  -Archive


