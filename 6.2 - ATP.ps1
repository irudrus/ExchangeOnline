
#Стандартные настройки Safe links
Get-AtpPolicyForO365

#Список политик Safe links
Get-SafeLinksPolicy | fl name

#Правила применения политик
Get-SafeLinksRule
Get-SafeLinksRule | Format-Table -Auto Name,State,Priority,SafeLinksPolicy,Comments


#Safe Attachment Policy
Get-SafeAttachmentPolicy
Get-SafeAttachmentRule

#Anti Phish Policy
Get-AntiPhishPolicy

#Office 365 Advanced Threat Protection Recommended Configuration Analyzer (ORCA)
Install-Module -Name ORCA
Get-OrcaReport


Get-AdvancedThreatProtectionTrafficReport 
Get-AdvancedThreatProtectionTrafficReport | Out-GridView
Get-UrlTrace

Get-PhishFilterPolicy 