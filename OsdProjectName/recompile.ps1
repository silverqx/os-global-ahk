Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOSDProjectName

Start-Process -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" -ArgumentList '/in OsdProjectName.ahk' -Wait -NoNewWindow -WorkingDirectory E:\autohotkey\os-global\OsdProjectName

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOSDProjectName
