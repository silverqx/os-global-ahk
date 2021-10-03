Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal-Admin

Start-Process -FilePath 'C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe' -ArgumentList "/in os-global-admin.ahk /icon os-global.ico /bin os-global.bin" -Wait -NoNewWindow -WorkingDirectory E:\autohotkey\os-global

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal-Admin

