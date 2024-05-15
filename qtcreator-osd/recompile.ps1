Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkQtCreatorOsd

Start-Process -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" -ArgumentList '/in qtcreator-osd.ahk /icon ../os-global.ico /bin ../os-global.bin' -Wait -NoNewWindow -WorkingDirectory E:\autohotkey\os-global\qtcreator-osd

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkQtCreatorOsd
