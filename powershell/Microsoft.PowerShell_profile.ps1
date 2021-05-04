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

#a
Function Add-StarsToTheBeginningAndTheEndOfAStringIfNeeded
{
    Param(
        [Parameter(Mandatory=$true)] [String] $String
    )

    If ($String.StartsWith("*") -eq $false) {
        $String = $("*" + $String)
    }

    If ($String.EndsWith("*") -eq $false) {
        $String = $($String + "*")
    }

    Return $String
}

#g
#@see https://sid-500.com/2019/07/30/powershell-retrieve-list-of-domain-computers-by-operating-system/
Function Get-ADComputerClientList
{
    Get-ADComputer -Filter { (OperatingSystem -notlike "*server*") -and (Enabled -eq $true) } `
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
    Get-ADComputer -Filter { (PrimaryGroupId -eq 516) -or (PrimaryGroupId -eq 521) } `
    -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address,primarygroupid |
    Sort-Object -Property Name |
    Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address,PrimaryGroupId | Format-Table
}

#@see: https://sid-500.com/2019/07/30/powershell-retrieve-list-of-domain-computers-by-operating-system/
Function Get-ADComputerList
{
    Get-ADComputer -Filter { (Enabled -eq $true) } `
    -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address,primarygroupid |
    Sort-Object -Property Name |
    Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address,PrimaryGroupId | Format-Table
}

#@see https://sid-500.com/2019/07/30/powershell-retrieve-list-of-domain-computers-by-operating-system/
Function Get-ADComputerServerList
{
    Get-ADComputer -Filter { (OperatingSystem -like "*server*") -and (Enabled -eq $true) } `
    -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address,primarygroupid |
    Sort-Object -Property Name |
    Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address,PrimaryGroupId | Format-Table
}

