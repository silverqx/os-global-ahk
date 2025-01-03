#Include CommonOsd.ahk

; Global variables
; ----------------

; OSD Text Controls
QtCreatorOSDText := ''

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
