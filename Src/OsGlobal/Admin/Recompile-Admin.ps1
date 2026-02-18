#!/usr/bin/env pwsh

Set-StrictMode -Version 3.0

Stop-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal-Admin

$Script:OsGlobalAdminDir = $null -eq $env:OsGlobalRoot `
    ? $PSScriptRoot
    : (Join-Path $env:OsGlobalRoot 'Src\OsGlobal\Admin')

Start-Process `
    -FilePath "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe" `
    -ArgumentList '/in OsGlobalAdmin.ahk' `
    -Wait -NoNewWindow `
    -WorkingDirectory $Script:OsGlobalAdminDir

Start-ScheduledTask -TaskPath \Crystal\ -TaskName AhkOsGlobal-Admin

[System.Console]::Beep(7300, 50)
