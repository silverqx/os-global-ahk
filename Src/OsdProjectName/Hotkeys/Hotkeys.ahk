#Include <OsGlobal\GlobalVariables>

; Global Keyboard hotkeys
; -----------------------

; Restart the AhkOSDProjectName scheduled task
^!+´::
{
    SoundBeep(8000, 70)
    Run(PwshHiddenFile . A_InitialWorkingDir . '\Recompile-Osd.ps1',, 'Hide')
}
