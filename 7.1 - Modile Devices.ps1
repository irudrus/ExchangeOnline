#Подключение к Exchange Online
# admin@contosorf.onmicrosoft.com

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

# Получить политики Active Sync
Get-ActiveSyncMailboxPolicy

# Получить список устройств.
Get-MobileDevice

$(foreach($user in Get-Mailbox){Write-Output $user.alias; Get-MobileDeviceStatistics -Mailbox $user.alias | Format-Table FirstSyncTime,LastSuccessSync,DeviceId,DeviceModel,DeviceOS,DeviceAccessState -AutoSize -Wrap})


Get-Mailbox ben  | ForEach {Get-MobileDeviceStatistics -Mailbox:$_.Identity | ft DeviceID,DeviceUserAgent,DevicePolicyApplied,Status,LastSuccessSync,LastPolicyUpdateTime }


#Поведение для новых устрйоств.
Get-ActiveSyncOrganizationSettings