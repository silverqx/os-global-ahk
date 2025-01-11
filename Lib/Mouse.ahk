; Mouse related
; -------------

; Center the mouse position on the given control
ControlCenterMouse(control, winTitle)
{
    try {
        ; Nothing to do, the given window isn't in the foreground
        if (winTitle !== 'A' && !WinActive(winTitle))
            return

        ; Nothing to do, control is disabled
        if (!ControlGetEnabled(control, winTitle))
            return

        ControlGetPos(&x, &y, &width, &height, control, winTitle)
    }
    catch
        return

    CoordMode('Mouse', 'Client')
    MouseMove((width / 2) + x, (height / 2) + y, 0)
}
