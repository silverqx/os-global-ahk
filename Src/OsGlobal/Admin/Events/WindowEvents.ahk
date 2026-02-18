#Include <AHK-v2-libraries\Lib\WinEvent>

#Include <OsGlobal\GlobalVariables>

; Windows Events
; --------------

; Window Spy for AHKv2
; --------------------

; Set initial window position
WinEvent.Show(WEAhk2WindowSpy, '^Window Spy for AHKv2$ ' . WinTitleAutoHotkey64)

WEAhk2WindowSpy(hWnd, hook, *) {
    WinMove(1474, 78,,, 'ahk_id ' . hWnd)
}
