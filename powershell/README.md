# Basic windows powershell profile

You should link or place it to `c:\Users\<username>\Documents\WindowsPowerShell`.

If file exists, it tries to load the file `c:\Users\<username>\Documents\WindowsPowerShell\local.profile.ps1` to separate confidential or system specific informations from general ones.

# Create a hardlink in Windows

```pwsh
New-Item -ItemType HardLink -Path "C:\Users\<username>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Target "<path to this repository>\powershell\Microsoft.PowerShell_profile.ps1"
```

# Link

* [compwiz32/PowerShell](https://github.com/compwiz32/PowerShell) - 20200916
