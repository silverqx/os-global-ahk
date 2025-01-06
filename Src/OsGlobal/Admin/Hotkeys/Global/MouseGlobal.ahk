; Global Mouse hotkeys
; --------------------

; Show Windows Start Menu
~LButton & WheelDown::Send('{LWin}')

; Switch to the previous window
~MButton & XButton2::!Tab

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
