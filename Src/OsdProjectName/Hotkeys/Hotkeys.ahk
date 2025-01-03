; Global Keyboard hotkeys
; -----------------------

; Restart the AhkOSDProjectName scheduled task
^!+´::
{
    SoundBeep(8000, 70)
    Run('powershell.exe -WindowStyle Hidden -NoLogo ' .
        'E:\autohotkey\os-global\Src\OsdProjectName\Recompile.ps1',, 'Hide')
}
