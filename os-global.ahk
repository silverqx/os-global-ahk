; Silver Zachara <silver.zachara@gmail.com> 2018

#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance Force
#UseHook On


; Global
--------

SetTitleMatchMode, RegEx

; Higher value for SetKeyDelay
KeyDelayqBt := 25
KeyDelayDefault := 10

; mpc-hc
MpcHcPip := false
MpcHcZoom25Key := "!;"
MpcHcZoom50Key := "!{+}"
MpcHcZoom100Key := "!ě"
; Default to 25%
MpcHcZoomKey := MpcHcZoom25Key
; Default width in normal mode
MpcHcDefaultNormalWidth := 1240
; Default pip mode width
MpcHcDefaultPipWidth := 420
; Custom position and size
MpcHcPipX := ""
MpcHcPipY := ""
MpcHcPipWidth := ""
MpcHcPipHeight := ""

; The time when the PC got to sleep state, used by open Skylink
SuspendTime := ""
; Skylink open time, to avoid opening Skylink two times
OpenTime := ""

; Pause/Unpause vmwrun.exe
VmrunPauseToggle := false

; Toggle audio output related functions
; -------------------

; Audio output devices
OutputDevices := {}
; Toggle for switching two outputs
AudioOutputToggle := false

EnumerateAudioOutputs()


; Open the Skylink Prima ZOOM on wakeup from suspend
; -------------------

; Listen to the Windows power event WM_POWERBROADCAST (ID: 0x218)
OnMessage(0x218, "OnWmPowerBroadcast")

