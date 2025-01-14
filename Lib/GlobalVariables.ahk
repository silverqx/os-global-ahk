; Global variables
; ----------------

; Higher value for SetKeyDelay()
KeyDelay25 := 25
KeyDelayDefault := 10

; QtCreator skip the global WinEvent for the Preferences modal
QtCreatorWESkipPreferences := false

; WinTitle-s (used across all script files)
WinTitleComputerOff        := 'ahk_exe ComputerOff.exe'
WinTitleComputerOffMain    := '^ComputerOff$ ahk_class TFormMainForm ' . WinTitleComputerOff
WinTitleComputerOffOptions := '^Confirm$ ahk_class TMessageForm ' . WinTitleComputerOff
WinTitleQBittorrent        := 'ahk_exe qbittorrent.exe'
WinTitleMpcHc              := 'ahk_class MediaPlayerClassicW ahk_exe mpc-hc64.exe'
WinTitleQtCreator          := 'ahk_exe qtcreator.exe'
WinTitleSmartGit           := 'ahk_class SWT_Window0 ahk_exe smartgit.exe'
WinTitleTCUP               := 'ahk_class TTOTAL_CMD ahk_exe TOTALCMD.EXE'
WinTitleTC64               := 'ahk_class TTOTAL_CMD ahk_exe TOTALCMD64.EXE'

; Common button names
TButton2 := 'TButton2'
TButton3 := 'TButton3'
TButton4 := 'TButton4'
