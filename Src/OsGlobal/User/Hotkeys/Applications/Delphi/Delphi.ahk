#Include 'Core.ahk'

; Delphi
; ------

#HotIf WinActive(WinTitleDelphi1) || WinActive(WinTitleDelphiEditWindow1)
; Enable/Disable our shortcuts
^+\::DelphiToggleShortcuts()
#HotIf

#HotIf WinActive(WinTitleDelphi) || WinActive(WinTitleDelphiEditWindow)
; Fn keys
; ---

; Jumps between declaration and implementation sections in the same unit
F2::Send('!{Up}')
; Goes to the first line of the following method in the file/class
+F2::Send('^+{Down}')

; Search a word under the cursor immediately
^F3::Send('^f{Enter}')

; Focus Navigation bar - Function Dropdown list
; Methods
^F12::Send('^!n^!p')
; Project Symbols
^+F12::Send('^!n^!f')
; Search for Units
^!+F12::Send('^{F12}')

; Special keys
; ---

; Jumps to the location of the previous/next code modification
!Left::Send('^+{F7}')
!Right::Send('^+{F8}')
; Jumps to the previous/next unsaved code modification
!+Left::Send('!+{F7}')
!+Right::Send('!+{F8}')

; Goes back after Alt+Up Arrow or Ctrl+Click (go to declaration) operation
^!Left::Send('!{Left}')
; Goes forward after Alt+Left Arrow operation
^!Right::Send('!{Right}')

; Move line up/down
!Up::
{
    ; Nothing to do, the main edit area doesn't have a focus
    if (!DelphiHasFocusMainEditBox())
        return Send('!{Up}')

    Send('^qs+{Down}^x{Up}^v{Up}')
}
!Down::
{
    ; Nothing to do, the main edit area doesn't have a focus
    if (!DelphiHasFocusMainEditBox())
        return Send('!{Down}')

    Send('^qs+{Down}^x{Down}^v{Up}')
}

; Copy/duplicate line up/down
^!+Down::DelphiCopyLineDown()
^!+Up::Send('^qs+{Down}^c{Up}^v{Up}')

; Alpha keys
; ---

; Copy/Cut line
^+c::Send('^qs+{Down}^c{Up}')
^+x::Send('^qs+{Down}^x')

; Complete Class at Cursor
^!c::Send('^+c')

; Delete line
^d::Send('^y')

; Format (do nothing for Delphi language, not in CE?)
; !+f::Send('^d')

; Make upper/lower case
!u::Send('^kf')
!+u::Send('^ke')

; Options (Preferences)
^!+s::Send('!to')

; Focus edit box with the code (TEditControl1 doesn't work)
^\::
{
    global DelphiEditControlHwnd

    ; Nothing to do
    if (DelphiEditControlHwnd = 0)
        return DelphiEditControlHwnd := ControlGetFocus(WinTitleDelphi)

    try ControlFocus(DelphiEditControlHwnd)
    catch TargetError
        DelphiEditControlHwnd := 0 ; Reset if not found (allows to reassign it)
}

; Numpad keys
; ---

; Comment
^NumpadMult::DelphiCommentLine()

; Duplicate Selection and Comment
^NumpadDiv::
{
    DelphiCopyLineDown()
    DelphiCommentLine()
}

; Close all tool windows at the bottom
!Numpad0::
+Esc::
{
    static ClassNNToClose := [
        'TTabDockHostForm1', 'TTabDockHostForm2', 'TTabDockHostForm3', 'TMessageViewForm1'
    ]

    for classNN in ClassNNToClose
        try PostMessage('0x0010', 0, 0, ControlGetHwnd(classNN), WinTitleDelphi)
}
#HotIf ; WinTitleDelphi || WinTitleDelphiEditWindow

#HotIf WinActive(WinTitleDelphiOptionsModal) || WinActive(WinTitleDelphiProjectOptions)
; Focus help search input in Options (Preferences)
^f::ControlFocus('TButtonedEdit1')
#HotIf
