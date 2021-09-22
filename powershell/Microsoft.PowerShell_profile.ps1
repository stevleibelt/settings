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

Function Get-UpTime
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false,Position=0)] [String[]] $ListOfComputerName=$null
    )

    $DataTable = @()
    $RequestForLocalHost = ($ListOfComputerName -eq $null)

    If ($RequestForLocalHost -eq $true) {
        $DateObject = (get-date) - (gcim Win32_OperatingSystem).LastBootUpTime
        $DataTable += [Pscustomobject]@{ComputerName = "LocalHost";Days = $DateObject.Days; Hours = $DateObject.Hours; Minutes = $DateObject.Minutes; Seconds= $DateObject.Seconds}
    } Else {
        Write-Host ":: Fetching uptime for remote computers."

        ForEach ($CurrentComputerName in $ListOfComputerName) {
            Write-Host -NoNewLine "."

            $DateObject = Invoke-Command -ComputerName $CurrentComputerName -ScriptBlock {(get-date) - (gcim Win32_OperatingSystem).LastBootUpTime}
            $DataTable += [Pscustomobject]@{ComputerName = "$CurrentComputerName";Days = $DateObject.Days; Hours = $DateObject.Hours; Minutes = $DateObject.Minutes; Seconds= $DateObject.Seconds}
        }

        Write-Host ""
    }

    $DataTable | Format-Table
}

