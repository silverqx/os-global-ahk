; Silver Zachara <silver.zachara@gmail.com> 2023-2024

#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance Force


; This code was originally in the os-global.ahk, but it caused problems, the OnWmPowerBroadcast() handler
; for the OnMessage(0x218, "OnWmPowerBroadcast") was called twice! I think it was because the CreateQtCreatorOSD()
; creates a window behind the scene, so I got two windows and so it was called twice. Because of that I have made
; standalone script for the CreateQtCreatorOSD().


; Global
--------

CoordMode, ToolTip, Screen


; Qt Creator OSD related
; -------------------

; OSD Text Control
QtCreatorOSDText := ""

CreateQtCreatorOSD()


; General Section
; -------------------

; Restart the AhkQtCreatorOsd scheduled task
^!+´::
{
    SoundBeep, 8000, 70
    Run, powershell.exe -WindowStyle Hidden -NoLogo E:\autohotkey\os-global\qtcreator-osd\recompile.ps1,, Hide
    return
}


; Qt Creator OSD related
; -------------------

; Create OSD window for the Qt Creator
CreateQtCreatorOSD()
{
    ; Can be any RGB color (it will be made transparent below)
    CustomColor := "000000"
    ; +ToolWindow avoids a taskbar button and an alt-tab menu item
    Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
    Gui, Color, %CustomColor%
    Gui, Font, s11 w400 q5, "Segoe UI"

    Gui, Add, Text, vQtCreatorOSDText ceeeeee W236 R1

    ; Make all pixels of this color transparent and make the text itself translucent (150)
    WinSet, TransColor, %CustomColor% 150

    ; Update every 200ms
    SetTimer, UpdateOSD, 200
    ; Make the first update immediate rather than waiting for the timer
    UpdateOSD()
    ; NoActivate avoids deactivating the currently active window
    Gui, Show, x1690 y1041 NoActivate
}

; Update OSD on the base of currently active window
UpdateOSD()
{
    ; Don't hide OSD if is displayed task switcher by alt+tab
    if WinActive("ahk_class MultitaskingViewFrame")
        return

    ; Take also some delay into account
    Sleep, 130

    if WinActive("ahk_class MultitaskingViewFrame")
        return

    WinGetActiveTitle, Title
    result := RegExMatch(Title, "O)(?:.* [@-] )?(.*[^\)])(?:\)? - Qt Creator)$", Match)

    ; If a title was not found then show nothing
    if (result == 0 || Match.Count() != 1)
        GuiControl,, QtCreatorOSDText,
    else
        GuiControl,, QtCreatorOSDText, % Match[1]
}
