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
  Write-Host " " -NoNewline
  Return " "
}

#r
Function Reload-Profile
{
    .$profile
}

#s
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
