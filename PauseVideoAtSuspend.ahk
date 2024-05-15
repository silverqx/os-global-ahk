; Silver Zachara <silver.zachara@gmail.com> 2022-2024

#NoEnv
#NoTrayIcon
#SingleInstance Force

; Pause the MPC-HC video player if it's in the foreground and video is playing.

WinGet, processName, ProcessName , A

if (processName = "mpc-hc64.exe") {
    Send {Space}
    return

    ; Following doesn't work in the fullscreen mode, it still shows Paused
    ; Get a text in the statusbar (Static3 is the statusbar)
;    ControlGetText, text, Static3, A
    ; If it starts with the 'Playing ' text
;    if (InStr(text, "Playing ", true) = 1) {
;        Send {Space}
;        return
;    }
}

; Pause the Skylink/YouTube video if it's in the foreground, it sends the ctrl+alt+shift+p
; keyboard shortcut that is handled by the Tampermonkey.

WinGetTitle, title, A

; -1 - doesn't start; false or 0 - doesn't contain
if (InStr(title, "Skylink - ", true) != 1 && InStr(title, " - YouTube - Google Chrome", true) = false)
    return

Send ^!+p
