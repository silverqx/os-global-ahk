#Include <OsGlobal\GlobalVariables>

; Global variables
; ----------------

; A copy needs to be created to be able to re-enable shortcuts (must always work)
; Disabling shortcuts is needed eg. in the designer mode, some shortcuts below, especially
; arrows related shortcuts are doing mess
WinTitleDelphi1 := WinTitleDelphi
WinTitleDelphiEditWindow1 := WinTitleDelphiEditWindow

DelphiEditControlHwnd := 0

; Delphi core
; -----------

; Enable/Disable our shortcuts
DelphiToggleShortcuts()
{
    global WinTitleInvalidAhkExe
    global WinTitleDelphi, WinTitleDelphiEditWindow
    static shortcutsDisabled := false
    static WinTitleDelphiBackup := WinTitleDelphi
    static WinTitleDelphiEditWindowBackup := WinTitleDelphiEditWindow

    ; Enable
    if (shortcutsDisabled) {
        WinTitleDelphi := WinTitleDelphiBackup
        WinTitleDelphiEditWindow := WinTitleDelphiEditWindowBackup
    }
    ; Disable
    else
        WinTitleDelphi := WinTitleDelphiEditWindow := WinTitleInvalidAhkExe

    SoundBeep(10000, 70)
    shortcutsDisabled := !shortcutsDisabled
}

; Determine whether the main edit area in Delphi has a focus
DelphiHasFocusMainEditBox()
{
    global DelphiEditControlHwnd

    ; Nothing to do, Delphi is not in the foreground
    if (!WinActive(WinTitleDelphi) && !WinActive(WinTitleDelphiEditWindow1))
        return

    return DelphiEditControlHwnd = ControlGetFocus() ; Focus of the Last Found Window
}

; Comment line
DelphiCommentLine()
{
    Send('^-{Up}')
}

; Copy line down
DelphiCopyLineDown()
{
    Send('^qs+{Down}^c^qs^v{Up}')
}