Function Get-IsSoftwareInstalled
{
    Param(
        [Parameter(Mandatory=$true)] [String] $SoftwareName
    )

    #regular way to check
    $isInstalled = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*$SoftwareName*"  }) -ne $null

    #if we are running a 64bit windows, there is a place for 32bit software
    if (-Not $isInstalled) {
        #check if we are running 64 bit windows
        if (Test-Path HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall) {
            $isInstalled = (Get-ItemProperty HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*$SoftwareName*"  }) -ne $null
        }
    }

    #there is one legacy place left
    if (-Not $isInstalled) {
        $isInstalled = (Get-WmiObject -Class Win32_Product | WHERE { $_.Name -like "*$ProcessName*"  })
    }

    if (-Not $isInstalled) {
        Write-Host $("Software >>" + $SoftwareName + "<< is not installed.")
    } Else {
        Write-Host $("Software >>" + $SoftwareName + "<< is installed.")
    }
}

#@see: https://sid-500.com/2020/05/23/video-powershell-cmdlets-as-a-replacement-for-ping-arp-traceroute-and-nmap/
Function Get-ListOfLocalOpenPorts
{
    Get-NetTCPConnection -State Established,Listen | Sort-Object LocalPort
}

#k
#@see: https://github.com/mikemaccana/powershell-profile/blob/master/unix.ps1
Function Kill-Process
{
    Param(
        [Parameter(Mandatory=$true)] [String] $ProcessName
    )

    Get-Process $ProcessName-ErrorAction SilentlyContinue | Stop-Process
}

#l
Function List-UserOnHost
{
    Param (
        [Parameter(Mandatory=$true)] [String] $hostname
    )
    #contains array of objects like:
    #>>USERNAME SESSIONNAME ID STATE IDLE TIME LOGON TIME
    #>>randomnote1 console 1 Active none 8/14/2019 6:52 AM
    $arrayOfResultObjects = Invoke-Expression ("quser /server:$hostname");

    #contains array of lines like:
    #>>USERNAME,SESSIONNAME,ID,STATE,IDLE TIME,LOGON TIME
    #>>randomnote1,console,1,Active,none,8/14/2019 6:52 AM
    $arrayOfCommaSeparatedValues = $arrayOfResultObjects | ForEach-Object -Process { $_ -replace '\s{2,}',',' }

    $arrayOfUserObjects = $arrayOfCommaSeparatedValues| ConvertFrom-Csv

    Write-Host $(":: Aktueller Host: " + $currentTerminalServerName)
    #@see: https://devblogs.microsoft.com/scripting/automating-quser-through-powershell/
    #@see: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/query-user
    $arrayOfUserObjects | Where-Object { ($_.USERNAME -like "*$userNameToFilterAgainstOrNull*") -or ($_.BENUTZERNAME -like "*$userNameToFilterAgainstOrNull*") } | Format-Table
}

#m
Function Mirror-TerminalServerUserSession
{
    Param(
        [Parameter(Mandatory=$true)] [String] $TerminalServerHostName,
        [Parameter(Mandatory=$true)] [String] $SessionId
    )

    mstsc.exe /v:$TerminalServerHostName /shadow:$SessionId /control
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

Function Replace-GermanUmlauts
{
    Param(
        [Parameter(Mandatory=$true)] [String] $String
    )

    Return ($String.Replace('ä','ae').Replace('Ä','Ae').Replace('ö','oe').Replace('Ö','Oe').Replace('ü','ue').Replace('Ü','Ue'))
}

#s
Function Search-ADComputerList
{
    Param(
        [Parameter(Mandatory=$true)] [String] $Name
    )

    $Name = Add-StarsToTheBeginningAndTheEndOfAStringIfNeeded ($Name)

    Get-ADComputer -Filter { (Enabled -eq $true) -and (Name -like $Name) } `
    -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address,primarygroupid |
    Sort-Object -Property Name |
    Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address,PrimaryGroupId | Format-Table
}

Function Search-ADUserByName
{
    Param(
        [Parameter(Mandatory=$true)] [String] $Name
    )

    $Name = Add-StarsToTheBeginningAndTheEndOfAStringIfNeeded ($Name)

    Get-ADUser -Filter {(Name -like $Name)}
}

Function Search-CommandByName
{
    Param(
        [Parameter(Mandatory=$true)] [String] $CommandName
    )

    $CommandName = Add-StarsToTheBeginningAndTheEndOfAStringIfNeeded ($CommandName)

    Get-Command -Verb Get -Noun $CommandName
}

Function Search-ProcessByName
{
    Param(
        [Parameter(Mandatory=$true)] [String] $ProcessName
    )

    $ProcessName = Add-StarsToTheBeginningAndTheEndOfAStringIfNeeded ($ProcessName)

    Get-Process | Where-Object { $_.ProcessName -like $ProcessName }
}

Function Show-IpAndMacAddressFromComputer
{
    #@see: https://gallery.technet.microsoft.com/scriptcenter/How-do-I-get-MAC-and-IP-46382777
    Param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)] [string[]]$ListOfComputerName
    )

    ForEach ($ComputerName in $ListOfComputerName) {
        If (Test-Connection -Cn $ComputerName -quiet) {
            $IpAddressToString = ([System.Net.Dns]::GetHostByName($ComputerName).AddressList[0]).IpAddressToString
            $IPMAC = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $ComputerName
            $MacAddress = ($IPMAC | where { $_.IpAddress -eq $IpAddressToString }).MACAddress
 
            Write-Host ($ComputerName + ": IP Address >>" + $IpAddressToString + "<<, MAC Address >>" + $MacAddress + "<<.")
        } Else {
            Write-Host ("Maschine is offline >>" + $ComputerName + "<<.") -BackgroundColor Red
        }
    }
}

Function Show-Links
{
    Param(
        [Parameter(Mandatory=$true)] [String] $directoryPath
    )

    Get-Childitem $directoryPath | Where-Object {$_.LinkType} | Select-Object FullName,LinkType,Target
}

#t
Function Tail-Logs
{
    Param(
        [Parameter(Mandatory=$false)] [String] $pathToTheLogs = "C:\Windows\logs\*\"
    )

        if (-Not $pathToTheLogs.endsWith(".log")) {
            $pathToTheLogs += "*.log"
        }

        Get-Content $pathToTheLogs -tail 10 -wait
}
#eo functions

#bo alias
#eo alias

#bo load local/confidential code
If (Test-Path $localConfigurationFilePath) {
    . $localConfigurationFilePath
}
#eo load local/confidential code
