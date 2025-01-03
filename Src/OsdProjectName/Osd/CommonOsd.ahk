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
