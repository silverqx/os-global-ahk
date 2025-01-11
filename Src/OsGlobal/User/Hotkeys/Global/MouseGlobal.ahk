#Include <OsGlobal\GlobalVariables>

; Global Mouse hotkeys
; --------------------

; Open ComputerOff
~LButton & WheelUp::
{
    ; If Options dialog is opened then activate it, instead of activate the Main window
    if (WinExist('^Options$ ahk_class TFormOptionsDialog ' . WinTitleComputerOff) ||
        WinExist('^ComputerOff$ ahk_class TFormMainForm ' . WinTitleComputerOff)
    )
        return WinActivate()

    Run('C:\optx64\ComputerOff\ComputerOff.exe',,, &PID)
    WinWait('ahk_pid ' . PID)
    WinActivate('ahk_pid ' . PID)
}

; Mouse shortcut for ctrl+home/end (can't be LButton to avoid selecting entire)
~RButton & WheelRight::Send('^{Home}')
~RButton & WheelLeft::Send('^{End}')
