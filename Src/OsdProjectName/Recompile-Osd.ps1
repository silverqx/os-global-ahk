#!/usr/bin/env pwsh

Set-StrictMode -Version 3.0

Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOSDProjectName

Start-Process `
    -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" `
    -ArgumentList '/in OsdProjectName.ahk' `
    -Wait -NoNewWindow `
    -WorkingDirectory E:\autohotkey\os-global\Src\OsdProjectName

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOSDProjectName

[System.Console]::Beep(7300, 50)