Function Get-UserLogon
{
    Param (
        [Parameter(Mandatory=$true)] [String] $ComputerName,
        [Parameter(Mandatory=$false)] [Int] $Days = 10
    )

    $ListOfEventSearches = @(
        <#
        @see: https://social.technet.microsoft.com/wiki/contents/articles/51413.active-directory-how-to-get-user-login-history-using-powershell.aspx
        Either this is not working on my environment or not working in general.
        I can't find any log entry with a UserName or something user related when searching for this id's in that log name.

        I've decided to keep it in and have a look on it again by figuring out how to use the existing code with the logic of the following post:
        https://adamtheautomator.com/user-logon-event-id/
        @{
            'ID' = 4624
            'LogName' = 'Security'
            'EventType' = 'SessionStart'
        }
        @{
            'ID' = 4778
            'LogName' = 'Security'
            'EventType' = 'RdpSessionReconnect'
        }
        #>
        @{
            'ID' = 7001
            'LogName' = 'System'
            'EventType' = 'Logon'
        }
    )
    $ListOfResultObjects = @{}
    $StartDate = (Get-Date).AddDays(-$Days)

    Write-Host $(":: Fetching event logs for the last >>" + $Days + "<< days. This will take a while.")
    ForEach ($EventSearch in $ListOfEventSearches) {
        Write-Host $("   Fetching events for id >>" + $EventSearch.ID + "<<, log name >>" + $EventSearch.LogName + "<<.")
        $ListOfEventLogs = Get-EventLog -ComputerName $ComputerName -InstanceId $EventSearch.ID -LogName $EventSearch.LogName -After $StartDate

        Write-Host $("   Processing >>" + $ListOfEventLogs.Count + "<< entries.")

        If ($ListOfEventLogs -ne $null) {
            ForEach ($EventLog in $ListOfEventLogs) {

                $StoreEventInTheResultList = $true

                If ($EventLog.InstanceId -eq 7001) {
                    $EventType = "Logon"
                    $User = (New-Object System.Security.Principal.SecurityIdentifier $EventLog.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
                <#
                Same reason as mentioned in the $ListOfEventSearches
                } ElseIf ($EventLog.InstanceId -eq 4624) {
                    If ($EventLog.ReplacementStrings[8] -eq 2) {
                        $EventType = "Local Session Start"
                        $User = (New-Object System.Security.Principal.SecurityIdentifier $EventLog.ReplacementStrings[5]).Translate([System.Security.Principal.NTAccount])
                    } ElseIf ($EventLog.ReplacementStrings[8] -eq 10) {
                        $EventType = "Remote Session Start"
                        $User = (New-Object System.Security.Principal.SecurityIdentifier $EventLog.ReplacementStrings[5]).Translate([System.Security.Principal.NTAccount])
                    } Else {
                        $StoreEventInTheResultList = $false
                    }
                } ElseIf ($EventLog.InstanceId -eq 4778) {
                    $EventType = "RDPSession Reconnect"
                    $User = (New-Object System.Security.Principal.SecurityIdentifier $EventLog.ReplacementStrings[5]).Translate([System.Security.Principal.NTAccount])
                #>
                } Else {
                    $StoreEventInTheResultList = $false
                }

                If ($StoreEventInTheResultList -eq $true) {

                    $ResultListKey = $User.Value

                    If ($ListOfResultObjects.ContainsKey($ResultListKey)) {
                        $ResultObject = $ListOfResultObjects[$ResultListKey]

                        If ($ResultObject.Time -lt $EventLog.TimeWritten ) {
                            $ResultObject.Time = $EventLog.TimeWritten

                            $ListOfResultObjects[$ResultListKey] = $ResultObject
                        }
                    } Else {

                        $ResultObject = New-Object PSObject -Property @{
                            Time = $EventLog.TimeWritten
                            'Event Type' = $EventType
                            User = $User
                        }

                        $ListOfResultObjects.Add($ResultListKey, $ResultObject)
                    }
                }
            }
        }
    }

    If ($ListOfResultObjects -ne $null) {
        <#
        We are doing evil things. I have no idea how to output and sort the existing list.
        That is the reason why we create an array we can output and sort easily.
        #>
        $ArrayOfResultObjects = @()

        ForEach ($key in $ListOfResultObjects.Keys) {
            $ArrayOfResultObjects += $ListOfResultObjects[$key]
        }
        Write-Host $(":: Dumping >>" + $ListOfResultObjects.Count + "<< event logs.")
        $ArrayOfResultObjects | Select Time,"Event Type",User | Sort Time -Descending

    } Else {
        Write-Host ":: Could not find any matching event logs."
    }
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

    Return ($String.Replace('�','ae').Replace('�','Ae').Replace('�','oe').Replace('�','Oe').Replace('�','ue').Replace('�','Ue'))
}

#@see: https://4sysops.com/archives/how-to-reset-an-active-directory-password-with-powershell/
Function Reset-ADUserPassword
{
    Param(
        [Parameter(Mandatory=$true)] [String] $UserName,
        [Parameter(Mandatory=$true)] [String] $Password,
        [Parameter(Mandatory=$false)] [Bool] $ChangeAfterLogin = $false
    )

    $SecuredPassword = ConvertTo-SecureString $Password -AsPlanText -Force

    Set-ADAccountPassword -Identity $UserName -NewPassword $SecuredPassword -Reset

    If ($ChangeAfterLogin -eq $true) {
        Set-ADUser -Identity $UserName -ChangePasswordAtLogon $true
    }
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

    Get-ADUser -Filter {(Name -like $Name)} -Properties SamAccountName,Name,EmailAddress,Enabled,ObjectGUID,SID | SELECT SamAccountName,Name,EmailAddress,Enabled,ObjectGUID,SID
}

Function Search-ADUserPathOnComputerNameList
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)] [String[]] $ListOfComputerName,
        [Parameter(Mandatory=$false,Position=1)] [String[]] $UserNameToFilterAgainst=$null
    )

    ForEach ($CurrentComputerName in $ListOfComputerName) {
        #contains array of objects like:
        #>>USERNAME SESSIONNAME ID STATE IDLE TIME LOGON TIME
        #>>randomnote1 console 1 Active none 8/14/2019 6:52 AM
	    $ArrayOfResultObjects = Get-ChildItem -Path ("\\" + $CurrentComputerName + "\c$\Users")

        #contains array of lines like:
        #>>Mode,LastWriteTime,Length,Name
        #>>d-----       15.06.2020     09:21                mustermann
        If ($UserNameToFilterAgainstOrNull -eq $null) {
            Write-Host $(":: Computer name: " + $CurrentComputerName)
            $ArrayOfResultObjects | Format-Table
        } Else {
            #check if the name is inside this array to only print the current terminal server when needed, else be silent.
            If ($ArrayOfResultObjects -like "*$UserNameToFilterAgainstOrNull*") {
                Write-Host $(":: Computer name: " + $CurrentComputerName)
                #@see: https://devblogs.microsoft.com/scripting/automating-quser-through-powershell/
                #@see: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/query-user
                $ArrayOfResultObjects | Where-Object { ($_.NAME -like "*$UserNameToFilterAgainstOrNull*")} | Format-Table
            }
        }
    }
}

