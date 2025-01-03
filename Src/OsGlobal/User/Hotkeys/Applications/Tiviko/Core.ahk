; Tiviko core
; -----------

; Zoom in the Grid page
TivikoIncreaseZoom()
{
    ; Mouse must be inside this area
    MouseMove(40, 380, 0)
    ; Increase zoom
    Send('^{WheelUp 3}')
}

; Zoom in the Grid page
TivikoIncreaseZoomWithRestore()
{
    MouseGetPos(&xOriginal, &yOriginal)
    ; Increase zoom
    TivikoIncreaseZoom()
    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}

; Zoom in the Grid page after clicking the Grid button
TivikoIncreaseZoomOnGridClick()
{
    MouseGetPos(&xOriginal, &yOriginal)

    ; Nothing to do, not inside the Grid button area
    if(!((xOriginal >=  26 && yOriginal >= 280) &&
         (xOriginal <= 208 && yOriginal <= 326))
    )
        return

    ; Wait until the Grid view loads
    Sleep(1200) ; ~1100ms is minimum

    ; Increase zoom
    TivikoIncreaseZoom()
    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}

; Reload TV program and increase zoom
TivikoReloadGrid()
{
    MouseGetPos(&xOriginal, &yOriginal)

    ; Back
    Send('{Browser_Back}')
    Sleep(150)
    ; Grid button
    Click('100', '300')
    MouseMove(xOriginal, yOriginal, 0)
    Sleep(150)
    ; Increase zoom
    TivikoIncreaseZoom()

    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}
