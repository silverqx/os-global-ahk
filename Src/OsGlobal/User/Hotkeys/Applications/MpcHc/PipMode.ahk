#Include <OsGlobal\GlobalVariables>

; Global variables
; ----------------

MpcHcZoom25Key := '!;'
MpcHcZoom50Key := '!{+}' ; Unused
MpcHcZoom100Key := '!ě' ; Unused
; Default to 25%
MpcHcZoomKey := MpcHcZoom25Key
; Default width in normal mode
MpcHcDefaultNormalWidth := 1240
; Default pip mode width
MpcHcDefaultPipWidth := 420
; Custom position and size
MpcHcPipX := ''
MpcHcPipY := ''
MpcHcPipWidth := ''
MpcHcPipHeight := ''

; mpc-hc PIP mode
; ---------------

MpcHcEnablePip()
{
    global MpcHcZoomKey, MpcHcDefaultPipWidth
    global KeyDelay25, KeyDelayDefault
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    if (!WinExist('A'))
        return

    SetKeyDelay(KeyDelay25)

    ; Enable StayOnTop and Hide Playlist
    Send('^a^!a')
    ; Compact mode
    Send('{+}')

    ; Top right corner - default position
    if (MpcHcPipX == '' && MpcHcPipY == '') {
        ; Zoom by MpcHcZoomKey variable
        Send(MpcHcZoomKey)
        Sleep(60)

        ; Compute width and height, mpc-hc sets correct aspect ratio so use it to compute correct height
        WinGetPos(,, &width, &height)
        newWidth := MpcHcDefaultPipWidth
        newHeight := MpcHcDefaultPipWidth / (width / height)

        WinMove(A_ScreenWidth - MpcHcDefaultPipWidth - 20, 20, newWidth, newHeight)
    }
    ; Restore custom position and size
    else {
        ; Disable Fullscreen
        Send('!{Enter}')

        WinMove(MpcHcPipX, MpcHcPipY, MpcHcPipWidth, MpcHcPipHeight)
    }

    SetKeyDelay(KeyDelayDefault)
}

MpcHcDisablePip()
{
    global KeyDelay25, KeyDelayDefault
    global MpcHcZoomKey, MpcHcDefaultNormalWidth
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    if (!WinExist('A'))
        return

    SetKeyDelay(KeyDelay25)

    ; Store x and y positions and sizes in pip mode only if the pip window has been moved or resized
    WinGetPos(&x, &y, &width, &height)

    if (x != (A_ScreenWidth - width - 20) || y != 20 ||
        MpcHcPipWidth != width || MpcHcPipHeight != height
    ) {
        MpcHcPipX := x
        MpcHcPipY := y
        MpcHcPipWidth := width
        MpcHcPipHeight := height
    }

    ; Dummy shortcut to fix W11 alt bug
    Send('!-')
    ; Disable StayOnTop
    Send('^a')
    ; Normal mode
    Send('š')
    ; Zoom by MpcHcZoomKey variable
    Send(MpcHcZoomKey)
    ; Show playlist
    Send('^!a')

    ; Compute width and height, mpc-hc sets correct aspect ratio so use it to compute correct height
    Sleep(60)
    WinGetPos(,, &width, &height)
    newWidth := MpcHcDefaultNormalWidth
    newHeight := MpcHcDefaultNormalWidth / (width / height)

    ; Default position I want to
    WinMove(60, 40, newWidth, newHeight)

    ; Fullscreen
    Send('!{Enter}')

    SetKeyDelay(KeyDelayDefault)
}

MpcHcResetPipPositions()
{
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    MpcHcPipX := ''
    MpcHcPipY := ''
    MpcHcPipWidth := ''
    MpcHcPipHeight := ''
}

MpcHcMoveLeft()
{
    if (!WinExist('A'))
        return

    WinGetPos(&x, &y, &width, &height)

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (top, bottom) of pip window
    result := RegExMatch(snapPosition, '([TLBR][a-z]+)(?:[TLBR][a-z]+)', &Match)

    ; TODO add Match.Count check, check all other RegExMatch-es silverqx

    moveToX := 20

    if (Match[1] == 'Top')
        moveToY := 20

    else if (Match[1] == 'Bottom')
        moveToY := A_ScreenHeight - height - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove(moveToX, moveToY)
}

MpcHcMoveRight()
{
    if (!WinExist('A'))
        return

    WinGetPos(&x, &y, &width, &height)

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (top, bottom) of pip window
    result := RegExMatch(snapPosition, '([TLBR][a-z]+)(?:[TLBR][a-z]+)', &Match)

    moveToX := A_ScreenWidth - width - 20

    if (Match[1] == 'Top')
        moveToY := 20

    else if (Match[1] == 'Bottom')
        moveToY := A_ScreenHeight - height - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove(moveToX, moveToY)
}

MpcHcMoveTop()
{
    if (!WinExist('A'))
        return

    WinGetPos(&x, &y, &width, &height)

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (left, right) of pip window
    result := RegExMatch(snapPosition, '(?:[TLBR][a-z]+)([TLBR][a-z]+)', &Match)

    moveToY := 20

    if (Match[1] == 'Left')
        moveToX := 20

    else if (Match[1] == 'Right')
        moveToX := A_ScreenWidth - width - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove(moveToX, moveToY)
}

MpcHcMoveBottom()
{
    if (!WinExist('A'))
        return

    WinGetPos(&x, &y, &width, &height)

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (left, right) of pip window
    result := RegExMatch(snapPosition, '(?:[TLBR][a-z]+)([TLBR][a-z]+)', &Match)

    moveToY := A_ScreenHeight - height - 20

    if (Match[1] == 'Left')
        moveToX := 20

    else if (Match[1] == 'Right')
        moveToX := A_ScreenWidth - width - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove(moveToX, moveToY)
}

; Infer current pip window position
MpcHcInferPreSnapPosition(x, y, width, height)
{
    result := ''

    if (y + height / 2 < A_ScreenHeight / 2)
        result .= 'Top'
    else
        result .= 'Bottom'

    if (x + width / 2 < A_ScreenWidth / 2)
        result .= 'Left'
    else
        result .= 'Right'

    return result
}
