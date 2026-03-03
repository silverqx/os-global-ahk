#Include <OsGlobal\GlobalVariables>

; Global Keyboard hotkeys
; -----------------------

; Restart the AhkOSDProjectName scheduled task
^!+´::
{
    SoundBeep(8000, 70)
    Run(PwshHiddenFile . A_InitialWorkingDir . '\Recompile-Osd.ps1',, 'Hide')
}

; Close this script's own process
#^+F4::
{
    SoundBeep(7300, 70)
    DetectHiddenWindows(true)
    ProcessClose(WinGetPID('ahk_id ' . A_ScriptHwnd))
}
