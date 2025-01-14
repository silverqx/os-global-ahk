#Include <OsGlobal\GlobalVariables>

; QtCreator
; -------------

#HotIf WinActive('Qt Creator$ ' . WinTitleQtCreator)
; Focus the Filter input on Preferences - Environment - Keyboard
^!+,::
{
    global QtCreatorWESkipPreferences
    ; To skip the global WinEvent for the Preferences modal
    QtCreatorWESkipPreferences := true

    Send('^+,')

    WinWait('^Preferences - Qt Creator$ ' . WinTitleQtCreator)
    Send('{Tab 7}')

    ; Restore
    QtCreatorWESkipPreferences := false
}
#HotIf ; WinActive('Qt Creator$ ' . WinTitleQtCreator)
