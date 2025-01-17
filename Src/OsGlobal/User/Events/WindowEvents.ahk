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
WinEvent.Show(WEVisualStudioOptions, WinTitleVisualStudioOptions)

WEVisualStudioOptions(hook, hWnd, *) {
    global VisualStudioWESkipOptions

    ; Nothing to do, handled by another hotkey (eg. ^!+, - Options - Keyboard)
    if (VisualStudioWESkipOptions)
        return

    WinWait('ahk_id ' . hWnd)
    Send('^e')
}

; QtCreator
; ---------

; Preferences - Focus the Search Input
WinEvent.Show(WEQtCreatorPreferences, '^Preferences - Qt Creator$ ' . WinTitleQtCreator)

WEQtCreatorPreferences(hook, hWnd, *) {
    global QtCreatorWESkipPreferences

    ; Nothing to do, handled by another hotkey (eg. ^!+, - Preferences - Keyboard)
    if (QtCreatorWESkipPreferences)
        return

    WinWait('ahk_id ' . hWnd)
    Send('+{Tab}')
}

; ComputerOff
; -----------

; Confirm model - center mouse
WinEvent.Show(WEComputerOffConfirmCenterMouse, WinTitleComputerOffOptions)

WEComputerOffConfirmCenterMouse(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    ControlCenterMouse(TButton2, WinTitleComputerOffOptions)
}

; Stop button - center mouse
WinEvent.Show(WEComputerOffStopCenterMouse, WinTitleComputerOffMain)

WEComputerOffStopCenterMouse(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)

    if (ControlGetEnabled(TButton4, WinTitleComputerOffMain))
        ControlCenterMouse(TButton4, WinTitleComputerOffMain)
    else if (ControlGetEnabled(TButton3, WinTitleComputerOffMain))
        ControlCenterMouse(TButton3, WinTitleComputerOffMain)
}

; Fullscreen on Open
; ------------------

GroupAdd('FullscreenGroupOnOpen', ' qBittorrent v\d+\.\d+\.\d+$ ' . WinTitleQBittorrent,, '^qBittorrent$')
GroupAdd('FullscreenGroupOnOpen', ' Lindquist$ ' . WinTitleTCUP)
GroupAdd('FullscreenGroupOnOpen', ' - NOT REGISTERED$ ' . WinTitleTC64,, '^Total Commander$')

WinEvent.Show(WEFullscreenOnOpen, 'ahk_group FullscreenGroupOnOpen')

WEFullscreenOnOpen(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    WinSetStyle('^0xC00000')
}

; mpc-hc
; ------

; WinEvent.Show(WEMpcHc, WinTitleMpcHc)

; WEMpcHc(hook, hWnd, *) {
;     global MpcHcTouchOutsideFrameToggle
;     MpcHcTouchOutsideFrameToggle := false
; }
