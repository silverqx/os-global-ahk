#!/usr/bin/env pwsh

Set-StrictMode -Version 3.0

Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal

Start-Process `
    -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" `
    -ArgumentList '/in OsGlobal.ahk' `
    -Wait -NoNewWindow `
    -WorkingDirectory E:\autohotkey\os-global\Src\OsGlobal\User

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal

[System.Console]::Beep(8000, 50)
