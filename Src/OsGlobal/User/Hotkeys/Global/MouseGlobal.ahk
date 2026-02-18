#Include <OsGlobal\GlobalVariables>

; Global Mouse hotkeys
; --------------------

; Show Windows Start Menu
~LButton & WheelDown::Send('{LWin}')

; Open ComputerOff
~LButton & WheelUp::
{
    ; If Options dialog is opened then activate it, instead of activate the Main window
    if (WinExist('^Options$ ahk_class TFormOptionsDialog ' . WinTitleComputerOff) ||
        WinExist(WinTitleComputerOffMain)
    )
        return WinActivate()

    ; Minimize to tray is handled in the ComputerOff.exe
    ; Run(A_MyDocuments . '\Embarcadero\Studio\Projects\ComputerOff\Win64\Debug\ComputerOff.exe',,, &PID)
    Run('C:\optx64\ComputerOff\ComputerOff.exe',,, &PID)
}

; Change the transparency of the active window
^!+WheelDown::
{
    if (WinGetTransparent('A') = '')
        WinSetTransparent(170, 'A')
    else
        WinSetTransparent('Off', 'A')
}
