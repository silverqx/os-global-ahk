; Silver Zachara <silver.zachara@gmail.com> 2018

#Persistent
#UseHook On
#SingleInstance Force
#NoTrayIcon

; Suspend2Ram
~RButton & WheelUp::
{
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    return
}

; Hibernate
~RButton & WheelDown::
{
    DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^BackSpace::
{
    ; Download first and last pieces first
    Send, {AppsKey}{Down 14}{Enter}
    ; Download in sequential order
    Send, {AppsKey}{Down 13}{Enter}
    ; Assign to video category
    Send, {AppsKey}{Down 6}{Right}{Up 2}{Enter}

    return
}

; doesn't work
;#IfWinActive ahk_class Chrome_WidgetWin_1 ; targetting only Chrome browser
;F3::Send ^`   ; chrome debugger next step   map key F8      to chrome devtools F10
