; Silver Zachara <silver.zachara@gmail.com> 2023-2024

#Requires AutoHotkey v2

Persistent
#NoTrayIcon
#SingleInstance Force

;@Ahk2Exe-Base ../v2/AutoHotkey64.exe
;@Ahk2Exe-SetMainIcon ../resources/OsGlobal.ico
;@Ahk2Exe-SetCompanyName Crystal Studio
;@Ahk2Exe-SetCopyright Copyright (©) 2024 Silver Zachara
;@Ahk2Exe-SetDescription QtCreator OSD (AutoHotkey)
;@Ahk2Exe-SetFileVersion %A_AhkVersion%
;@Ahk2Exe-SetName QtCreator OSD
;@Ahk2Exe-SetOrigFilename %A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-SetProductVersion 1.0.0.0
;@Ahk2Exe-UseResourceLang 0x0409

; This code was originally in the OsGlobal.ahk, but it caused problems, the OnWmPowerBroadcast() handler
; for the OnMessage(0x218, 'OnWmPowerBroadcast') was called twice! I think it was because
; the CreateCommonOSD() creates a window behind the scene, so I got two windows and so it was called twice.
; Because of that I have created this standalone script for project name OSD-es.

; Global variables
; ----------------

CoordMode('ToolTip', 'Screen')

; OSD variables
; -------------

; OSD Text Controls
QtCreatorOSDText := ''
VSCodeOSDText := ''

CreateQtCreatorOSD()
CreateVSCodeOSD()

; General Section
; ---------------

; Restart the AhkOSDProjectName scheduled task
^!+´::
{
    SoundBeep(8000, 70)
    Run('powershell.exe -WindowStyle Hidden -NoLogo E:\autohotkey\os-global\OsdProjectName\Recompile.ps1',, 'Hide')
}

; Common OSD logic
; ----------------

; Create OSD window (common logic)
CreateCommonOSD(osdTextName, &osdText, updateOSD)
{
    ; Can be any RGB color (it will be made transparent below)
    CustomColor := '000000'

    ; +ToolWindow avoids a taskbar button and an Alt-Tab menu item
    ui := Gui()
    ui.Opt('+LastFound +AlwaysOnTop -Caption +ToolWindow')
    ui.BackColor := CustomColor
    ui.SetFont('s11 w500 q5')

    ; Text Label
    osdText := ui.Add('Text', Format('v{1} cEEEEEE w236 r1', osdTextName))

    ; Make all pixels of this color transparent and make the text itself translucent (150)
    WinSetTransColor(CustomColor . ' 150', ui)

    ; Make the first update immediate rather than waiting for the timer
    updateOSD.Call()
    ; Update every 200ms
    SetTimer(updateOSD, 200)

    return ui
}

; Update OSD based on the currently active window (common logic)
UpdateCommonOSD(titleRegEx, &osdText)
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

    result := RegExMatch(WinGetTitle('A'), titleRegEx, &Match)

    ; If a title was not found then show nothing
    if (result == 0 || Match.Count != 1)
        osdText.Value := ''
    else
        osdText.Value := Match[1]
}

; Qt Creator OSD
; --------------

; Create OSD window for the Qt Creator
CreateQtCreatorOSD()
{
    global QtCreatorOSDText

    ui := CreateCommonOSD("QtCreatorOSDText", &QtCreatorOSDText, UpdateQtCreatorOSD)

    ; NoActivate avoids deactivating the currently active window
    ui.Show('x1690 y1041 NoActivate')
}

; Update OSD based on the currently active window for the Qt Creator
UpdateQtCreatorOSD()
{
    global QtCreatorOSDText

    UpdateCommonOSD('(?:.* [@-] )?(.*[^\)])(?:\)? - Qt Creator)$', &QtCreatorOSDText)
}

; Visual Studio Code OSD
; ----------------------

; Create OSD window for the Visual Studio Code
CreateVSCodeOSD()
{
    global VSCodeOSDText

    ui := CreateCommonOSD("VSCodeOSDText", &VSCodeOSDText, UpdateVSCodeOSD)

    ; NoActivate avoids deactivating the currently active window
    ui.Show('x1762 y50 NoActivate')
}

; Update OSD based on the currently active window for the Visual Studio Code
UpdateVSCodeOSD()
{
    global VSCodeOSDText

    ; (?<!^Welcome) - the reason for this is that the project can be called Welcome, in this case
    ; the title would be: file.txt - Welcome - Visual Studio Code, but if it starts with Welcome
    ; like: Welcome - Visual Studio Code, then it's clear that no project/folder is currently open
    ; and only the Welcome screen is displayed. 🤔
    UpdateCommonOSD('(?:.* - )?(.*)(?<!^Welcome)(?: - Visual Studio Code)$', &VSCodeOSDText)
}
