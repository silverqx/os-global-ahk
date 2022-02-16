﻿; Silver Zachara <silver.zachara@gmail.com> 2018

#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance Force
#UseHook On


; Global
--------

SetTitleMatchMode, RegEx

CoordMode, ToolTip, Screen

; Higher value for SetKeyDelay
KeyDelayqBt := 25
KeyDelayDefault := 10

; mpc-hc
MpcHcPip := false
Zoom25Key := "!;"
Zoom50Key := "!{+}"
Zoom100Key := "!ě"
; Default to 50%
ZoomKey := Zoom50Key


; Toggle audio output related functions
; -------------------

; Audio output devices
OutputDevices := {}
; Toggle for switching two outputs
AudioOutputToggle := false

EnumerateAudioOutputs()


; Qt Creator OSD related
; -------------------

; OSD Text Control
QtCreatorOSDText := ""

CreateQtCreatorOSD()


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

; Hibernate (shift+calc)
+Launch_App2::
{
    Sleep, 2000
    DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    return
}

; Monitor on/off (alt+calc)
!Launch_App2::
{
    Sleep, 500
    Run, C:\Program Files (x86)\TC UP\MEDIA\Programs\Poweroff\poweroffcz.exe monitor_off,, Hide
    return
}

; Open ComputerOff
~LButton & WheelUp::
{
    ; If Options dialog is opened then activete it, instead of activate the Main window
    if WinExist("^Options$ ahk_class TFormOptionsDialog") || WinExist("^ComputerOff$") {
        WinActivate
        return
    }

    Run, C:\optx64\computeroff\ComputerOff.exe,,, PID
    WinWait, ahk_pid %PID%
    WinActivate, ahk_pid %PID%
    return
}

; Open Google Chrome
<#n::
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe,, Maximize
    return
}

; Open Google Chrome - Incognito window
+<#n::
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --incognito,, Maximize
    return
}

; Center Window
^+F7::CenterWindow()
; Max. Tile Window
^+F8::FullTileWindow()

