#Include PipMode.ahk

; Global variables
; ----------------

MpcHcPipToggle := false

; mpc-hc
; ------

#HotIf WinActive(WinTitleMpcHc)
MButton::
{
    ; Only propagate the MButton when RButton is down/pressed because mpc-hc itself allows
    ; to define combined mouse hotkeys like RButton & MButton.
    if (GetKeyState('RButton'))
        return Send('{MButton}')

    ; Nothing to do, VRWindow1 isn't under the cursor
    MouseGetPos(,,, &mouseClassNN)
    if (mouseClassNN != 'VRWindow1')
        return

    ; Touch Window from Outside/Inside
    static MpcHcTouchOutsideFrameToggle := false

    if (MpcHcTouchOutsideFrameToggle)
        Send('{F9}')
    else
        Send('{F10}')

    MpcHcTouchOutsideFrameToggle := !MpcHcTouchOutsideFrameToggle
}

; mpc-hc PIP mode
; ---------------
; PIP doesn't work well, doing whatever it wants, it behaves the same in ahk v1 as well so upgrade
; to ahk v2 isn't a problem.

; Manually toggle MpcHcPipToggle
^F7::
{
    global MpcHcPipToggle

    MpcHcPipToggle := !MpcHcPipToggle

    value := MpcHcPipToggle ? 'enabled' : 'disabled'
    MsgBox('PIP mode : ' . value, 'Toggle MpcHcPip flag', 'T1')
}

; Reset x, y restore positions and sizes for pip mode
^F8::
{
    MpcHcResetPipPositions()

    MsgBox('Reset x, y restore positions and sizes', 'Reset PIP mode positions', 'T1')
}

; Disable PIP mode
^Enter::
{
    global MpcHcPipToggle

    if (isWindowFullScreen('A') && MpcHcPipToggle)
        return Send('!{Enter}')

    ; ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    else if (!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPipToggle)
        return MpcHcDisablePip()

    else if (MpcHcPipToggle) {
        MpcHcDisablePip()
        MpcHcPipToggle := false
        return
    }

    MpcHcEnablePip()
    MpcHcPipToggle := true
}

^!Left::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPipToggle && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPipToggle))
        return

    MpcHcResetPipPositions()

    MpcHcMoveLeft()
}

^!Right::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPipToggle && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPipToggle))
        return

    MpcHcResetPipPositions()

    MpcHcMoveRight()
}

^!Up::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPipToggle && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPipToggle))
        return

    MpcHcResetPipPositions()

    MpcHcMoveTop()
}

^!Down::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPipToggle && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPipToggle))
        return

    MpcHcResetPipPositions()

    MpcHcMoveBottom()
}
#HotIf ; WinActive(WinTitleMpcHc)
