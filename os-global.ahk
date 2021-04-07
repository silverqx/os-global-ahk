; Silver Zachara <silver.zachara@gmail.com> 2018

#Persistent
#UseHook On
#SingleInstance Force
#NoTrayIcon


; Toggle audio output related functions
; -------------------
; Toggle for switching two outputs
AudioOutputToggle := false

EnumerateAudioOutputs()


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

; Toggle audio output Headphones / LG TV
^!q::
{
    KeyWait, Control, T0.3
    KeyWait, Alt, T0.3
    KeyWait, q, T0.3

    ; ErrorLevel == 1 if KeyWait was successful
    if (ErrorLevel) {
        ; Switch
        AudioOutputToggle := !AudioOutputToggle

        if (AudioOutputToggle)
            SetDefaultEndpoint(GetDeviceID(Devices, "LG TV (NVIDIA High Definition Audio)"))
        else
            SetDefaultEndpoint(GetDeviceID(Devices, "Headphones (Xbox Controller)"))
    } else
        ; Send original key combination further that triggered this function
        Send ^!{q}

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

SetDefaultEndpoint(DeviceID)
{
    IPolicyConfig := ComObjCreate("{870af99c-171d-4f9e-af0d-e63df40c2bc9}", "{F8679F50-850A-41CF-9C72-430F290290C8}")

    DllCall(NumGet(NumGet(IPolicyConfig+0) + 13 * A_PtrSize), "UPtr", IPolicyConfig, "UPtr", &DeviceID, "UInt", 0, "UInt")

    ObjRelease(IPolicyConfig)
}

GetDeviceID(Devices, Name)
{
    for DeviceName, DeviceID in Devices
        if (InStr(DeviceName, Name))
            return DeviceID
}

EnumerateAudioOutputs()
{
    ; Switch audio output TV / Headphones
    ; http://www.daveamenta.com/2011-05/programmatically-or-command-line-change-the-default-sound-playback-device-in-windows-7/
    global Devices := {}
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

        ObjRawSet(Devices, DeviceName, DeviceID)
    }

    ObjRelease(IMMDeviceCollection)
}
