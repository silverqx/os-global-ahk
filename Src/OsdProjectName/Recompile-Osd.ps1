#!/usr/bin/env pwsh

Set-StrictMode -Version 3.0

Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOSDProjectName

$Script:OsdProjectNameDir = $null -eq $env:OsGlobalRoot `
    ? $PSScriptRoot
    : (Join-Path $env:OsGlobalRoot 'Src\OsdProjectName')

Start-Process `
    -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" `
    -ArgumentList '/in OsdProjectName.ahk' `
    -Wait -NoNewWindow `
    -WorkingDirectory $Script:OsdProjectNameDir

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOSDProjectName

[System.Console]::Beep(7300, 50)
