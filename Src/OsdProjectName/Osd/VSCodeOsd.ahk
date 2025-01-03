#Include CommonOsd.ahk

; Global variables
; ----------------

; OSD Text Controls
VSCodeOSDText := ''

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
