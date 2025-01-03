; Silver Zachara <silver.zachara@gmail.com> 2018-2025

#Requires AutoHotkey v2

Persistent()
#NoTrayIcon
#SingleInstance Force
#UseHook true

;@Ahk2Exe-Base ../v2/AutoHotkey64.exe
;@Ahk2Exe-SetMainIcon ../../../Resources/%A_ScriptName~\.[^\.]+$~.ico%
;@Ahk2Exe-SetCompanyName Crystal Studio
;@Ahk2Exe-SetCopyright Copyright (©) 2025 Silver Zachara
;@Ahk2Exe-SetDescription OS Global (AutoHotkey)
;@Ahk2Exe-SetFileVersion %A_AhkVersion%
;@Ahk2Exe-SetName OS Global
;@Ahk2Exe-SetOrigFilename %A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-SetProductVersion 1.0.0.0
;@Ahk2Exe-UseResourceLang 0x0409

; AutoHotkey settings
; -------------------

SetTitleMatchMode('RegEx')

; Main section
; ------------

#Include Events\Events.ahk
#Include Hotkeys\Hotkeys.ahk

; TODO check and try to somehow use Morse; see https://www.autohotkey.com/board/topic/15574-morse-find-hotkey-press-and-hold-patterns/ silverqx
