; Silver Zachara <silver.zachara@gmail.com> 2023-2024

#Requires AutoHotkey v2

Persistent
#NoTrayIcon
#SingleInstance Force

;@Ahk2Exe-Base ../v2/AutoHotkey64.exe
;@Ahk2Exe-SetMainIcon ../os-global.ico
;@Ahk2Exe-SetCompanyName Crystal Studio
;@Ahk2Exe-SetCopyright Copyright (©) 2024 Silver Zachara
;@Ahk2Exe-SetDescription QtCreator OSD (AutoHotkey)
;@Ahk2Exe-SetFileVersion %A_AhkVersion%
;@Ahk2Exe-SetName QtCreator OSD
;@Ahk2Exe-SetOrigFilename %A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-SetProductVersion 1.0.0.0
;@Ahk2Exe-UseResourceLang 0x0409

; This code was originally in the os-global.ahk, but it caused problems, the OnWmPowerBroadcast() handler
; for the OnMessage(0x218, 'OnWmPowerBroadcast') was called twice! I think it was because the CreateQtCreatorOSD()
; creates a window behind the scene, so I got two windows and so it was called twice. Because of that I created
; this standalone script for the CreateQtCreatorOSD() function.

; Global variables
; ----------------

CoordMode('ToolTip', 'Screen')

; Qt Creator OSD related
; ----------------------

; OSD Text Control
QtCreatorOSDText := ''

CreateQtCreatorOSD()

; General Section
; ---------------

; Restart the AhkQtCreatorOsd scheduled task
^!+´::
{
    SoundBeep(8000, 70)
    Run('powershell.exe -WindowStyle Hidden -NoLogo E:\autohotkey\os-global\qtcreator-osd\recompile.ps1',, 'Hide')
}

; Qt Creator OSD related
; ----------------------

; Create OSD window for the Qt Creator
CreateQtCreatorOSD()
{
    global QtCreatorOSDText

    ; Can be any RGB color (it will be made transparent below)
    CustomColor := '000000'

    ; +ToolWindow avoids a taskbar button and an Alt-Tab menu item
    ui := Gui()
    ui.Opt('+LastFound +AlwaysOnTop -Caption +ToolWindow')
    ui.BackColor := CustomColor
    ui.SetFont('s11 w500 q5')

    ; Text Label
    QtCreatorOSDText := ui.Add('Text', 'vQtCreatorOSDText cEEEEEE w236 r1')

    ; Make all pixels of this color transparent and make the text itself translucent (150)
    WinSetTransColor(CustomColor . ' 150', ui)

    ; Make the first update immediate rather than waiting for the timer
    UpdateOSD()
    ; Update every 200ms
    SetTimer(UpdateOSD, 200)

    ; NoActivate avoids deactivating the currently active window
    ui.Show('x1690 y1041 NoActivate')
}

; Update OSD on the base of currently active window
UpdateOSD()
{
    ; Don't hide the OSD if the task switcher is shown (Alt+Tab)
    if (WinActive('ahk_class MultitaskingViewFrame'))
        return

    ; Also expect some delay
    Sleep(130)

    if (WinActive('ahk_class MultitaskingViewFrame'))
        return

    ; WinGetTitle('A') fails without this with: Error: Target window not found.
    if (!WinExist('A'))
        return

    result := RegExMatch(WinGetTitle('A'), '(?:.* [@-] )?(.*[^\)])(?:\)? - Qt Creator)$', &Match)

    ; If a title was not found then show nothing
    if (result == 0 || Match.Count != 1)
        QtCreatorOSDText.Value := ''
    else
        QtCreatorOSDText.Value := Match[1]
}
