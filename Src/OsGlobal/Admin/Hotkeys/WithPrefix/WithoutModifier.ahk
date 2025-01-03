; Without any modifier
; --------------------
; Leader key ctrl-¨ related

; Environment Variables
Se()
{
    if (WinExist('^Environment Variables$'))
        WinActivate()
    else
        Run('rundll32.exe sysdm.cpl,EditEnvironmentVariables')
}
