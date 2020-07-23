#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


# Получить общую информацию.

Get-MessageTrace

Get-MessageTrace  -StartDate 06/09/2020 -EndDate 06/16/2020


# Получить информацию по конкретному письму.

Get-MessageTrace -SenderAddress test@contoso8.ru -StartDate 06/12/2020 -EndDate 06/16/2020  | Where-Object {$_.Subject -eq "TEST505"}

 
 # Получить конкретную  информацию по конкретному письму.


Get-MessageTrace -SenderAddress test@contoso8.ru -StartDate 06/12/2020 -EndDate 06/16/2020  | Where-Object {$_.Subject -eq "TEST505"} | Get-MessageTraceDetail


# Примеры фильтрафии 

Get-MessageTrace -SenderAddress test@contoso8.ru -RecipientAddress a.bachinova@miaton.ru  -StartDate 06/10/2020 -EndDate 07/11/2020 | `
Format-list -Property Received,SenderAddress,Status,MessageTraceId,Subject



# Информация о старых письмах

Start-HistoricalSearch -ReportTitle "Test Search" -StartDate 06/01/2020 -EndDate 06/16/2020  -ReportType MessageTrace -SenderAddress test@contoso8.ru -NotifyAddress test@contoso8.ru

Start-HistoricalSearch -ReportTitle "Test Search 2" -StartDate 06/01/2020 -EndDate 06/16/2020  -ReportType MessageTraceDetail -SenderAddress test@contoso8.ru -NotifyAddress test@contoso8.ru

Get-HistoricalSearch 

<#
ATPReport: Advanced Threat Protection File Types Report and Advanced Threat Protection Message Disposition Report
ATPV2: Exchange Online Protection and Advanced Threat Protection E-mail Malware Report.
ATPDocument: Advanced Threat Protection Content Malware Report for files in SharePoint, OneDrive and Microsoft Teams.
DLP: Data Loss Prevention Report.
Malware: Malware Detections Report.
MessageTrace: Message Trace Report.
MessageTraceDetail: Message Trace Details Report.
Phish: Exchange Online Protection and Advanced Threat Protection E-mail Phish Report.
SPAM: SPAM Detections Report.
Spoof: Spoof Mail Report.
TransportRule: Transport or Mail FLow Rules Report.
UnifiedDLP: Unified Data Loss Prevention Report.
#>


Get-HistoricalSearch "e64c7cfe-0e84-4e6b-84d8-dd9b3be8f5f8" | fl 

