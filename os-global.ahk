; Silver Zachara <silver.zachara@gmail.com> 2018

#Persistent
#UseHook On
#SingleInstance Force
#NoTrayIcon


; General Section
; -------------------

; Suspend2Ram
~RButton & WheelUp::
{
    ; Hopefully this prevents strange sleep bug
    Sleep, 2000
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    return
}

; Hibernate
~RButton & WheelDown::
{
    Sleep, 2000
    DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    return
}

; Open Google Chrome
<#n::
{
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", , Maximize
    return
}


; qBittorrent Section
; -------------------

#IfWinActive ahk_exe qbittorrent.exe
^BackSpace::
{
    ; Download first and last pieces first
    Send, {AppsKey}{Down 15}{Enter}
    ; Download in sequential order
    Send, {AppsKey}{Down 14}{Enter}
    ; Assign to video category
    Send, {AppsKey}{Down 7}{Right}{Up 2}{Enter}

    return
}

; Assign to video category
#IfWinActive ahk_exe qbittorrent.exe
^+BackSpace::
{
    ; Assign to video category
    Send, {AppsKey}{Down 7}{Right}{Up 2}{Enter}

    return
}

; Preview
#IfWinActive ahk_exe qbittorrent.exe
F3::
{
    Send, {AppsKey}{Down 13}{Enter}
    return
}

; Limit download rate shortcuts
#IfWinActive ahk_exe qbittorrent.exe
^;::
{
    Send, {AppsKey}{Down 10}{Enter}{Tab}0{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^+::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}1024{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}102{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ì::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}2048{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}204{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^š::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}3072{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}307{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^è::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}4096{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}409{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ø::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}5120{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}512{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ž::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}6144{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}614{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ý::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}7168{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}716{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^á::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}8192{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}819{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^í::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}9216{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}921{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^é::
{
;    Send, {AppsKey}{Down 10}{Enter}{Tab}10240{Enter}
    Send, {AppsKey}{Down 10}{Enter}{Tab}1024{Enter}
    return
}

; doesn't work
;#IfWinActive ahk_class Chrome_WidgetWin_1 ; targetting only Chrome browser
;F3::Send ^`   ; chrome debugger next step   map key F8      to chrome devtools F10


; Dark Souls 1 Save Manager
; -------------------

; Save Hotkey
; This hotkey will create a new save in the current run, and select it.
#IfWinActive ahk_exe DATA.exe
F6::
{
    ; Download first and last pieces first
    PostMessage, 0x312, 1000, 0,, DarkSaves
    return
}

; Load Hotkey
; This hotkey loads the last save selected, or last save created - whichever is most recent.
#IfWinActive ahk_exe DATA.exe
F8::
{
    PostMessage, 0x312, 1001, 0,, DarkSaves
    return
}
