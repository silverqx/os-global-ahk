#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Window>

TlAppHwnd := 0
TlMoveBottomHwnd := Map()

; Translation directions
TlGtDirection := {
    EnToSk: 0,
    SkToEn: 1,
}

TlAppRestore(withPaste := false, withSourceCopy := false)
{
    global TlAppHwnd, TlMoveBottomHwnd

    ; Copy the current source text into the clipboard
    if (withSourceCopy)
        Send('^a^c')

    ; Copy the current translation into the clipboard
    else
        Send('!c')
    Sleep(35) ; Doesn't work without this (it's not so bad like case below)

    hwndActive := WinActive('A')
    if (hwndActive != 0 && !TlMoveBottomHwnd.Has(hwndActive))
        WinMoveBottom('A')

    for hwnd in TlMoveBottomHwnd
        WinMoveBottom(hwnd)

    ; WinMoveBottom() doesn't auto-focus the top level window
    if (TlAppHwnd != 0)
        WinActivate('ahk_id ' . TlAppHwnd)
    else
        WinActivate('ahk_id ' . TlAppHwnd := WinGetIDTop())

    if (withPaste) {
        Sleep(5)
        appTitle := WinGetTitle('ahk_id ' . TlAppHwnd)

        ; Prevent Alt-triggered AI (like keyboard shortcuts after the Alt key press)
        if (WinActive(WinTitleCopilot)) {
            Send('{Esc 2}')
            Sleep(5)
        }

        ; Nomi.ai special handling
        if (RegExMatch(appTitle, '^' . WinTitleNomiRaw) ||
            RegExMatch(appTitle, '^' . WinTitleNomiRaw . '$')
        ) {
            Send('^+{F12}')
            Sleep(90)
            Send('{Space}{BackSpace}')
            Sleep(200)
            ; Cancel Microsoft autocorrector popup
            Send('{Esc}')
        }
        else
            Send('^v')
    }

    TlAppHwnd := 0
    TlMoveBottomHwnd := Map()
}

TlMicrosoftTranslator(saveActiveHwnd := true)
{
    global TlMoveBottomHwnd

    hwnd := WinActive('A')
    if (saveActiveHwnd)
        global TlAppHwnd := hwnd

    else if(!TlMoveBottomHwnd.Has(hwnd))
        TlMoveBottomHwnd[hwnd] := 'm'

    RunOrActivateMicrosoftTranslator() ; Weird #Include, depends on the ordered❗
}

TlGoogleTranslate(
    saveActiveHwnd := true, translationDirection := unset, copyToClipboard := false,
    pasteClipboard := false, selectAll := false
) {
    global TlMoveBottomHwnd

    hwnd := WinGetID('A')
    if (saveActiveHwnd)
        global TlAppHwnd := hwnd
    else if(!TlMoveBottomHwnd.Has(hwnd))
        TlMoveBottomHwnd[hwnd] := 'g'

    ; Copy text under the cursor or the current selection into the clipboard
    if (copyToClipboard) {
        if (selectAll) {
            Send('^a')
            Sleep(5)
        }
        Send('^c')

        Sleep(85) ; Doesn't work without this (2-3ms lower limit)❗
        if (selectAll && A_Clipboard == '')
            pasteClipboard := false
    }

    activateCallback := unset
    if (IsSet(translationDirection))
        switch translationDirection {
            case TlGtDirection.EnToSk:
                activateCallback := () => pasteClipboard ? Send('^+{F12}') : Send('^{F12}')
            case TlGtDirection.SkToEn:
                activateCallback := () => Send('^{F11}')
        }

    RunOrActivateIfExist(WinTitleGoogleTranslatePwaEdge,
        '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe" ' .
            '--profile-directory=Default --app-id=edanbjnaiofggfmimiidpfmhggkbokck ' .
            '--app-url=https://translate.google.com/?lfhs=2&sl=sk&tl=en&op=translate',
        'C:\Program Files (x86)\Microsoft\Edge\Application',,, activateCallback?)
}

#HotIf WinActive('^(?:Microsoft Translator(?: - Translate from (?:.+))?)$ ' . WinTitleEdgeMain)
F9::TlAppRestore()
F10::TlGoogleTranslate(false)
!q::TlGoogleTranslate(false)
#HotIf

#HotIf WinActive('^(?:Google Translate)$ ' . WinTitleEdgeMain)
F10::TlAppRestore()
F9::TlMicrosoftTranslator(false)
; Paste to the target only
!q::TlAppRestore(true)
; Copy the source text and paste it to the target
!d::TlAppRestore(true, true)
; Switch to target only
!s::TlAppRestore(false)
; Switch to target only
sc029::TlAppRestore(false)
#HotIf

#HotIf WinActive(WinTitleNomiEdge)
F9::TlMicrosoftTranslator()
F10::TlGoogleTranslate()
#HotIf ; WinTitleNomiEdge
#HotIf !WinActive(WinTitleComputerOffMain)
; Sk - En
!q::TlGoogleTranslate(true, TlGtDirection.SkToEn)
#HotIf !WinActive(WinTitleAhk2DocsEdge) && !WinActive(WinTitleComputerOffMain) &&
       !WinExist(WinTitleUIAViewer)
; En - Sk copy to clipboard from 'A' and paste to Google Translate
!s::TlGoogleTranslate(true, TlGtDirection.EnToSk, true, true)
#HotIf
#HotIf !WinActive(WinTitleSmartGit)
; En - Sk no copying to clipboard
!+s::TlGoogleTranslate(true, TlGtDirection.EnToSk)
#HotIf
; En - Sk paste from clipboard to Google Translate
!+e::TlGoogleTranslate(true, TlGtDirection.EnToSk, true, true, true)
