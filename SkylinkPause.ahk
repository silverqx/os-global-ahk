; Silver Zachara <silver.zachara@gmail.com> 2022

#NoEnv
#NoTrayIcon
#SingleInstance Force

; Pause the Skylink/YouTube video if it's in the foreground, it sends the ctrl+alt+shift+p
; keyboard shortcut that is handled by the Tampermonkey.

WinGetTitle, title, A

if (InStr(title, "Skylink - ", true) != 1 || InStr(title, "YouTube - ", true) != 1)
    return

Send ^!+p
