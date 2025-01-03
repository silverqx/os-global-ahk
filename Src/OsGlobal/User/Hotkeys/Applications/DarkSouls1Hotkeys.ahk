; Dark Souls 1 Save Manager
; -------------------------

; Save Hotkey
; This hotkey will create a new save in the current run, and select it.
#HotIf WinActive('ahk_exe DATA.exe')
F6::PostMessage(0x312, 1000, 0,, 'DarkSaves')
#HotIf ; WinActive('ahk_exe DATA.exe')

; Load Hotkey
; This hotkey loads the last save selected, or last save created - whichever is most recent.
#HotIf WinActive('ahk_exe DATA.exe')
F8::PostMessage(0x312, 1001, 0,, 'DarkSaves')
#HotIf ; WinActive('ahk_exe DATA.exe')
