; Mouse related
; -------------

; Center the mouse position on the given control
ControlCenterMouse(control, winTitle := 'A')
{
    try
        ControlGetPos(&x, &y, &width, &height, control, winTitle)
    catch
        return

    CoordMode('Mouse', 'Client')
    MouseMove((width / 2) + x, (height / 2) + y, 0)
}