Function Search-ADUserSessionOnComputerNameList
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)] [String[]] $ListOfComputerName,
        [Parameter(Mandatory=$false,Position=1)] [String[]] $UserNameToFilterAgainst=$null
    )

    ForEach ($CurrentComputerName in $ListOfComputerName) {
        #contains array of objects like:
        #>>USERNAME SESSIONNAME ID STATE IDLE TIME LOGON TIME
        #>>randomnote1 console 1 Active none 8/14/2019 6:52 AM
        $ArrayOfResultObjects = Invoke-Expression ("quser /server:$CurrentComputerName");

        #contains array of lines like:
        #>>USERNAME,SESSIONNAME,ID,STATE,IDLE TIME,LOGON TIME
        #>>randomnote1,console,1,Active,none,8/14/2019 6:52 AM
        $ArrayOfCommaSeparatedValues = $ArrayOfResultObjects | ForEach-Object -Process { $_ -replace '\s{2,}',',' }

        $ArrayOfUserObjects = $ArrayOfCommaSeparatedValues| ConvertFrom-Csv

        If ($UserNameToFilterAgainstOrNull -eq $null) {
            Write-Host $(":: Computer name: " + $currentTerminalServerName)
            $ArrayOfUserObjects | Format-Table
        } Else {
            #check if the name is inside this array to only print the current terminal server when needed, else be silent.
            If ($ArrayOfResultObjects -like "*$UserNameToFilterAgainstOrNull*") {
                Write-Host $(":: Computer name: " + $currentTerminalServerName)
                #@see: https://devblogs.microsoft.com/scripting/automating-quser-through-powershell/
                #@see: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/query-user
                $ArrayOfUserObjects | Where-Object { ($_.USERNAME -like "*$userNameToFilterAgainstOrNull*") -or ($_.BENUTZERNAME -like "*$userNameToFilterAgainstOrNull*") } | Format-Table
            }
        }
    }
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

#@see: https://www.powershellbros.com/test-credentials-using-powershell-function/
Function Test-ADCredential
{
    $DirectoryRoot = $null
    $Domain = $null
    $Password = $null
    $UserName = $null

    Try {
        $Credential = Get-Credential -ErrorAction Stop
    } Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "Failed to validate credentials with error message >>$ErrorMessage<<."

        Pause
        Break
    }

    Try {
        $DirectoryRoot = "LDAP://" + ([ADSI]'').distinguishedName
        $Password = $Credential.GetNetworkCredential().password
        $UserName = $Credential.username

        $Domain = New-Object System.DirectoryServices.DirectoryEntry($DirectoryRoot,$UserName,$Password)
    } Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "Faild to fetch the domain object from directory service with error message >>$ErrorMessage<<."

        Continue
    }

    If (!$Domain) {
        Write-Warning "An unexpected error has happend. Could not fetch the domain object from directory service."
    } Else {
        If ($Domain.name -ne $null) {
            return "User is authenticated"
        } Else {
            return "User is not authenticated"
        }
    }
}
#eo functions

#bo alias
#eo alias

#bo load local/confidential code
If (Test-Path $localConfigurationFilePath) {
    . $localConfigurationFilePath
}
#eo load local/confidential code

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
