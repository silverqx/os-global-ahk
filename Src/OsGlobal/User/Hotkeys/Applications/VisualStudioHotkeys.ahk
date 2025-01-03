; Visual Studio
; -------------

; Focus Navigation bar - Function Dropdown list
#HotIf WinActive('(?:Microsoft Visual Studio)$ ahk_exe devenv.exe')
^F2::Send('^{F2}{Tab 2}{Down}')

; Duplicate Selection and Comment
^NumpadDiv::Send('^!{Down}^{NumpadMult}{Up}{Left 2}')
^+NumpadDiv::Send('^!{Down}^{NumpadMult}{Up}')
#HotIf ; WinActive('(?:Microsoft Visual Studio)$ ahk_exe devenv.exe')
