#Include <OsGlobal\GlobalVariables>

; Visual Studio
; -------------

#HotIf WinActive('(?:Microsoft Visual Studio( Preview)?)$ ahk_exe devenv.exe')
; Focus Navigation bar - Function Dropdown list
^F12::Send('^{F12}{Tab 2}{Down}')

; Duplicate Selection and Comment
^NumpadDiv::Send('^!{Down}^{NumpadMult}{Up}{Left 2}')
^+NumpadDiv::Send('^!{Down}^{NumpadMult}{Up}')

; Copy/Duplicate line up
^!Up::Send('^!{Down}{Up}')

; Focus the Filter input on Options - Environment - Keyboard
^!+,::
{
    global VisualStudioWESkipOptions
    ; To skip the global WinEvent for the Options modal (Preferences)
    VisualStudioWESkipOptions := true

    Send('^!+,')

    WinWait(WinTitleVisualStudioOptions)
    Send('!c')

    ; Restore
    ; Without the timer the Send('^e') in the WEVisualStudioOptions() is reached
    SetTimer(() => VisualStudioWESkipOptions := false, -500)
}
#HotIf ; '(?:Microsoft Visual Studio( Preview)?)$ ahk_exe devenv.exe'
