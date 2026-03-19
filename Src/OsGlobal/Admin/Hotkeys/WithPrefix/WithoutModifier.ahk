; Without any modifier
; --------------------
; Leader key Ctrl-Alt-¨ or AltGr-¨ related

; Environment Variables
Se()
{
    if (WinExist('^Environment Variables$'))
        WinActivate()
    else
        Run('rundll32.exe sysdm.cpl,EditEnvironmentVariables')
}
