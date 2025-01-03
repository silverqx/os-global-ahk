#Include <OsGlobal\GlobalVariables>

; Global Fullscreen mode
; ----------------------

; Create a group to target more applications
; Doesn't work: PSPad.exe
GroupAdd('FullscreenGroup', WinTitleQBittorrent)
GroupAdd('FullscreenGroup', WinTitleTC)
GroupAdd('FullscreenGroup', 'ahk_exe TOTALCMD64.EXE ahk_class TTOTAL_CMD')

; Fullscreen
#HotIf WinActive('ahk_group FullscreenGroup')
F11::WinSetStyle('^0xC00000')
#HotIf ; WinActive('ahk_group FullscreenGroup')
