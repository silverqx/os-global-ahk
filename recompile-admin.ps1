Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal-Admin

Start-Process -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" -ArgumentList '/in os-global-admin.ahk' -Wait -NoNewWindow -WorkingDirectory E:\autohotkey\os-global

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal-Admin
