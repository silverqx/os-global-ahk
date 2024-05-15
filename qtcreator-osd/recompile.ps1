Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkQtCreatorOsd

Start-Process -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" -ArgumentList '/in qtcreator-osd.ahk' -Wait -NoNewWindow -WorkingDirectory E:\autohotkey\os-global\qtcreator-osd

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkQtCreatorOsd
