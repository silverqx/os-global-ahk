Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal-Admin

Start-Process -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" -ArgumentList '/in OsGlobalAdmin.ahk' -Wait -NoNewWindow -WorkingDirectory E:\autohotkey\os-global\OsGlobal\Admin

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal-Admin