OnWmPowerBroadcast(wParam, lParam)
{
    global SuspendTime, OpenTime

    WriteLogSkylink("begin; wParam = " wParam "; lParam = " lParam)

    ; https://learn.microsoft.com/en-us/windows/win32/power/wm-powerbroadcast
    ; https://www.autohotkey.com/board/topic/19984-running-commands-on-standby-hibernation-and-resume-events/
    ; Nothing to do, I'm only checking the resume and suspend states
    if (wParam != 4 && wParam != 7 && wParam != 18) {
        WriteLogSkylink("wParam != 4 && wParam != 7 && wParam != 18; return")
        return false
    }

    ; PBT_APMSUSPEND 0x0004
    ; Save a time when the PC got to the suspend state, used later for compare
    if (wParam = 4) {
        SuspendTime := A_Now
        WriteLogSkylink("wParam = 4; SuspendTime := " SuspendTime "; return")
        return false
    }

    ; PBT_APMRESUMESUSPEND 0x0007 or PBT_APMRESUMEAUTOMATIC 0x0012 (18) section
    ; Prepare the 15 minutes later time and during the day variables
    later15Mins := SuspendTime
    later15Mins += 15, Minutes
    isDuringDay := A_Hour between 8 and 22

    ; Open Skylink even during wake up between 08-22 hours, but it must sleep longer than 15 minutes,
    ; eg. when I come back from outside or whatever, but not at evening or midnight,
    ; because something can wake up PC and I don't want to open Skylink in these cases.
    if (!isDuringDay || (isDuringDay && A_Now < later15Mins)) {
    ; I'm waking PC at 08:14, so open Skylink only at this time
    ;if (A_Hour != 8 || A_Min not between 11 and 17)
        WriteLogSkylink("!isDuringDay || (isDuringDay && A_Now < later15Mins); isDuringDay := " isDuringDay "; later15Mins := " later15Mins "; return")
        return false
    }

    ; Prepare 5 second interval to avoid opening Skylink two times.
    ; Windows sends both 7 and 18 resume codes during resume WOL and timer resume, and
    ; it sends only 7 resume code if resumed using the keyboard.
    if (OpenTime != "") {
        ; Now happend that it last 1m35s between 18 and 7 resume codes,
        ; resume code 7 was fired 1m35s later after the 18 code,
        ; so I'm increasing this interval to 3min.
        openLaterInterval := OpenTime
        openLaterInterval += 3, Minutes
        WriteLogSkylink("Checking openLaterInterval : " A_Now " < " openLaterInterval)

        if (A_Now < openLaterInterval) {
            WriteLogSkylink("A_Now < openLaterInterval; return")
            return false
        }
    }
    else
        WriteLogSkylink("OpenTime = """"")

    WriteLogSkylink("openSkylink")

    OpenTime := A_Now

    Sleep, 25000
    Run, C:\Program Files (x86)\TC UP\MEDIA\Programs\Poweroff\poweroffcz.exe monitor_on,, Hide
    Sleep 10000
    openSkylinkPrimaZoom()
    Sleep, 60000
    Send, f

    return false
}

; Write to the Open Skylink log file
WriteLogSkylink(text) {
    WriteLog(text, "E:/tmp/openskylink.log")
}

openSkylinkPrimaZoom()
{
    Splus(false)
}


; Testing
; -------------------

;^!+F9::
;{
;    MsgBox % xyz
;
;    return
;}

;    MsgBox % A_Now . "`n" . xyz . "`n" . later10Mins . "`n" . (A_Now > later10Mins)
;
;    Run, E:\autohotkey\os-global\PauseVideoAtSuspend.ahk,, Hide
;    WinGetTitle, title, A
;
;    MsgBox % InStr(title, " - YouTube - Google Chrome", true)
;    MsgBox % InStr(title, "Skylink - ", true)
;
;    if (InStr(title, "Skylink - ", true) != 1 && InStr(title, " - YouTube - Google Chrome", true) = false) {
;        MsgBox % "return"
;        return
;    }
;    else
;        MsgBox % "sent"
;
;    Send ^!+p
;
;    if (A_Hour != 8 || A_Min not between 11 and 17)
;        MsgBox % "Yes"
;    else
;        MsgBox % "No"
;
;    return
;}


; General Section
; -------------------

; Mouse shortcut for ctrl+home/end
~LButton & WheelRight::
{
    Send ^{Home}
    return
}
~LButton & WheelLeft::
{
    Send ^{End}
    return
}

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

; Show Windows Start Menu
~LButton & WheelDown::Send {LWin}

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

; Restart the AhkOsGlobal scheduled task
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

; Disable printing emoji-s for alt-0-9 🙏

!Numpad1::Send, !1
!Numpad2::Send, !2
!Numpad3::Send, !3
!Numpad4::Send, !4
!Numpad5::Send, !5
!Numpad6::Send, !6
!Numpad7::Send, !7
!Numpad8::Send, !8
!Numpad9::Send, !9


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
    else if (userInput == Chr(15))
        Sco()
    else if (userInput == Chr(16))
        Scp()
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
    else if (userInput = "v")
        Sv()
    else if (userInput = "w")
        Sw()
    else if (userInput = "y")
        Sy()
    else if (userInput = "+")
        Splus(true)

    return
}


; mpc-hc PIP mode
; -------------------

; Manually toogle MpcHcPip
#IfWinActive ahk_exe mpc-hc64.exe
^F7::
{
    global MpcHcPip

    MpcHcPip := !MpcHcPip

    value := MpcHcPip ? "enabled" : "disabled"
    MsgBox,, Toogle MpcHcPip flag, PIP mode : %value%, 1

    return
}

; Reset x, y restore positions and sizes for pip mode
#IfWinActive ahk_exe mpc-hc64.exe
^F8::
{
    MpcHcResetPipPositions()

    MsgBox,, Reset PIP mode positions, Reset x`, y restore positions and sizes, 1

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
    ; ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    else if (!isWindowFullScreen("A") && isNoBorderWindow("A") && !MpcHcPip) {
        MpcHcDisablePip()
        return
    }
    else if (MpcHcPip) {
        MpcHcDisablePip()
        MpcHcPip := false
        return
    }

    MpcHcEnablePip()
    MpcHcPip := true

    return
}

#IfWinActive ahk_exe mpc-hc64.exe
^!Left::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen("A") && isNoBorderWindow("A") && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveLeft()

    return
}

#IfWinActive ahk_exe mpc-hc64.exe
^!Right::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen("A") && isNoBorderWindow("A") && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveRight()

    return
}

#IfWinActive ahk_exe mpc-hc64.exe
^!Up::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen("A") && isNoBorderWindow("A") && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveTop()

    return
}

#IfWinActive ahk_exe mpc-hc64.exe
^!Down::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen("A") && isNoBorderWindow("A") && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveBottom()

    return
}


; qBittorrent Section
; -------------------

; Classic video
#IfWinActive ahk_exe qbittorrent.exe
^BackSpace::
{
    ; Assign to video category
    Send, {AppsKey}{Down 7}{Right}{Up}{Enter}
    ; Assign seed tag
    Send, {AppsKey}{Down 8}{Right}{Up 2}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Download in sequential order
    Send, {Down 4}{Enter}
    ; Download first and last pieces first
    Send, {AppsKey}{Up 7}{Enter}

    return
}

; No-limit video
#IfWinActive ahk_exe qbittorrent.exe
^!BackSpace::
{
    ; Force resume
    Send, {AppsKey}{Down 2}{Enter}
    ; Assign to video category
    Send, {AppsKey}{Down 7}{Right}{Up}{Enter}
    ; Assign seed and force seed tags
    Send, {AppsKey}{Down 8}{Right}{Up}{Enter}{Up}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Download in sequential order
    Send, {Down 4}{Enter}
    ; Download first and last pieces first
    Send, {AppsKey}{Up 7}{Enter}

    ; Open Torrent options modal
    Send, {AppsKey}{Up 10}{Enter}
    SetKeyDelay % KeyDelayqBt
    Sleep, 120
    ; Set no share limit
    Send, {Tab 6}{Down 2}{Up}{Space}
    ; Close Torrent options modal
    Send, {Enter}
    SetKeyDelay % KeyDelayDefault

    return
}

; When more torrents selected
#IfWinActive ahk_exe qbittorrent.exe
^+!BackSpace::
{
    ; Assign to video category
    Send, {AppsKey}{Down 6}{Right}{Up}{Enter}
    ; Assign seed tag
    Send, {AppsKey}{Down 7}{Right}{Up 2}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Download in sequential order
    Send, {Down 4}{Enter}
    ; Download first and last pieces first
    Send, {AppsKey}{Up 7}{Enter}

    return
}

; No-limit if more torrents selected
#IfWinActive ahk_exe qbittorrent.exe
^!F12::
{
    ; Force resume
    Send, {AppsKey}{Down 2}{Enter}
    ; Assign to video category
    Send, {AppsKey}{Down 6}{Right}{Up}{Enter}
    ; Assign seed and force seed tags
    Send, {AppsKey}{Down 7}{Right}{Up}{Enter}{Up}{Enter}
    ; Close Tags sub-menu
    Send, {Esc}
    ; Download in sequential order
    Send, {Down 4}{Enter}
    ; Download first and last pieces first
    Send, {AppsKey}{Up 7}{Enter}

    ; Open Torrent options modal
    Send, {AppsKey}{Up 10}{Enter}
    SetKeyDelay % KeyDelayqBt
    Sleep, 120
    ; Set no share limit
    Send, {Tab 6}{Down 2}{Up}{Space}
    ; Close Torrent options modal
    Send, {Enter}
    SetKeyDelay % KeyDelayDefault

    return
}

; Assign to video category
#IfWinActive ahk_exe qbittorrent.exe
^+BackSpace::
{
    ; Assign to video category
    Send, {AppsKey}{Down 7}{Right}{Up}{Enter}
    ; Assign seed tag
    Send, {AppsKey}{Down 8}{Right}{Up 2}{Enter}
    ; Close Tags sub-menu and context menu
    Send, {Esc}{Esc}

    return
}

; Preview
#IfWinActive ahk_exe qbittorrent.exe
F3::
{
    Send, {AppsKey}{Up 9}{Enter}
    return
}

; Preview when seeding
#IfWinActive ahk_exe qbittorrent.exe
F4::
{
    Send, {AppsKey}{Up 6}{Enter}
    return
}

; Limit download rate shortcuts
#IfWinActive ahk_exe qbittorrent.exe
^;::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}0{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^+::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}1024{Enter}
;    Send, {Tab 2}102{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ě::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}2048{Enter}
;    Send, {Tab 2}204{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^š::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}3072{Enter}
;    Send, {Tab 2}307{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^č::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}4096{Enter}
;    Send, {Tab 2}409{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ř::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}5120{Enter}
;    Send, {Tab 2}512{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ž::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}6144{Enter}
;    Send, {Tab 2}614{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^ý::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}7168{Enter}
;    Send, {Tab 2}716{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^á::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}8192{Enter}
;    Send, {Tab 2}819{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^í::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
    Sleep, 120
    Send, {Tab 2}9216{Enter}
;    Send, {Tab 2}921{Enter}
    return
}

#IfWinActive ahk_exe qbittorrent.exe
^é::
{
    ; Open Torrent options modal
    Send, {AppsKey}{Down 10}{Enter}
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

; Checks if the specified window has no borders
IsNoBorderWindow(winTitle)
{
    winId := WinExist(winTitle)

	if (!winId)
		return false

	WinGet style, Style, ahk_id %winId%

	; 0x800000 is WS_BORDER.
	; 0x20000000 is WS_MINIMIZE.
	; no border and not minimized
	return !(style & 0x20800000)
}


; Leader key ctrl-g related
; -------------------------

; With the ctrl modifier
; Manjaro vmware
Scb()
{
    global VmrunPauseToggle

    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, c,d,g,p,r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    ; Pause/Unpause
    if (userInput = "a") {
        ; Switch
        VmrunPauseToggle := !VmrunPauseToggle

        if (VmrunPauseToggle) {
            MsgBox,, Manjaro, Paused Manjaro KVM, 1
            Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpab.ps1,, Hide
        }
        else {
            MsgBox,, Manjaro, Unpaused Manjaro KVM, 1
            Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpab.ps1,, Hide
        }
    }
    ; Connect
    else if (userInput = "c")
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmb.ps1,, Hide
    ; Detach
    else if (userInput = "d") {
        MsgBox,, Manjaro, Detaching Manjaro KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmdb.ps1,, Hide
    }
    ; WinActivate
    else if (userInput = "g") {
        if WinExist("^Manjaro - VMware KVM$")
            WinActivate
    }
    ; Preferences
    else if (userInput = "p") {
        MsgBox,, Manjaro, Preferences for Manjaro KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpb.ps1,, Hide
    }
    ; Run
    else if (userInput = "r") {
        MsgBox,, Manjaro, Starting Manjaro KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmrb.ps1,, Hide
    }
    ; Suspend
    else if (userInput = "s") {
        MsgBox,, Manjaro, Suspending Manjaro KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmsb.ps1,, Hide
    }

    return
}
; Ubuntu Docker Server vmware
Scd()
{
    global VmrunPauseToggle

    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    ; Pause/Unpause
    if (userInput = "a") {
        ; Switch
        VmrunPauseToggle := !VmrunPauseToggle

        if (VmrunPauseToggle) {
            MsgBox,, Ubuntu Docker Server, Paused Ubuntu Docker KVM, 1
            Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpad.ps1,, Hide
        }
        else {
            MsgBox,, Ubuntu Docker Server, Unpaused Ubuntu Docker KVM, 1
            Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpad.ps1,, Hide
        }
    }
    ; Connect
    else if (userInput = "c")
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmdocker.ps1,, Hide
    ; Detach
    else if (userInput = "d") {
        MsgBox,, Ubuntu Docker Server, Detaching Ubuntu Docker KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmdd.ps1,, Hide
    }
    ; Run
    else if (userInput = "r") {
        MsgBox,, Ubuntu Docker Server, Starting Ubuntu Docker KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmrd.ps1,, Hide
    }
    ; Suspend
    else if (userInput = "s") {
        MsgBox,, Ubuntu Docker Server, Suspending Ubuntu Docker KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmsd.ps1,, Hide
    }

    return
}
; TamperMonkey
Scm()
{
    if WinExist("^TamperMonkey")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\TamperMonkey.lnk
}
; GitHub
Sco()
{
    if WinExist("^GitHub")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\GitHub.lnk
}
; pgAdmin
Scp()
{
    if WinExist("^pgAdmin 4$")
        WinActivate
    else
        Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 15\pgAdmin 4.lnk
}
; SumatraPDF
Scs()
{
    if WinExist("SumatraPDF")
        WinActivate
    else
        Run, C:\ProgramData\Microsoft\Windows\Start Menu\SumatraPDF.lnk
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
    global VmrunPauseToggle

    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, c,d,g,h,p,r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    ; Pause/Unpause
    if (userInput = "a") {
        ; Switch
        VmrunPauseToggle := !VmrunPauseToggle

        if (VmrunPauseToggle) {
            MsgBox,, Gentoo, Paused Gentoo KVM, 1
            Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpag.ps1,, Hide
        }
        else {
            MsgBox,, Gentoo, Unpaused Gentoo KVM, 1
            Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpag.ps1,, Hide
        }
    }
    ; Connect
    else if (userInput = "c")
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmg.ps1,, Hide
    ; Detach
    else if (userInput = "d") {
        MsgBox,, Gentoo, Detaching Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmdg.ps1,, Hide
    }
    ; WinActivate
    else if (userInput = "g") {
        if WinExist("^gentoo - VMware KVM$")
            WinActivate
    }
    ; htop
    else if (userInput = "h") {
        if WinExist("^Gentoo KVM$")
            WinActivate
        else
            Run, wt --title "Gentoo KVM" pwsh -NoLogo -nop -c ssh silverqx@merydeye-gentoo -t htop
    }
    ; Preferences
    else if (userInput = "p") {
        MsgBox,, Gentoo, Preferences for Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpg.ps1,, Hide
    }
    ; Run
    else if (userInput = "r") {
        MsgBox,, Gentoo, Starting Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmrg.ps1,, Hide
    }
    ; Suspend
    else if (userInput = "s") {
        MsgBox,, Gentoo, Suspending Gentoo KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmsg.ps1,, Hide
    }

    return
}
; Windows vmware
Scw()
{
    global VmrunPauseToggle

    Input, userInput, T.9 L1 M, {enter}.{esc}{tab}, c,d,r,s

    if (ErrorLevel = "NewInput")
        return
    ; Terminated by end key
    if InStr(ErrorLevel, "EndKey:")
        return

    ; Without modifiers
    ; Pause/Unpause
    if (userInput = "a") {
        ; Switch
        VmrunPauseToggle := !VmrunPauseToggle

        if (VmrunPauseToggle) {
            MsgBox,, Windows, Paused Windows KVM, 1
            Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpaw.ps1,, Hide
        }
        else {
            MsgBox,, Windows, Unpaused Windows KVM, 1
            Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpaw.ps1,, Hide
        }
    }
    ; Connect
    else if (userInput = "c")
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmw.ps1,, Hide
    ; Detach
    else if (userInput = "d") {
        MsgBox,, Windows, Detaching Windows KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmdw.ps1,, Hide
    }
    ; Run
    else if (userInput = "r") {
        MsgBox,, Windows, Starting Windows KVM, 1
        Run, powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmrw.ps1,, Hide
    }
    ; Suspend
    else if (userInput = "s") {
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
; Google Sheets - bash_or_cmd_useful_commands
Sb()
{
    if WinExist("bash_or_cmd_useful_commands")
        WinActivate
    else
        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Google Sheets.lnk
;        Run, C:\Users\Silver Zachara\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\bash_or_cmd_useful_commands.lnk
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
        Run, shell:AppsFolder\FACEBOOK.317180B0BB486_8xx8rvfyw5nnt!App
}
; Notepad++
Sn()
{
    if WinExist(" - Notepad++")
        WinActivate
    else
        Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Notepad++.lnk
}
; PhpStorm
Sp()
{
    Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains\PhpStorm 2021.2.1.lnk
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
    if WinExist("i)- SmartGit .* Non-Commercial$")
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
; Settings - Volume Mixer
Sv()
{
    Run, C:\Windows\explorer.exe ms-settings:apps-volume
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
; Open Skylink Prima ZOOM
Splus(fullscreen := false)
{
    Run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe https://livetv.skylink.cz/?qaction=wakeup --new-window,, Maximize

    if (!fullscreen)
        return

    Sleep, 15000
    Send, f
}


; mpc-hc PIP mode
; -------------------

MpcHcEnablePip()
{
    global MpcHcZoomKey, MpcHcDefaultPipWidth
    global KeyDelayqBt, KeyDelayDefault
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

	if (!WinExist("A"))
        return

    SetKeyDelay % KeyDelayqBt

    ; Enable StayOnTop and Hide Playlist
    Send ^a^!a
    ; Compact mode
    Send {+}

    ; Top right corner - default position
    if (MpcHcPipX == "" && MpcHcPipY == "") {
        ; Zoom by MpcHcZoomKey variable
        Send % MpcHcZoomKey
        Sleep 60

        ; Compute width and height, mpc-hc sets correct aspect ratio so use it to compute correct height
        WinGetPos,,, width, height
        newWidth := MpcHcDefaultPipWidth
        newHeight := MpcHcDefaultPipWidth / (width / height)

        WinMove % ahk_id,, A_ScreenWidth - MpcHcDefaultPipWidth - 20, 20, newWidth, newHeight
    }
    ; Restore custom position and size
    else {
        ; Disable Fullscreen
        Send !{Enter}

        WinMove % ahk_id,, MpcHcPipX, MpcHcPipY, MpcHcPipWidth, MpcHcPipHeight
    }

    SetKeyDelay % KeyDelayDefault
}

MpcHcDisablePip()
{
    global KeyDelayqBt, KeyDelayDefault
    global MpcHcZoomKey, MpcHcDefaultNormalWidth
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

	if (!WinExist("A"))
        return

    SetKeyDelay % KeyDelayqBt

    ; Store x and y positions and sizes in pip mode only if the pip window has been moved or resized
    WinGetPos x, y, width, height

    if (x != (A_ScreenWidth - width - 20) || y != 20 || MpcHcPipWidth != width || MpcHcPipHeight != height) {
        MpcHcPipX := x
        MpcHcPipY := y
        MpcHcPipWidth := width
        MpcHcPipHeight := height
    }

    ; Dummy shortcut to fix W11 alt bug
    Send !-
    ; Disable StayOnTop
    Send ^a
    ; Normal mode
    Send š
    ; Zoom by MpcHcZoomKey variable
    Send % MpcHcZoomKey
    ; Show playlist
    Send ^!a

    ; Compute width and height, mpc-hc sets correct aspect ratio so use it to compute correct height
    Sleep 60
    WinGetPos,,, width, height
    newWidth := MpcHcDefaultNormalWidth
    newHeight := MpcHcDefaultNormalWidth / (width / height)

    ; Default position I want to
    WinMove % ahk_id,, 60, 40, newWidth, newHeight

    ; Fullscreen
    Send !{Enter}

    SetKeyDelay % KeyDelayDefault
}

MpcHcResetPipPositions()
{
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    MpcHcPipX := ""
    MpcHcPipY := ""
    MpcHcPipWidth := ""
    MpcHcPipHeight := ""
}

MpcHcMoveLeft()
{
    if (!WinExist("A"))
        return

    WinGetPos x, y, width, height

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (top, bottom) of pip window
    result := RegExMatch(snapPosition, "O)([TLBR][a-z]+)(?:[TLBR][a-z]+)", Match)

    moveToX := 20

    if (Match[1] == "Top")
        moveToY := 20

    else if (Match[1] == "Bottom")
        moveToY := A_ScreenHeight - height - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove % moveToX, moveToY
}

MpcHcMoveRight()
{
    if (!WinExist("A"))
        return

    WinGetPos x, y, width, height

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (top, bottom) of pip window
    result := RegExMatch(snapPosition, "O)([TLBR][a-z]+)(?:[TLBR][a-z]+)", Match)

    moveToX := A_ScreenWidth - width - 20

    if (Match[1] == "Top")
        moveToY := 20

    else if (Match[1] == "Bottom")
        moveToY := A_ScreenHeight - height - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove % moveToX, moveToY
}

MpcHcMoveTop()
{
    if (!WinExist("A"))
        return

    WinGetPos x, y, width, height

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (left, right) of pip window
    result := RegExMatch(snapPosition, "O)(?:[TLBR][a-z]+)([TLBR][a-z]+)", Match)

    moveToY := 20

    if (Match[1] == "Left")
        moveToX := 20

    else if (Match[1] == "Right")
        moveToX := A_ScreenWidth - width - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove % moveToX, moveToY
}

MpcHcMoveBottom()
{
    if (!WinExist("A"))
        return

    WinGetPos x, y, width, height

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (left, right) of pip window
    result := RegExMatch(snapPosition, "O)(?:[TLBR][a-z]+)([TLBR][a-z]+)", Match)

    moveToY := A_ScreenHeight - height - 20

    if (Match[1] == "Left")
        moveToX := 20

    else if (Match[1] == "Right")
        moveToX := A_ScreenWidth - width - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove % moveToX, moveToY
}

; Infer current pip window position
MpcHcInferPreSnapPosition(x, y, width, height)
{
    result := ""

    if (y + height / 2 < A_ScreenHeight / 2)
        result .= "Top"
    else
        result .= "Bottom"

    if (x + width / 2 < A_ScreenWidth / 2)
        result .= "Left"
    else
        result .= "Right"

    return result
}


; Others
; -------------------

; Write to the given log file
WriteLog(text, logFilepath) {
	FileAppend, % A_NowUTC ": " text "`n", %logFilepath%
}
