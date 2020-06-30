#bo general settings
#set default start location
Set-Location C:\

#change how powershell does tab completion
#@see: http://stackoverflow.com/questions/39221953/can-i-make-powershell-tab-complete-show-me-all-options-rather-than-picking-a-sp
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete
#eo general settings

#bo variables
$isElevated = [System.Security.Principal.WindowsPrincipal]::New(
    [System.Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole(
    [System.Security.Principal.WindowsBuiltInRole]::Administrator
)

$configurationSourcePath = (Split-Path $profile -Parent)

$localConfigurationFilePath = $($configurationSourcePath + "\local.profile.ps1")
#eo variables

#bo functions
#@see: https://github.com/gummesson/kapow/blob/master/themes/bashlet.ps1

#g
#@see https://sid-500.com/2019/07/30/powershell-retrieve-list-of-domain-computers-by-operating-system/
Function Get-ADComputerClientList
{
    Get-ADComputer -Filter 'operatingsystem -notlike "*server*" -and enabled -eq "true"' `
    -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address |
    Sort-Object -Property Name |
    Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address
}

#@see: https://sid-500.com/2019/07/30/powershell-retrieve-list-of-domain-computers-by-operating-system/
#@see: https://adsecurity.org/?p=873
Function Get-ADComputerDCList
{
    #primary group id:
    #    515 -> domain computer
    #    516 -> domain controller writeable (server)
    #    521 -> domain controller readable (client)
    Get-ADComputer -Filter '(primarygroupid -eq "516") -or (primarygroupid -eq "521")' `
    -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address,primarygroupid |
    Sort-Object -Property Name |
    Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address,PrimaryGroupId | Format-Table
}

#@see: https://sid-500.com/2019/07/30/powershell-retrieve-list-of-domain-computers-by-operating-system/
Function Get-ADComputerList
{
    Get-ADComputer -Filter 'enabled -eq "true"' `
    -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address,primarygroupid |
    Sort-Object -Property Name |
    Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address,PrimaryGroupId | Format-Table
}

#@see https://sid-500.com/2019/07/30/powershell-retrieve-list-of-domain-computers-by-operating-system/
Function Get-ADComputerServerList
{
    Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' `
    -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address,primarygroupid |
    Sort-Object -Property Name |
    Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address,PrimaryGroupId | Format-Table
}

#@see: https://sid-500.com/2020/05/23/video-powershell-cmdlets-as-a-replacement-for-ping-arp-traceroute-and-nmap/
Function Get-ListOfLocalOpenPorts
{
    Get-NetTCPConnection -State Established,Listen | Sort-Object LocalPort
}

#k
#@see: https://github.com/mikemaccana/powershell-profile/blob/master/unix.ps1
Function Kill-Process($name) {
	Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

#p
Function Prompt
{
    $promptColor = If ($isElevated) { "Red" } Else { "DarkGreen"}

  Write-Host "$env:username" -NoNewline -ForegroundColor $promptColor
  Write-Host "@" -NoNewline -ForegroundColor $promptColor
  Write-Host "$env:computername" -NoNewline -ForegroundColor $promptColor
  Write-Host " " -NoNewline
  #Write-Host $(Set-HomeDirectory("$pwd")) -ForegroundColor Yellow
  Write-Host $(Get-Location) -NoNewLine
  Write-Host ">" -NoNewline
  Return " "
}

#r
Function Reload-Profile
{
    . "$profile"
}

Function Replace-GermanUmlauts ($string)
{
    Return ($string.Replace('ä','ae').Replace('Ä','Ae').Replace('ö','oe').Replace('Ö','Oe').Replace('ü','ue').Replace('Ü','Ue'))
}

#s
Function Search-ADUserByName ($name)
{
    If ($name.StartsWith("*") -eq $false) {
        $name = $("*" + $name)
    }

    If ($name.EndsWith("*") -eq $false) {
        $name = $($name + "*")
    }

    Get-ADUser -Filter {(Name -like $name)}
}

Function Show-Links($path)
{
	Get-Childitem $path | Where-Object {$_.LinkType} | Select-Object FullName,LinkType,Target
}
#eo functions

#bo alias
#eo alias

If (Test-Path $localConfigurationFilePath) {
    .$localConfigurationFilePath
}