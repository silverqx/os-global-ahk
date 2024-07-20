Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOSDProjectName

Start-Process -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" -ArgumentList '/in osd-project-name.ahk' -Wait -NoNewWindow -WorkingDirectory E:\autohotkey\os-global\osd-project-name

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOSDProjectName
