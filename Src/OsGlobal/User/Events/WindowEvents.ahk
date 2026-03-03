#Include <AHK-v2-libraries\Lib\WinEvent>

#Include <OsGlobal\GlobalVariables>

#Include <OsGlobal\Containers\WinTitleMap>
#Include <OsGlobal\Containers\WinTitleSet>
#Include <OsGlobal\Mouse>
#Include <OsGlobal\Title>
#Include <OsGlobal\Window>

; Windows Events
; --------------

; Qt Maintenance Tool
; -------------------

; Set initial window properties
WinEvent.Show(WEQtMaintenanceTool, 'Maintain Qt ahk_exe MaintenanceTool.exe ahk_class Qt660QWindowIcon')

WEQtMaintenanceTool(hWnd, hook, *) {
    TileWindowCenterFull('ahk_id ' . hWnd)
}

; SmartGit
; --------

; Focus the Graph view (send hotkey) after displaying the Log Window
WinEvent.Show(WESmartGit, '(?:.*SmartGit .* )(?:\(Log\) Non-Commercial)$ ' . WinTitleSmartGit)

WESmartGit(hWnd, hook, *) {
    WinWait('ahk_id ' . hWnd)
    Send('^+5')
}

; Visual Studio
; -------------

; Options - Focus the Search Input
WinEvent.Show(WEVisualStudioOptions, WinTitleVisualStudioOptions)

WEVisualStudioOptions(hWnd, hook, *) {
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

WEQtCreatorPreferences(hWnd, hook, *) {
    global QtCreatorWESkipPreferences

    ; Nothing to do, handled by another hotkey (eg. ^!+, - Preferences - Keyboard)
    if (QtCreatorWESkipPreferences)
        return

    WinWait('ahk_id ' . hWnd)
    Send('+{Tab}')
}

; Microsoft Wallet
; ----------------

WinEvent.Show(WEMSWalletPreferences, WinTitleMSWalletEdge)

WEMSWalletPreferences(hWnd, hook, *) {
    WinWait('ahk_id ' . hWnd)
    Sleep(1000)
    Send('{Tab 6}{Enter}')
}

; Fullscreen on Open
; ------------------

; This method applies the 0xC00000 style
GroupAdd('FullscreenGroupOnOpen', WinTitleQBittorrent,, '^qBittorrent$')
GroupAdd('FullscreenGroupOnOpen', ' Lindquist$ ' . WinTitleTCUP)
GroupAdd('FullscreenGroupOnOpen', ' - NOT REGISTERED$ ' . WinTitleTC64,, '^Total Commander$')

WinEvent.Show(WEFullscreenOnOpen, 'ahk_group FullscreenGroupOnOpen')

WEFullscreenOnOpen(hWnd, hook, *) {
    try {
        WinWait('ahk_id ' . hWnd)
        WinSetStyle('^0xC00000')
        WinActivate('ahk_id ' . hWnd)
    }
}

; This alternative method will only send the F11 shortcut (fullscreen)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleAhk2DocsChrome)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleAhk2DocsEdge)
; Controlled by: () => Send('{F11}')
; GroupAdd('FullscreenGroupOnOpenAlt', '^Chrome for Developers(?:$| - (?:.+ )?Chrome for Developers$) ' . WinTitleChromeMain)
GroupAdd('FullscreenGroupOnOpenAlt', '^Facebook(?:$| - (?:.+ )?Facebook$) ' . WinTitleChromeMain)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleFirefox)
GroupAdd('FullscreenGroupOnOpenAlt', '^GitHub(?:$| - (?:.+ )) ' . WinTitleChromeMain)
GroupAdd('FullscreenGroupOnOpenAlt', '^Grokipedia(?:$| - .+) ' . WinTitleChromeMain)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleKindroidChrome)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleKindroidEdge)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleMdnPwaChrome)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleMSWalletEdge)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleNomiChrome)
GroupAdd('FullscreenGroupOnOpenAlt', '^regex101$ ' . WinTitleChromeMain)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleReplikaChrome)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleReplikaEdge)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleSpotifyChrome)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleVsCodeNoTab)
GroupAdd('FullscreenGroupOnOpenAlt', WinTitleXPwaChrome)
; GroupAdd('FullscreenGroupOnOpenAlt', WinTitleChromeMain)
GroupAdd('FullscreenGroupOnOpenAlt', '^YouTube(?:$| - (?:.+ )?YouTube$) ' . WinTitleChromeMain)

; These are for Debugging purposes only, to verify titles matching
; GroupAdd('FullscreenGroupOnOpenAlt', WinTitleChromeMain)
; GroupAdd('FullscreenGroupOnOpenAlt', WinTitleEdgeMain)

/* Why Firefox needs second check?
   Firefox PWA app first opens hidden window with title `WinTitleFirefox`, then after a while opens
   the actual window with title like `Chatgpt in Main profile — Mozilla Firefox`, and as the page
   loads, the title changes again to `ChatGPT — Chatgpt in Main profile — Mozilla Firefox`.

   Chrome and Edge PWAs behaves differently, windows isn't opened hidden, and title is immediately
   to the PWAs name. During PWA creation, user can change the title, but when it doesn't match
   the actual page title, the PWA app is not installed! Which means the title is predictable and
   always match the first loaded page title.
*/

FullscreenOnOpenAltMap := WinTitleMap(
    WinTitleFirefoxExact, [
        Format(WinTitleFirefoxPwaSuffixRaw, 'Chatgpt'),
        Format(WinTitleFirefoxPwaSuffixRaw, 'Claude'),
        Format(WinTitleFirefoxPwaSuffixRaw, 'Google Gemini'),
        Format(WinTitleFirefoxPwaSuffixRaw, 'Grok'),
    ],
    ; TODO Verify why this worked with WinTitleXPwaChrome and doesn't work with WinTitleChromeMain silverqx
    ; WinTitleChromeMain, [
    ;     '  - Google Sheets$',
    ; ]
    ; WinTitleVsCodeNoTabSC, [
    ;     WinTitleVsCodeUntitled1SC,
    ; ]
)

FullscreenOnOpenAltIgnoreList := WinTitleSet(
    ; WinTitleVsCodeMain,
)

WinEvent.Show(WEFullscreenOnOpenAlt, 'ahk_group FullscreenGroupOnOpenAlt')

WEFullscreenOnOpenAlt(hWnd, hook, *) {
    static dsc := (v) => ' [doSecondCheck: ' . v . ']'
    static Index := 0
    ++Index

    try {
        DetectHiddenWindows(true) ; This is needed to detect some windows
        ahkIdHwnd := 'ahk_id ' . hWnd
        ; Leave here all debug messages as this matching code is tricky and we need to verify titles
        ; in some cases.
        ; WriteMainLog(Index ': Full title before WinWait(): ' . WinGetFullTitle(ahkIdHwnd))

        ; Workaround for `window.newWindowDimensions: fullscreen`, its clipping is out of screen
        ; All juggling with vscode is to workaround this bug
        if (WinGetProcessName(ahkIdHwnd) == 'Code.exe') {
            if (WinGetTitle(ahkIdHwnd) ~= WinTitleVsCodeUntitled1SC . '$') {
                WinActivate(ahkIdHwnd)
                Send('{F11 2}')
            }

            return
        }

        titleInit := WinGetFullTitle(ahkIdHwnd)
        doSecondCheck := FullscreenOnOpenAltMap.Has(titleInit)
        titlesMap := doSecondCheck ? FullscreenOnOpenAltMap.Get(titleInit) : ''

        if (WinWait(ahkIdHwnd,, 3) == 0) {
            ; WriteMainLog(Index ': WinWait timed out for window: ' . titleInit . dsc(doSecondCheck))
            return
        }

        ; WriteMainLog(Index ': Full title after WinWait(): ' . WinGetFullTitle(ahkIdHwnd) . dsc(doSecondCheck))
        ; WriteMainLog(Index ': Title after WinWait(): ' . WinGetTitle(ahkIdHwnd) . dsc(doSecondCheck))

        ; Wait for the full title update (VS Code needs more time)
        Sleep(RegExMatch(titleInit, WinTitleVsCodeMain . '$') ? 700 : 450)

        ; WriteMainLog(Index ': Title before doSecondCheck: ' . WinGetTitle(ahkIdHwnd) . dsc(doSecondCheck))
        if (doSecondCheck && !WEFullscreen_ContainsTitle(ahkIdHwnd, titlesMap, Index))
            return

        ; Ignore some titles
        if (!doSecondCheck && FullscreenOnOpenAltIgnoreList.Has(WinGetFullTitle(ahkIdHwnd))) {
            ; WriteMainLog(Index ': Title is in ignore list, skipping fullscreen: ' . WinGetFullTitle(ahkIdHwnd))
            return
        }

        WinActivate(ahkIdHwnd)
        Send('{F11}')
        ; WriteMainLog(Index ': Full title after Send(F11): ' . WinGetFullTitle(ahkIdHwnd) . dsc(doSecondCheck))
    }
}

WEFullscreen_ContainsTitle(ahkIdHwnd, titlesMap, Index := 0) {
    for title in titlesMap
        if (RegExMatch(WinGetTitle(ahkIdHwnd), title . '$') != 0) {
            ; WriteMainLog(Index ': Matched second title check: ' . title . '$')
            return true
        }

    return false
}

; mpc-hc
; ------

; WinEvent.Show(WEMpcHc, WinTitleMpcHc)

; WEMpcHc(hWnd, hook, *) {
;     global MpcHcTouchOutsideFrameToggle
;     MpcHcTouchOutsideFrameToggle := false
; }
