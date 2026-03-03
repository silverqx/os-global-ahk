#Include <OsGlobal\GlobalVariables>

; Global Mouse hotkeys
; --------------------

; Show Windows Start Menu
~LButton & WheelDown::
{
    ; We need to call the {LButton Up} first because {LButton Up} would be sent to the Start Menu
    ; when {LWin} is sent without it.
    ; Eg. in GSheet it would start selecting cells without this fix.
    Send('{LButton Up}')
    Send('{LWin}')
}

; Close the active window
RButton & MButton::WinClose('A')
; Switch to the previous window
~MButton & XButton1::!Tab

; Suspend2Ram
RButton & WheelUp::
{
    ; Hopefully this prevents strange sleep bug
    Sleep(2000)
    DllCall('PowrProf\SetSuspendState', 'Int', 0, 'Int', 0, 'Int', 1)
}

; Black screensaver
RButton & WheelDown::
{
    Sleep(2000)
    Run('scrnsave.scr /s',, 'Hide')
}

; Hibernate
; RButton & WheelDown::
; {
;     Sleep(2000)
;     DllCall('PowrProf\SetSuspendState', 'Int', 1, 'Int', 0, 'Int', 1)
; }

; Mouse shortcut for ctrl+home/end (can't be LButton to avoid selecting entire document)
#HotIf !WinActive(WinTitleMpcHc)
RButton & WheelRight::Send('^{Home}')
RButton & WheelLeft::Send('^{End}')
#HotIf

#HotIf WinActive(WinTitleChromeMain, '',
                 '^(Google Translate$|^Microsoft Translator(?: - Translate from (?:.+))?)$') ||
       WinActive(WinTitleEdgeMain,   '',
                 '^(Google Translate$|^Microsoft Translator(?: - Translate from (?:.+))?$)') ||
       WinActive(WinTitleFirefoxMain)
; Show bookmarks bar
RButton & LButton::Send('^+b')
#HotIf ; WinTitleChromeMain || WinTitleEdgeMain || WinTitleFirefoxMain

RButton::Send('{RButton}')
