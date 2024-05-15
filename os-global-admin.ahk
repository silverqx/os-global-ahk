﻿; Silver Zachara <silver.zachara@gmail.com> 2021-2024

#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance Force
#UseHook On


; Global
--------

SetTitleMatchMode, RegEx

CoordMode, ToolTip, Screen


; General Section
; -------------------

^+F1::Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\__my__\Process Explorer.lnk,, Maximize

; Open Google Chrome
<#m::
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe,, Maximize
    return
}

; Open Google Chrome - Incognito window
+<#m::
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --incognito,, Maximize
    return
}

; Center Window
^!F7::CenterWindow()
; Max. Tile Window
^!F8::FullTileWindow()

; Restart the AhkOsGlobal scheduled task
^!´::
{
    SoundBeep, 8000, 70
    Run, powershell.exe -WindowStyle Hidden -NoLogo E:\autohotkey\os-global\recompile-admin.ps1,, Hide
    return
}


; Leader key ctrl-j shortcuts
; ---------------------------

^j::
{
    Input, userInput, T.8 L1 M, {enter}.{esc}{tab}, c,e,p,r

    ; Send original shortcut on timeout
    if (ErrorLevel = "Timeout") {
        Send, ^j
        return
    }

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; With the ctrl modifier, has to be first
    ; Look appropriate number mappings at https://en.wikipedia.org/wiki/ASCII#Control_code_chart
    if (userInput == Chr(22))
        Scv()

    ; Without modifiers
    if (userInput = "e")
        Se()

    return
}


; Window related
; -------------------

FullTileWindow()
{
    ; Current Foreground window
    WinActive("A")
    WinMove,,, 8, 8, 1904, 1000
}

CenterWindow()
{
    WinExist("A")
    WinGetPos, initX, initY, width, height

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

    WinMove, x < 0 ? 0 : x, y < 0 ? 0 : y
}


; Leader key ctrl-j related
; -------------------------

; With the ctrl modifier
Scv()
{
    global VmrunPauseToggle

    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, a,c,d,g,h,p,r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    ; Connect
    if (userInput = "c")
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vm-g.ps1,, Hide
    ; Detach
    else if (userInput = "d") {
        MsgBox,, Gentoo, Detaching Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmd-g.ps1,, Hide
    }
    ; Preferences
    else if (userInput = "p") {
        MsgBox,, Gentoo, Preferences for Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmp-g.ps1,, Hide
    }
    ; Run
    else if (userInput = "r") {
        MsgBox,, Gentoo, Starting Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmr-g.ps1,, Hide
    }

    return
}

; Without any modifier
; Environment Variables
Se()
{
    if WinExist("^Environment Variables$")
        WinActivate
    else
        Run, rundll32.exe sysdm.cpl`,EditEnvironmentVariables
}
