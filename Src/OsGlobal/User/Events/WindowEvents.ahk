#Include <AHK-v2-libraries\Lib\WinEvent>

#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Mouse>
#Include <OsGlobal\Window>

; Windows Events
; --------------

; Qt Maintenance Tool
; -------------------

; Set initial window properties
WinEvent.Show(WEQtMaintenanceTool, 'Maintain Qt ahk_exe MaintenanceTool.exe ahk_class Qt660QWindowIcon')

WEQtMaintenanceTool(hook, hWnd, *) {
    TileWindowCenterFull('ahk_id ' . hWnd)
}

; SmartGit
; --------

; Focus the Graph view (send hotkey) after displaying the Log Window
WinEvent.Show(WESmartGit, '(?:.*SmartGit .* )(?:\(Log\) Non-Commercial)$ ' . WinTitleSmartGit)

WESmartGit(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    Send('^+5')
}

; Visual Studio
; -------------

; Options - Focus the Search Input
WinEvent.Show(WEVisualStudioOptions, '^Options$ ahk_exe devenv.exe ahk_class #32770')

WEVisualStudioOptions(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    Send('^e')
}

; QtCreator
; ---------

; Preferences - Focus the Search Input
WinEvent.Show(WEQtCreatorPreferences, '^Preferences - Qt Creator$ ahk_exe qtcreator.exe')

WEQtCreatorPreferences(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    Send('+{Tab}')
}

; ComputerOff
; -----------

; Confirm model - center mouse
WinEvent.Show(WEComputerOffConfirmCenterMouse, '^Confirm$ ' . WinTitleComputerOff)

WEComputerOffConfirmCenterMouse(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    ControlCenterMouse('TButton2') ; Don't use the WinTitleComputerOff here (center mouse only if it's in the foreground)
}

; Fullscreen on Open
; ------------------

; WinEvent.Show(WEFullscreenOnOpen, WinTitleQBittorrent)
; WinEvent.Show(WEFullscreenOnOpen, WinTitleTC)

; WEFullscreenOnOpen(hook, hWnd, *) {
;     WinWait('ahk_id ' . hWnd)
;     WinSetStyle('^0xC00000')
; }

; mpc-hc
; ------

; WinEvent.Show(WEMpcHc, WinTitleMpcHc)

; WEMpcHc(hook, hWnd, *) {
;     global MpcHcTouchOutsideFrameToggle
;     MpcHcTouchOutsideFrameToggle := false
; }
