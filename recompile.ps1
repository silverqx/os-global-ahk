Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal

Start-Process -FilePath Ahk2Exe.exe -ArgumentList "/in os-global.ahk /icon os-global.ico /bin os-global.bin" -Wait -NoNewWindow

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal

