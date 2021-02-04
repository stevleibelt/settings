# Basic windows terminal profile

You should link or place it to `C:\Users\<username>\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState`

# Create a hardlink in Windows

```pwsh
New-Item -ItemType HardLink -Path "C:\Users\<user name>\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target "<path to this repository>\windows_terminal\settings.json"
```
