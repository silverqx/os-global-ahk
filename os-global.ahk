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

; Open ComputerOff
~LButton & WheelUp::
{
    Run, C:\optx64\computeroff\ComputerOff.exe
    return
}

; Open Google Chrome
<#n::
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe, , Maximize
    return
}

; Center Window
^+F8::
{
    ; Current Foreground window
    WinActive("A")
    WinMove,,, 8, 8, 1904, 1000

    return
}


; qBittorrent Section
; -------------------

#IfWinActive ahk_exe qbittorrent.exe
^BackSpace::
{
    ; Download first and last pieces first
    Send, {AppsKey}{Down 13}{Enter}
    ; Download in sequential order
    Send, {AppsKey}{Down 12}{Enter}
    ; Assign to video category
    Send, {AppsKey}{Down 7}{Right}{Up 1}{Enter}
    ; Assign seed tag
    Send, {AppsKey}{Down 8}{Right}{Up 2}{Enter}

    return
}

; Assign to video category
#IfWinActive ahk_exe qbittorrent.exe
^+BackSpace::
{
    ; Assign to video category
    Send, {AppsKey}{Down 7}{Right}{Up 1}{Enter}
    ; Assign seed tag
    Send, {AppsKey}{Down 8}{Right}{Up 2}{Enter}

    return
}

; Preview
#IfWinActive ahk_exe qbittorrent.exe
F3::
{
    Send, {AppsKey}{Down 11}{Enter}
    return
}

; Preview when seeding
#IfWinActive ahk_exe qbittorrent.exe
F4::
{
    Send, {AppsKey}{Down 12}{Enter}
    return
}

; Limit download rate shortcuts
#IfWinActive ahk_exe qbittorrent.exe
^;::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}0{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^+::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}1024{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}102{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ě::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}2048{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}204{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^š::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}3072{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}307{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^č::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}4096{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}409{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ř::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}5120{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}512{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ž::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}6144{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}614{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ý::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}7168{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}716{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^á::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}8192{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}819{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^í::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}9216{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}921{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^é::
{
    Send, {AppsKey}{Down 10}{Enter}{Up 1}10240{Enter}
;    Send, {AppsKey}{Down 10}{Enter}{Up 1}1024{Enter}
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
