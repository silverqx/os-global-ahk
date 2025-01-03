; Global Mouse hotkeys
; --------------------

; Open ComputerOff
~LButton & WheelUp::
{
    ; If Options dialog is opened then activate it, instead of activate the Main window
    if (WinExist('^Options$ ahk_class TFormOptionsDialog') || WinExist('^ComputerOff$'))
        return WinActivate()

    Run('C:\optx64\ComputerOff\ComputerOff.exe',,, &PID)
    WinWait('ahk_pid ' . PID)
    WinActivate('ahk_pid ' . PID)
}

; Show Windows Start Menu
~LButton & WheelDown::Send('{LWin}')

; Mouse shortcut for ctrl+home/end
~LButton & WheelRight::Send('^{Home}')
~LButton & WheelLeft::Send('^{End}')

; Suspend2Ram
~RButton & WheelUp::
{
    ; Hopefully this prevents strange sleep bug
    Sleep(2000)
    DllCall('PowrProf\SetSuspendState', 'Int', 0, 'Int', 0, 'Int', 0)
}

; Black screensaver
~RButton & WheelDown::
{
    Sleep(2000)
    Run('scrnsave.scr /s',, 'Hide')
}

; Hibernate
; ~RButton & WheelDown::
; {
;     Sleep(2000)
;     DllCall('PowrProf\SetSuspendState', 'Int', 1, 'Int', 0, 'Int', 0)
; }
