﻿; Silver Zachara <silver.zachara@gmail.com> 2018

#Persistent
#UseHook On
#SingleInstance Force
#NoTrayIcon


; Global
--------

SetTitleMatchMode, RegEx


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

; Open ComputerOff
~LButton & WheelUp::
{
    Run, C:\optx64\computeroff\ComputerOff.exe,,, PID
    WinWait, ahk_pid %PID%
    WinActivate, ahk_pid %PID%
    return
}

; Open Google Chrome
<#n::
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe, , Maximize
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

; Re-initialize OSD
^!F1::
{
    CreateQtCreatorOSD()

    return
}


; Leader key ctrl-g shortcuts
; ---------------------------

^g::
{
    Input, userInput, T.8 L1 M, {enter}.{esc}{tab}, a,b,d,f,g,l,m,n,s,t,w,u,y

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
    if (userInput == Chr(19)) {
        Scs()
    }

    ; Without modifiers
    else if (userInput = "a")
        Sa()
    else if (userInput = "b")
        Sb()
    else if (userInput = "d")
        Sd()
    else if (userInput = "f")
        Sf()
    else if (userInput = "g")
        Sg()
    else if (userInput = "l")
        Sl()
    else if (userInput = "m")
        Sm()
    else if (userInput = "n")
        Sn()
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
    WinGetActiveTitle, Title

    if (InStr(Title, "TinyOrm - Qt Creator", true))
        GuiControl,, QtCreatorOSDText, TinyORM
    else if (InStr(Title, "TinyOrmPlayground - Qt Creator", true))
        GuiControl,, QtCreatorOSDText, TinyOrmPlayground
    else if (InStr(Title, "TinyOrmPlayground_RelationTypes - Qt Creator", true))
        GuiControl,, QtCreatorOSDText, TinyOrmPlayground_RelationTypes
    else
        GuiControl,, QtCreatorOSDText,
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


; Leader key ctrl-g related
; -------------------------

; With the ctrl modifier
; SumatraPDF
Scs()
{
    if WinExist("SumatraPDF")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\SumatraPDF.lnk
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
; SmartGit
Ss()
{
    if WinExist("- SmartGit.*\(for non-commercial use only\)")
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
    if WinExist("WinMerge")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\WinMerge\WinMerge.lnk
}
; Youtube
Sy()
{
    Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\YouTube.lnk
}
