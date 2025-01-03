; Silver Zachara <silver.zachara@gmail.com> 2023-2025

#Requires AutoHotkey v2

Persistent()
#NoTrayIcon
#SingleInstance Force

;@Ahk2Exe-Base ../v2/AutoHotkey64.exe
;@Ahk2Exe-SetMainIcon ../../Resources/OsGlobal.ico
;@Ahk2Exe-SetCompanyName Crystal Studio
;@Ahk2Exe-SetCopyright Copyright (©) 2025 Silver Zachara
;@Ahk2Exe-SetDescription QtCreator OSD (AutoHotkey)
;@Ahk2Exe-SetFileVersion %A_AhkVersion%
;@Ahk2Exe-SetName QtCreator OSD
;@Ahk2Exe-SetOrigFilename %A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-SetProductVersion 1.0.0.0
;@Ahk2Exe-UseResourceLang 0x0409

; This code was originally in the OsGlobal.ahk, but it caused problems, the OnWmPowerBroadcast() handler
; for the OnMessage(0x218, 'OnWmPowerBroadcast') was called twice! I think it was because
; the CreateCommonOSD() creates a window behind the scene, so I got two windows and so it was called twice.
; Because of that I have created this standalone script for project name OSD-es.

#Include Hotkeys\Hotkeys.ahk
#Include Osd\Osd.ahk

; Main section
; ------------

; Create the project name OSD for all supported applications
CreateOsd()
