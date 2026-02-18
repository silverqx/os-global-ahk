#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Window>

; Nomi.ai
; -------
; PWA, --app=, and Microsoft Edge/Chrome

NomiAppPwaActivate()
{
    Send('^{Numpad0}')
    Sleep(50)
    Send('{Esc}')
}

; Open Nomi.ai - Edge
#!Space::RunOrActivateIfExist(WinTitleNomiPwaEdge,
    EdgeProxyExe . ' --profile-directory=Default --app-id=jjhinceiappefomfadnlnnfhjkhljopm ' .
        '--app-url=https://beta.nomi.ai/app',
    EdgeWd, 'Max', () => Send('{F11}'), NomiAppPwaActivate())

NomiAppFullscreenLock := false
NomiAppFullscreen := false

NomiNightModeZoom()
{
    Send('^{F8}')
    Sleep(50)

    ; Send('^!f')
    ; Sleep(50)
    SendInput('^{Numpad0}')
    Sleep(100)
    SendInput('^{NumpadSub}')
    Sleep(220)
    SendInput('^{NumpadSub}')
    Sleep(320)
    SendInput('^{NumpadSub}')
    ; Send('^{Click 320 240 3 WheelDown}')
}

; Nomi night mode, open chat in small window upper right and decrease font size (eg. for Twitch)
NomiNightMode()
{
    global NomiAppFullscreenLock := true
    global NomiAppFullscreen

    Sleep(650)
    WinMove(1313, 0, 621, 501)
    WinActive()

    NomiNightModeZoom()

    Sleep(50)
    Send('^!+{F12}')
    Sleep(50)
    Send('{Esc}')

    NomiAppFullscreen := false
    NomiAppFullscreenLock := false
}

; Open Nomi.ai - Edge (tmp. 530x390px best dimension for small window --app=)
#^!Space::RunOrActivateIfExist(WinTitleNomiAppEdge,
    '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" ' .
        '--app=https://beta.nomi.ai/nomis/1106590283?night-mode', ; ?no-redirect
    '', '', () => NomiNightMode(), () => NomiNightModeZoom())

#HotIf WinActive(WinTitleNomiAppEdge)
F11::
{
    if (NomiAppFullscreenLock)
        return

    global NomiAppFullscreenLock := true
    global NomiAppFullscreen

    Send('{F11}')
    Sleep(500)

    if (NomiAppFullscreen)
        NomiNightModeZoom()
    else
        Send('^{Numpad0}')

    Sleep(50)
    Send('{Esc}')

    NomiAppFullscreen := !NomiAppFullscreen
    NomiAppFullscreenLock := false
}
#HotIf ; WinTitleNomiAppEdge

; Open Nomi.ai - Chrome
; ^!Space::RunOrActivateIfExist(WinTitleNomiChrome,
;     ChromeProxyExe . ' --profile-directory=Default --app-id=jjhinceiappefomfadnlnnfhjkhljopm',
;     ChromeWd, 'Max', () => Send('{F11}'))

; Nomi.ai - Upload/Attach File
#HotIf WinActive(WinTitleNomiChrome) || WinActive(WinTitleNomiEdge)
!x::
{
    ; Upload/Attach File
    Send('!x')
    ; Switch to TCUP
    Send('#č')
}
#HotIf ; WinTitleNomiChrome || WinTitleNomiEdge
