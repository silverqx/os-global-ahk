; Total Commander core
; --------------------

; Get the currently focused panel (with the default value handling)
TCGetFocusedPanelClassNN()
{
    focusedHwnd := ControlGetFocus('A')
    focusedClassNN := ControlGetClassNN(focusedHwnd)

    ; Default is the Left panel
    if (focusedClassNN != 'TMyListBox1' && focusedClassNN != 'TMyListBox2')
        return 'TMyListBox1'

    return focusedClassNN
}

; Get the maximize position by the given ClassNN
TCGetMaximizePosition(classNN)
{
    ; Right panel
    if (classNN == 'TMyListBox1')
        return 0

    ; Left panel (TMyListBox2) or any other control
    return A_ScreenWidth
}

; Restore panels to 50/50
TCRestorePanelListing()
{
    MouseGetPos(&xOriginal, &yOriginal)
    ; Mouse must be in the center of the screen to correctly restore to 50/50
    MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2, 0)

    SetControlDelay(25) ; It fails often with the default value (20)
    ; Double click
    ControlClick('TPanel1', 'A',, 'Left', 2, 'NA')

    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}

; Maximize the currently focused panel
TCMaximizePanelListing()
{
    MouseGetPos(&xOriginal, &yOriginal)

    SetControlDelay(40) ; It fails often with the default value (20) even 35 is too low
    ControlClick('TPanel1', 'A',, 'Left', 1, 'NA D') ; Hold Down
    MouseMove(TCGetMaximizePosition(TCGetFocusedPanelClassNN()) , yOriginal)
    ControlClick('TPanel1', 'A',, 'Left', 1, 'NA U') ; Release (Up)

    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}
