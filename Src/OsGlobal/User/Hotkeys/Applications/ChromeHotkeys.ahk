#Include <OsGlobal\GlobalVariables>

; Google Chrome
; -------------

#HotIf WinActive(WinTitleChromeMain, '',
                 '^(Google Translate$|^Microsoft Translator(?: - Translate from (?:.+))?|' .
                 WinTitleNomiRaw . ')$') ||
       WinActive(WinTitleEdgeMain,   '',
                 '^(Google Translate$|^Microsoft Translator(?: - Translate from (?:.+))?$|' .
                 WinTitleNomiRaw . ')')
; Copy the URL from omnibox into the clipboard
!c::Send('!d^c{Esc}')
#HotIf ; WinTitleChromeMain || WinTitleEdgeMain

#HotIf WinActive(WinTitleChromeMain, '',
                 '^(Google Translate$|^Microsoft Translator(?: - Translate from (?:.+))?)$') ||
       WinActive(WinTitleEdgeMain,   '',
                 '^(Google Translate$|^Microsoft Translator(?: - Translate from (?:.+))?$)') ||
       WinActive(WinTitleFirefoxMain)
; Show bookmarks bar
^+sc056::Send('^+b')
#HotIf ; WinTitleChromeMain || WinTitleEdgeMain || WinTitleFirefoxMain

; Fullscreen by Middle Click
; ---

; Twitch
#HotIf WinActive('^Twitch - .* - Twitch$ ' . WinTitleChromeExe)
; Need to send MButton because the Scrolling mode enables after pressing ~MButton,
; the second MButton press disables it.
~MButton::Send('{MButton}f')
#HotIf

; YouTube
#HotIf WinActive('(?:^YouTube - (?:.+) - YouTube$)|(?:(?:.+) - YouTube - Google Chrome$) ' . WinTitleChromeMain)
; Need to send MButton because the Scrolling mode enables after pressing ~MButton,
; the second MButton press disables it.
~MButton::Send('{MButton}f')
#HotIf
