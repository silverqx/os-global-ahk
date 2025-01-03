; Google Chrome
; -------------

; Show bookmarks bar
#HotIf WinActive('ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1')
^\::Send('^+b')
~LButton & RButton::Send('^+b')
#HotIf ; WinActive('ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1')
