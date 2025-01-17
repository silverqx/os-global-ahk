; Visual Studio
; -------------

#HotIf WinActive('(?:Microsoft Visual Studio)$ ahk_exe devenv.exe')
; Focus Navigation bar - Function Dropdown list
^F2::Send('^{F2}{Tab 2}{Down}')

; Duplicate Selection and Comment
^NumpadDiv::Send('^!{Down}^{NumpadMult}{Up}{Left 2}')
^+NumpadDiv::Send('^!{Down}^{NumpadMult}{Up}')

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
    VisualStudioWESkipOptions := false
}
#HotIf ; WinActive('(?:Microsoft Visual Studio)$ ahk_exe devenv.exe')
