#Include <OsGlobal\Window>

; Without any modifier
; --------------------
; Leader key Ctrl-Alt-¨ or AltGr-¨ related

; Environment Variables
Se() =>
    RunOrActivateIfExist('^Environment Variables$',
        'rundll32.exe sysdm.cpl,EditEnvironmentVariables')
