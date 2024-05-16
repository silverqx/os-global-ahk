; Silver Zachara <silver.zachara@gmail.com> 2018-2024

; I don't need switching audio outputs so I extracted it to own file.
; All commented code is old ahk v1 code, the EnumerateAudioOutputs() is refactored to ahk v2.

#Requires AutoHotkey v2

Persistent
#NoTrayIcon
#SingleInstance Force
#UseHook True

#Include <ahk2_lib\Audio\Audio>

; Global variables
; ----------------

; Audio output devices
OutputDevices := Map()
; Toggle for switching two outputs
AudioOutputToggle := false
; For a new code to allow switching more autio devices (unfinished)
; AudioOutputs := ['LG TV (NVIDIA High Definition Audio)', 'Headphones (Xbox Controller)']

EnumerateAudioOutputs()

; General Section
; ---------------

; Toggle audio output Headphones / LG TV
; ^;::
; {
;     global AudioOutputToggle

;     KeyWait('Ctrl', 'T0.3')
;     KeyWait(';', 'T0.3')

;     ; ErrorLevel == 1 if KeyWait was successful
;     if (ErrorLevel) {
;         ; Switch
;         AudioOutputToggle := !AudioOutputToggle

;         if (AudioOutputToggle)
;             SetDefaultEndpoint(GetDeviceID(OutputDevices, 'LG TV (NVIDIA High Definition Audio)'))
;         else
;             SetDefaultEndpoint(GetDeviceID(OutputDevices, 'Headphones (Xbox Controller)'))
;     } else
;         ; Send original key combination further that triggered this function
;         Send('^{;}')
; }

; Trigger audio output devices enumeration
^+;::EnumerateAudioOutputs()

; Toggle audio output related functions
; -------------------------------------

; Set the default audio device by device ID
; SetDefaultEndpoint(DeviceID)
; {
;     IPolicyConfig := ComObject('{870af99c-171d-4f9e-af0d-e63df40c2bc9}',
;                                '{F8679F50-850A-41CF-9C72-430F290290C8}')

;     DllCall(NumGet(NumGet(IPolicyConfig + 0, 'Ptr') + 13 * A_PtrSize, 'Ptr'),
;             'Ptr', IPolicyConfig, 'Ptr', &DeviceID, 'UInt', 0, 'UInt')

;     ObjRelease(IPolicyConfig)
; }

; Enumerate audio outputs and create a map<DeviceName, DeviceID> that is used in hotkeys
; for switching audio outputs.
EnumerateAudioOutputs()
{
    global OutputDevices

    audioEndpoints := IMMDeviceEnumerator().EnumAudioEndpoints()

    Loop audioEndpoints.GetCount() {
        audioEndpoint := audioEndpoints.Item(A_Index - 1)
        propertiesStore := audioEndpoint.OpenPropertyStore(0x0) ; STGM_READ - 0x0L

        propertyKey := Buffer(20, 0)
        propertyValue := Buffer(A_PtrSize == 4 ? 16 : 24, 0)
        DllCall('Ole32.dll\CLSIDFromString', 'Str', '{A45C254E-DF1C-4EFD-8020-67D146A850E0}',
                'Ptr', propertyKey)

        NumPut('UInt', 14, propertyKey.Ptr + 16) ; PKEY_Device_FriendlyName - 14
        DllCall(NumGet(NumGet(propertiesStore, 'Ptr') + 5 * A_PtrSize, 'Ptr'),
                'Ptr', propertiesStore, 'Ptr', propertyKey, 'Ptr', propertyValue)

        DeviceName := StrGet(NumGet(propertyValue.Ptr + 8, 'Ptr'), 'UTF-16') ; LPWSTR PROPVARIANT.pwszVal
        DllCall('Ole32.dll\CoTaskMemFree', 'Ptr', NumGet(propertyValue.Ptr + 8, 'Ptr')) ; LPWSTR PROPVARIANT.pwszVal
        ObjRelease(propertiesStore)

        OutputDevices.Set(DeviceName, audioEndpoint.GetId())
    }
}
