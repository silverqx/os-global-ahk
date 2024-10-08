﻿; Silver Zachara <silver.zachara@gmail.com> 2021-2024

#Requires AutoHotkey v2

Persistent
#NoTrayIcon
#SingleInstance Force
#UseHook True

;@Ahk2Exe-Base ../v2/AutoHotkey64.exe
;@Ahk2Exe-SetMainIcon %A_ScriptName~-admin\.[^\.]+$~.ico%
;@Ahk2Exe-SetCompanyName Crystal Studio
;@Ahk2Exe-SetCopyright Copyright (©) 2024 Silver Zachara
;@Ahk2Exe-SetDescription OS Global with Administrator rights (AutoHotkey)
;@Ahk2Exe-SetFileVersion %A_AhkVersion%
;@Ahk2Exe-SetName OS Global Admin
;@Ahk2Exe-SetOrigFilename %A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-SetProductVersion 1.0.0.0
;@Ahk2Exe-UseResourceLang 0x0409

; Global variables
; ----------------

SetTitleMatchMode('RegEx')

CoordMode('ToolTip', 'Screen')

; General Section
; ---------------

^+F1::Run(A_Programs . '\__my__\Process Explorer.lnk',, 'Max')

; Open Google Chrome
<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',, 'Max')
; Open Google Chrome - Incognito window
+<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe --incognito',, 'Max')

; Center Window
^!F7::CenterWindow()
; Max. Tile Window
^!F8::FullTileWindow()

; Restart the AhkOsGlobal scheduled task
^!´::
{
    SoundBeep(8000, 70)
    Run('powershell.exe -WindowStyle Hidden -NoLogo E:\autohotkey\os-global\recompile-admin.ps1',, 'Hide')
}

; Leader key ctrl-¨ shortcuts
; ---------------------------

; The ¨ is next to Enter key, it's key with |\ characters
^¨::
{
    ih := InputHook('T.8 L1 M', '{enter}.{esc}{tab}', 'c,e,p,r')
    ih.Start()
    result := ih.Wait()

    ; Send original shortcut on timeout
    if (result = 'Timeout')
        return Send('^¨')

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; With the ctrl modifier, has to be first
    ; Look appropriate number mappings at https://en.wikipedia.org/wiki/ASCII#Control_code_chart
    if (userInput == Chr(22))
        Scv()

    ; Without modifiers
    if (userInput = 'e')
        Se()
}

; Window related
; --------------

FullTileWindow()
{
    ; Current Foreground window
    WinMove(8, 8, 1904, 1000, 'A')
}

CenterWindow()
{
    WinExist('A')
    WinGetPos(&initX, &initY, &width, &height)

    ; Do nothing if the geometry is the same as in the FullTileWindow()
    if (width == 1904 && height == 1000 && initX == 8 && initY == 8)
        return

    x := (A_ScreenWidth / 2) - (width / 2)
    ; + 78 to take into account also the taskbar
    y := (A_ScreenHeight / 2) - ((height + 78) / 2)

    ; Prevent to overlay the taskbar
    if (height > 1000)
        y := 0
    ; Move a little to the top, better for an eye
    else if (y > 30)
        y -= 14

    WinMove(x < 0 ? 0 : x, y < 0 ? 0 : y)
}

; Leader key ctrl-¨ related
; -------------------------

; With the ctrl modifier
Scv()
{
    ih := InputHook('T.9 L1 M', '{enter}.{esc}{tab}', 'a,c,d,g,h,p,r,s')
    ih.Start()
    result := ih.Wait()

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; Without modifiers
    ; Connect
    if (userInput = 'c')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vm-g.ps1',, 'Hide')
    ; Detach
    else if (userInput = 'd') {
        MsgBox('Detaching Gentoo KVM', 'Gentoo', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmd-g.ps1',, 'Hide')
    }
    ; Preferences
    else if (userInput = 'p') {
        MsgBox('Preferences for Gentoo KVM', 'Gentoo', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmp-g.ps1',, 'Hide')
    }
    ; Run
    else if (userInput = 'r') {
        MsgBox('Starting Gentoo KVM', 'Gentoo', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmr-g.ps1',, 'Hide')
    }
}

; Without any modifier
; Environment Variables
Se()
{
    if (WinExist('^Environment Variables$'))
        WinActivate()
    else
        Run('rundll32.exe sysdm.cpl,EditEnvironmentVariables')
}