; Toggle audio output Headphones / LG TV
^;::
{
    global AudioOutputToggle

    KeyWait, Control, T0.3
    KeyWait, `;, T0.3

    ; ErrorLevel == 1 if KeyWait was successful
    if (ErrorLevel) {
        ; Switch
        AudioOutputToggle := !AudioOutputToggle

        if (AudioOutputToggle)
            SetDefaultEndpoint(GetDeviceID(OutputDevices, "LG TV (NVIDIA High Definition Audio)"))
        else
            SetDefaultEndpoint(GetDeviceID(OutputDevices, "Headphones (Xbox Controller)"))
    } else
        ; Send original key combination further that triggered this function
        Send ^{;}

    return
}

; Trigger audio output devices enumeration
^+;::
{
    EnumerateAudioOutputs()

    return
}

; Restart AhkOsGlobal scheduled task
^+´::
{
    SoundBeep, 8000, 70
    Run, powershell.exe -WindowStyle Hidden -NoLogo E:\autohotkey\os-global\recompile.ps1,, Hide
    return
}

; Open Control Panel
!#i::
{
    Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Control Panel.lnk
}


; Leader key ctrl-g shortcuts
; ---------------------------

^g::
{
    Input, userInput, T.8 L1 M, {enter}.{esc}{tab}, a,b,c,č,d,f,g,k,l,m,n,p,q,r,s,t,w,u,y

    ; Send original shortcut on timeout
    if (ErrorLevel = "Timeout") {
        Send, ^g
        return
    }

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; With the ctrl modifier, has to be first
    ; Look appropriate number mappings at https://en.wikipedia.org/wiki/ASCII#Control_code_chart
    if (userInput == Chr(2))
        Scb()
    else if (userInput == Chr(4))
        Scd()
    else if (userInput == Chr(13))
        Scm()
    else if (userInput == Chr(19))
        Scs()
    else if (userInput == Chr(20))
        Sct()
    else if (userInput == Chr(22))
        Scv()
    else if (userInput == Chr(23))
        Scw()

    ; Without modifiers
    else if (userInput = "a")
        Sa()
    else if (userInput = "b")
        Sb()
    else if (userInput = "c")
        Sc()
    else if (userInput = "č")
        Sč()
    else if (userInput = "d")
        Sd()
    else if (userInput = "f")
        Sf()
    else if (userInput = "g")
        Sg()
    else if (userInput = "k")
        Sk()
    else if (userInput = "l")
        Sl()
    else if (userInput = "m")
        Sm()
    else if (userInput = "n")
        Sn()
    else if (userInput = "p")
        Sp()
    else if (userInput = "q")
        Sq()
    else if (userInput = "r")
        Sr()
    else if (userInput = "s")
        Ss()
    else if (userInput = "t")
        St()
    else if (userInput = "u")
        Su()
    else if (userInput = "w")
        Sw()
    else if (userInput = "y")
        Sy()

    return
}


; mpc-hc PIP mode
; -------------------

; Manually toogle MpcHcPip
#IfWinActive ahk_exe mpc-hc64.exe
^F8::
{
    MpcHcPip := !MpcHcPip

    value := MpcHcPip ? "enabled" : "disabled"
    MsgBox,, Toogle MpcHcPip flag, PIP mode : %value%, 1

    return
}

; Enable 25% zoom
#IfWinActive ahk_exe mpc-hc64.exe
^F9::
{
    ZoomKey := Zoom25Key
    return
}

; Enable 50% zoom
#IfWinActive ahk_exe mpc-hc64.exe
^F10::
{
    ZoomKey := Zoom50Key
    return
}

; Enable 100% zoom
#IfWinActive ahk_exe mpc-hc64.exe
^F11::
{
    ZoomKey := Zoom100Key
    return
}

; Disable PIP mode
#IfWinActive ahk_exe mpc-hc64.exe
^Enter::
{
    global MpcHcPip

    if (isWindowFullScreen("A") && MpcHcPip) {
        Send !{Enter}
        return
    }
    else if (MpcHcPip) {
        DisableMpcHcPip()
        MpcHcPip := false
        return
    }

    EnableMpcHcPip()
    MpcHcPip := true

    return
}


; qBittorrent Section
; -------------------

; Classic video
#IfWinActive ahk_exe qbittorrent.exe
^BackSpace::
{
    global KeyDelayqBt, KeyDelayDefault

    SetKeyDelay % KeyDelayqBt
    ; Assign seed tag
    Send, {AppsKey}{Down 6}{Right}{Up 2}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Open Torrent options modal
    Send, {Down 1}{Enter}
    Sleep, 120
    ; Assign to video category
    Send, {Tab}videos_H
    ; Download first and last pieces first
    Send, +{Tab 4}{Space}
    ; Download in sequential order
    Send, +{Tab}{Space}
    ; Close Torrent options modal
    Send, {Enter}
    SetKeyDelay % KeyDelayDefault

    return
}

; No-limit video
#IfWinActive ahk_exe qbittorrent.exe
^!BackSpace::
{
    global KeyDelayqBt, KeyDelayDefault

    SetKeyDelay % KeyDelayqBt
    ; Force resume
    Send, {AppsKey}{Down 2}{Enter}
    ; Assign seed and seed forced tags
    Send, {AppsKey}{Down 6}{Right}{Up}{Enter}{Up}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Open Torrent options modal
    Send, {Down 1}{Enter}
    Sleep, 120
    ; Assign to video category
    Send, {Tab}videos_H
    ; Download first and last pieces first
    Send, +{Tab 4}{Space}
    ; Download in sequential order
    Send, +{Tab}{Space}
    ; Set no share limit
    Send, +{Tab}{Down 2}{Up}{Space}
    ; Close Torrent options modal
    Send, {Enter}
    SetKeyDelay % KeyDelayDefault

    return
}

; When more torrents selected
#IfWinActive ahk_exe qbittorrent.exe
^+!BackSpace::
{
    global KeyDelayqBt, KeyDelayDefault

    SetKeyDelay % KeyDelayqBt
    ; Assign seed tag
    Send, {AppsKey}{Down 5}{Right}{Up 2}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Open Torrent options modal
    Send, {Down 1}{Enter}
    Sleep, 120
    ; Assign to video category
    Send, {Tab}videos_H
    ; Download first and last pieces first
    Send, +{Tab 4}{Space}
    ; Download in sequential order
    Send, +{Tab}{Space}
    ; Close Torrent options modal
    Send, {Enter}
    SetKeyDelay % KeyDelayDefault

    return
}

; No-limit if more torrents selected
#IfWinActive ahk_exe qbittorrent.exe
^!F12::
{
    global KeyDelayqBt, KeyDelayDefault

    SetKeyDelay % KeyDelayqBt
    ; Force resume
    Send, {AppsKey}{Down 2}{Enter}
    ; Assign seed and seed forced tags
    Send, {AppsKey}{Down 5}{Right}{Up}{Enter}{Up}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Open Torrent options modal
    Send, {Down 1}{Enter}
    Sleep, 120
    ; Assign to video category
    Send, {Tab}videos_H
    ; Download first and last pieces first
    Send, +{Tab 4}{Space}
    ; Download in sequential order
    Send, +{Tab}{Space}
    ; Set no share limit
    Send, +{Tab}{Down 2}{Up}{Space}
    ; Close Torrent options modal
    Send, {Enter}
    SetKeyDelay % KeyDelayDefault

    return
}

; Assign to video category
#IfWinActive ahk_exe qbittorrent.exe
^+BackSpace::
{
    global KeyDelayqBt, KeyDelayDefault

    SetKeyDelay % KeyDelayqBt
    ; Assign seed tag
    Send, {AppsKey}{Down 6}{Right}{Up 2}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Open Torrent options modal
    Send, {AppsKey}{Down 1}{Enter}
    Sleep, 120
    ; Assign to video category
    Send, {Tab}videos_H
    ; Close Torrent options modal
    Send, {Enter}
    SetKeyDelay % KeyDelayDefault

    return
}

; Preview
#IfWinActive ahk_exe qbittorrent.exe
F3::
{
    Send, {AppsKey}{Up 6}{Enter}
    return
}

; Preview when seeding
#IfWinActive ahk_exe qbittorrent.exe
F4::
{
    Send, {AppsKey}{Up 5}{Enter}
    return
}

; Limit download rate shortcuts
#IfWinActive ahk_exe qbittorrent.exe
^;::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}0{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^+::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}1024{Enter}
;    Send, {Tab 2}102{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ě::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}2048{Enter}
;    Send, {Tab 2}204{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^š::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}3072{Enter}
;    Send, {Tab 2}307{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^č::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}4096{Enter}
;    Send, {Tab 2}409{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ř::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}5120{Enter}
;    Send, {Tab 2}512{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ž::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}6144{Enter}
;    Send, {Tab 2}614{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ý::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}7168{Enter}
;    Send, {Tab 2}716{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^á::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}8192{Enter}
;    Send, {Tab 2}819{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^í::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}9216{Enter}
;    Send, {Tab 2}921{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^é::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 7}{Enter}
    Sleep, 120
    Send, {Tab 2}10240{Enter}
;    Send, {Tab 2}1024{Enter}
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


; Toggle audio output related functions
; -------------------

; Set the default audio device by device ID
SetDefaultEndpoint(DeviceID)
{
    IPolicyConfig := ComObjCreate("{870af99c-171d-4f9e-af0d-e63df40c2bc9}", "{F8679F50-850A-41CF-9C72-430F290290C8}")

    DllCall(NumGet(NumGet(IPolicyConfig+0) + 13 * A_PtrSize), "UPtr", IPolicyConfig, "UPtr", &DeviceID, "UInt", 0, "UInt")

    ObjRelease(IPolicyConfig)
}

; Get an audio device ID by a device name
GetDeviceID(Devices, Name)
{
    for DeviceName, DeviceID in Devices
        if (InStr(DeviceName, Name))
            return DeviceID
}

; Switch audio output TV / Headphones
; http://www.daveamenta.com/2011-05/programmatically-or-command-line-change-the-default-sound-playback-device-in-windows-7/
EnumerateAudioOutputs()
{
    global OutputDevices

    OutputDevices := {}

    IMMDeviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")

    ; IMMDeviceEnumerator::EnumAudioEndpoints
    ; eRender = 0, eCapture, eAll
    ; 0x1 = DEVICE_STATE_ACTIVE
    DllCall(NumGet(NumGet(IMMDeviceEnumerator + 0) + 3 * A_PtrSize), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 0x1, "UPtrP", IMMDeviceCollection, "UInt")
    ObjRelease(IMMDeviceEnumerator)

    ; IMMDeviceCollection::GetCount
    DllCall(NumGet(NumGet(IMMDeviceCollection + 0) + 3 * A_PtrSize), "UPtr", IMMDeviceCollection, "UIntP", Count, "UInt")
    Loop % (Count)
    {
        ; IMMDeviceCollection::Item
        DllCall(NumGet(NumGet(IMMDeviceCollection+0) + 4 * A_PtrSize), "UPtr", IMMDeviceCollection, "UInt", A_Index - 1, "UPtrP", IMMDevice, "UInt")

        ; IMMDevice::GetId
        DllCall(NumGet(NumGet(IMMDevice+0) + 5 * A_PtrSize), "UPtr", IMMDevice, "UPtrP", pBuffer, "UInt")
        DeviceID := StrGet(pBuffer, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "UPtr", pBuffer)

        ; IMMDevice::OpenPropertyStore
        ; 0x0 = STGM_READ
        DllCall(NumGet(NumGet(IMMDevice+0) + 4 * A_PtrSize), "UPtr", IMMDevice, "UInt", 0x0, "UPtrP", IPropertyStore, "UInt")
        ObjRelease(IMMDevice)

        ; IPropertyStore::GetValue
        VarSetCapacity(PROPVARIANT, A_PtrSize == 4 ? 16 : 24)
        VarSetCapacity(PROPERTYKEY, 20)
        DllCall("Ole32.dll\CLSIDFromString", "Str", "{A45C254E-DF1C-4EFD-8020-67D146A850E0}", "UPtr", &PROPERTYKEY)

        NumPut(14, &PROPERTYKEY + 16, "UInt")
        DllCall(NumGet(NumGet(IPropertyStore+0) + 5 * A_PtrSize), "UPtr", IPropertyStore, "UPtr", &PROPERTYKEY, "UPtr", &PROPVARIANT, "UInt")

        DeviceName := StrGet(NumGet(&PROPVARIANT + 8), "UTF-16")    ; LPWSTR PROPVARIANT.pwszVal
        DllCall("Ole32.dll\CoTaskMemFree", "UPtr", NumGet(&PROPVARIANT + 8))    ; LPWSTR PROPVARIANT.pwszVal
        ObjRelease(IPropertyStore)

        ObjRawSet(OutputDevices, DeviceName, DeviceID)
    }

    ObjRelease(IMMDeviceCollection)
}


; Qt Creator OSD related
; -------------------

; Create OSD window for the Qt Creator
CreateQtCreatorOSD()
{
    ; Can be any RGB color (it will be made transparent below)
    CustomColor := "000000"
    ; +ToolWindow avoids a taskbar button and an alt-tab menu item
    Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
    Gui, Color, %CustomColor%
    Gui, Font, s11 w400 q5, "Segoe UI"

    Gui, Add, Text, vQtCreatorOSDText ceeeeee W236 R1

    ; Make all pixels of this color transparent and make the text itself translucent (150)
    WinSet, TransColor, %CustomColor% 150

    ; Update every 200ms
    SetTimer, UpdateOSD, 200
    ; Make the first update immediate rather than waiting for the timer
    UpdateOSD()
    ; NoActivate avoids deactivating the currently active window
    Gui, Show, x600 y-5 NoActivate
    return
}

; Update OSD on the base of currently active window
UpdateOSD()
{
    ; Don't hide OSD if is displayed task switcher by alt+tab
    if WinActive("ahk_class MultitaskingViewFrame")
        return

    ; Take also some delay into account
    Sleep, 130

    if WinActive("ahk_class MultitaskingViewFrame")
        return

    WinGetActiveTitle, Title
    result := RegExMatch(Title, "O)(?:.* [@-] )?(.*[^\)])(?:\)? - Qt Creator)$", Match)

    ; If a title was not found then show nothing
    if (result == 0 || Match.Count() != 1)
        GuiControl,, QtCreatorOSDText,
    else
        GuiControl,, QtCreatorOSDText, % Match[1]
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

; Checks if the specified window is in the fullscreen mode
IsWindowFullScreen(winTitle) 
{
    winId := WinExist(winTitle)

	if (!winId)
		return false

	WinGet style, Style, ahk_id %winId%
	WinGetPos x, y, width, height, ahk_id %winId%

	; 0x800000 is WS_BORDER.
	; 0x20000000 is WS_MINIMIZE.
	; no border and not minimized
	return !(style & 0x20800000 || x > 0 || y > 0 || width < A_ScreenWidth || height < A_ScreenHeight)
}


; Leader key ctrl-g related
; -------------------------

; With the ctrl modifier
; Manjaro vmware
Scb()
{
    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, c,d,g,p,r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    if (userInput = "c")
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmb.ps1,, Hide
    else if (userInput = "d") {
        MsgBox,, Manjaro, Detaching Manjaro KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmdb.ps1,, Hide
    } else if (userInput = "g") {
        if WinExist("^Manjaro - VMware KVM$")
            WinActivate
    }
    else if (userInput = "p") {
        MsgBox,, Manjaro, Preferences for Manjaro KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpb.ps1,, Hide
    }
    else if (userInput = "r") {
        MsgBox,, Manjaro, Starting Manjaro KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmrb.ps1,, Hide
    } else if (userInput = "s") {
        MsgBox,, Manjaro, Suspending Manjaro KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmsb.ps1,, Hide
    }

    return
}
; Ubuntu Docker Server vmware
Scd()
{
    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    if (userInput = "r") {
        MsgBox,, Ubuntu Docker Server, Starting Ubuntu Docker KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmrd.ps1,, Hide
    } else if (userInput = "s") {
        MsgBox,, Ubuntu Docker Server, Suspending Ubuntu Docker KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmsd.ps1,, Hide
    }

    return
}
; TamperMonkey
Scm()
{
    Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\TamperMonkey.lnk
}
; SumatraPDF
Scs()
{
    if WinExist("SumatraPDF")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\SumatraPDF.lnk
}
; Sk-CzTorrent
Sct()
{
    if WinExist("(?:^Sk-CzTorrent \||\| SkTorrent\.eu)")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\SkTorrent.lnk
}
; Gentoo vmware
Scv()
{
    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, c,d,g,h,p,r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    if (userInput = "c")
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmg.ps1,, Hide
    else if (userInput = "d") {
        MsgBox,, Gentoo, Detaching Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmdg.ps1,, Hide
    } else if (userInput = "g") {
        if WinExist("^gentoo - VMware KVM$")
            WinActivate
    }
    else if (userInput = "h") {
        if WinExist("^Gentoo KVM$")
            WinActivate
        else
            Run, wt --title "Gentoo KVM" pwsh -NoLogo -nop -c ssh silverqx@merydeye-gentoo -t htop
    }
    else if (userInput = "p") {
        MsgBox,, Gentoo, Preferences for Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpg.ps1,, Hide
    }
    else if (userInput = "r") {
        MsgBox,, Gentoo, Starting Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmrg.ps1,, Hide
    } else if (userInput = "s") {
        MsgBox,, Gentoo, Suspending Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmsg.ps1,, Hide
    }

    return
}
; Windows vmware
Scw()
{
    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, c,d,r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    if (userInput = "c")
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmw.ps1,, Hide
    else if (userInput = "d") {
        MsgBox,, Windows, Detaching Windows KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmdw.ps1,, Hide
    } else if (userInput = "r") {
        MsgBox,, Windows, Starting Windows KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmrw.ps1,, Hide
    } else if (userInput = "s") {
        MsgBox,, Windows, Suspending Windows KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmsw.ps1,, Hide
    }

    return
}

; Without any modifier
; access
Sa()
{
    if WinExist("__prístupy - Google Sheets")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\access.lnk
}
; bash_or_cmd_useful_commands
Sb()
{
    if WinExist("bash_or_cmd_useful_commands")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\bash_or_cmd_useful_commands.lnk
}
; open new čsfd.cz page in chrome
Sc()
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe,, Maximize
    Sleep, 250
    Send, csfd.cz{Enter}
}
; čsfd.cz search in chrome
Sč()
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe,, Maximize
    Sleep, 250
    Send, csfd{Tab}
}
; Dolby Access
Sd()
{
    if WinExist("Dolby Access")
        WinActivate
    else
        Run, shell:AppsFolder\DolbyLaboratories.DolbyAccess_rz1tebttyb220!App
}
; Facebook
Sf()
{
    if WinExist("Facebook")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Facebook.lnk
}
; Grammly
Sg()
{
    if WinExist("Free Grammar Checker | Grammly")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Grammarly Checker.lnk
}
; Skylink
Sk()
{
    Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Skylink.lnk
}
; SQLiteStudio
Sl()
{
    if WinExist("SQLiteStudio (.*)")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps\SQLiteStudio.lnk
}
; Messenger
Sm()
{
    if WinExist("Messenger (.*)")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Messenger.lnk
}
; Notepad++
Sn()
{
    if WinExist(" - Notepad++")
        WinActivate
    else
        Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Notepad++.lnk
}
; pgAdmin
Sp()
{
    if WinExist("^pgAdmin 4$")
        WinActivate
    else
        Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 13\pgAdmin 4.lnk
}
; qMedia
Sq()
{
    if WinExist("i)^ *qMedia v\d+\.\d+\.\d+$")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\__my__\qMedia.lnk
}
; Registry Editor
Sr()
{
    if WinExist("i)^Registry Editor$")
        WinActivate
    else
        Run, %A_WinDir%\regedit.exe
}
; SmartGit
Ss()
{
    if WinExist("i)- SmartGit.*for non-commercial use only")
        WinActivate
    else
        Run, c:\ProgramData\Microsoft\Windows\Start Menu\Programs\SmartGit\SmartGit.lnk
}
; Microsoft To Do
St()
{
    if WinExist("Microsoft To Do")
        WinActivate
    else
        Run, shell:AppsFolder\Microsoft.Todos_8wekyb3d8bbwe!App
}
; Control Panel - Sound Playback devices
Su()
{
    if WinExist("^Sound$")
        WinActivate
    else {
        Run, C:\Windows\System32\rundll32.exe shell32.dll`,Control_RunDLL mmsys.cpl`,`,playback,,, PID
        WinWait, ahk_pid %PID%
        WinActivate, ahk_pid %PID%
        CenterWindow()
    }
}
; WinMerge
Sw()
{
    if WinExist("^WinMerge")
        WinActivate
    else
        Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WinMerge\WinMerge.lnk
}
; Youtube
Sy()
{
    Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\YouTube.lnk
}


; mpc-hc PIP mode
; -------------------

EnableMpcHcPip()
{
    global ZoomKey
    global KeyDelayqBt, KeyDelayDefault

    SetKeyDelay % KeyDelayqBt

    ; Enable StayOnTop and Hide Playlist
    Send ^a^!a
    ; Compact mode
    Send {+}
    ; Zoom by ZoomKey variable
    Send % ZoomKey

    SetKeyDelay % KeyDelayDefault
}

DisableMpcHcPip()
{
    global KeyDelayqBt, KeyDelayDefault

    SetKeyDelay % KeyDelayqBt

    ; Disable StayOnTop and Fullscreen
    Send ^a!{Enter}
    ; Normal mode
    Send š
    ; Show playlist
    Send ^!a

    SetKeyDelay % KeyDelayDefault
}
