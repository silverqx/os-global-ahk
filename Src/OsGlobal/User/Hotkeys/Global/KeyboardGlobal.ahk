#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Http\Fetch>
#Include <OsGlobal\Keyboard>

#Include FullscreenGlobal.ahk

; ReMap keys
; ----------

; Dash (minus) to Em Dash (key next to right Shift)
<^>!sc035::Send('—')

; Global Keyboard hotkeys
; -----------------------

; Restart the AhkOsGlobal scheduled task
^!BackSpace::
{
    SoundBeep(8000, 70)
    Run(PwshHiddenFile . A_InitialWorkingDir . '\Recompile-User.ps1',, 'Hide')
}

; Multimedia keys
; ---

; Spotify - Play/Pause
Media_Play_Pause::
{
    if WinExist(WinTitleSpotifyChrome)
        SendPlayPauseCommand()
    else
        Send('{Media_Play_Pause}')
}

; mpc-hc
CreateSwitchWindowsHotkeys('Browser_Home', 'N', '',
    WinTitleMpcHc, 'MpcHcActivateGroup',
    A_StartMenuCommon . '\Programs\MPC-HC x64\MPC-HC x64.lnk')

; Windows Calculator
CreateSwitchWindowsHotkeys('Launch_App2', 'N', '',
    WinTitleCalculator, 'CalculatorActivateGroup',
    'shell:AppsFolder\Microsoft.WindowsCalculator_8wekyb3d8bbwe!App')

; Delphi
CreateSwitchWindowsHotkeys('#F7', 'N', '',
    WinTitleDelphi, 'DelphiActivateGroup',
    'C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\bds.exe')

; Spotify - Chrome PWA (properly reacts to Media_Play_Pause key)
Launch_Mail::RunOrActivateIfExist(WinTitleSpotifyChrome,
    ; TODO create helper function eg. ChromeProxyCmd(appId, appUrl, profile?) to
    ChromeProxyExe . ' --profile-directory=Default --app-id=pjibgclleladliembfgfagdaldikeohf',
    ChromeWd, 'Max')
; Spotify (don't use this as it plays a lot of ads)
; Launch_Mail::RunOrActivateIfExist(WinTitleSpotify,
;     'shell:AppsFolder\SpotifyAB.SpotifyMusic_zpdnekdrzrea0!Spotify', '',
;     'Max')
; Spotify - Edge PWA (properly reacts to Media_Play_Pause key)
; Launch_Mail::RunOrActivateIfExist(WinTitleSpotifyEdge,
    ; EdgeProxyExe . ' --profile-directory=Default --app-id=pjibgclleladliembfgfagdaldikeohf ' .
    ;     '--app-url=https://open.spotify.com/',
    ; EdgeWd, 'Max')

; Discord
^Launch_Mail::RunOrActivateIfExist(WinTitleDiscordMain,
    'shell:AppsFolder\com.squirrel.Discord.Discord', '', 'Max')

; Hibernate (ctrl+calc)
^Launch_App2::
{
    Sleep(2000)
    DllCall('PowrProf\SetSuspendState', 'Int', 1, 'Int', 0, 'Int', 0)
}

; Monitor on/off (alt+calc)
!Launch_App2::
{
    Sleep(500)
    Run(A_ProgramFiles . ' (x86)\TC UP\MEDIA\Programs\Poweroff\poweroffcz.exe monitor_off',, 'Hide')
}

; Fn keys
; ---

; Claude - Firefox
<#F2::RunOrActivateIfExist(WinTitleClaudePwaFirefox,
    FirefoxExe . ' -taskbar-tab 0b5a1bb4-e371-47d9-a8ed-b3d285900cdc ' .
        '-new-window https://claude.ai/ ' .
        Format('-profile "{:s}\Mozilla\Firefox\Profiles\{:s}" ', A_AppData, FirefoxProfileDefault) .
        '-container 0',
    FirefoxWd, 'Max')
; Claude - Chrome
; #F2::RunOrActivateIfExist(WinTitleClaudePwaChrome,
;     ChromeProxyExe . ' --profile-directory=Default --app-id=fmpnliohjhemenmnlpbfagaolkdacoja',
;     ChromeWd, 'Max')
; Google Gemini - Firefox
; <#F3::RunOrActivateIfExist(WinTitleGeminiPwaFirefox,
;     FirefoxExe . ' -taskbar-tab 359399e4-2db5-49fe-b8b9-ceeabf84cd97 ' .
;         '-new-window https://gemini.google.com/ ' .
;         Format('-profile "{:s}\Mozilla\Firefox\Profiles\{:s}" ', A_AppData, FirefoxProfileDefault) .
;         '-container 0',
;     FirefoxWd, 'Max')
; ChatGPT - Firefox
<#F3::RunOrActivateIfExist(WinTitleChatGptPwaFirefox,
    ; TODO create helper function for Firefox PWAs to avoid repeating this everywhere silverqx
    FirefoxExe . ' -taskbar-tab c6c8d238-d2ff-462f-baaa-e495b8a73cee ' .
        '-new-window https://chatgpt.com ' .
        Format('-profile "{:s}\Mozilla\Firefox\Profiles\{:s}" ', A_AppData, FirefoxProfileDefault) .
        '-container 0',
    FirefoxWd, 'Max')
; Google Gemini - Chrome
; <#F3::RunOrActivateIfExist(WinTitleGeminiPwaChrome,
;     ChromeProxyExe . ' --profile-directory=Default --app-id=gdfaincndogidkdcdkhapmbffkckdkhn',
;     ChromeWd, 'Max')
; Grok - Firefox
<#F4::RunOrActivateIfExist(WinTitleGrokPwaFirefox,
    FirefoxExe .
        ' -taskbar-tab dd6d3ac1-2f9a-4971-9850-f86647b0284d -new-window https://grok.com/ ' .
        Format('-profile "{:s}\Mozilla\Firefox\Profiles\{:s}" ', A_AppData, FirefoxProfileDefault) .
        '-container 0',
    FirefoxWd, 'Max')

#+F6::RunOrActivateIfExist('^Google Password Manager$',
    ChromeProxyExe . ' --profile-directory=Default --app-id=kajebgjangihfbkjfejcanhanjmmbcfd',
    ChromeWd, 'Max', () => Send('{F11}'),, ChromeNewCallbackDelay)
; Black screensaver
^!F5::Run('scrnsave.scr /s',, 'Hide')

; vscode - Untitled File (unused)
; I have set:
; - "window.newWindowDimensions": "fullscreen"
; - "workbench.startupEditor": "newUntitledFile"
; So even #+sc00b works the same way (sc00b is 0 key, 10th icon pinned in the Windows taskbar)
; ^!#sc00b::
; {
;     RunOnly('Welcome - Visual Studio Code ' . WinTitleVsCodeMain,
;         '"C:\Program Files\Microsoft VS Code\Code.exe" --new-window',, 'Max',
;         () => Send('{F11}^{F4}^n'), VsCodeNewCallbackDelay)
; }
MainWorkspaceDir := A_MyDocuments . '\Code Workspaces'
; os-global - vscode workspace
^!F6::Run(
    Format('code.cmd --new-window "{:s}"', MainWorkspaceDir . '\os-global.code-workspace'),
    'E:\autohotkey\os-global', 'Hide')
; FlowMonkey - Pulse - vscode workspace
FlowMonkeyWorkspaceDir := A_MyDocuments . '\Code Workspaces'
^!+F6::Run(
    Format('code.cmd --new-window "{:s}"', MainWorkspaceDir . '\FlowMonkey.code-workspace'),
    FlowMonkeyWorkspaceDir, 'Hide')
; SamPline - vscode
!+F6::Run('code.cmd --new-window E:\code\nodejs\SamPline', 'E:\code\nodejs\SamPline', 'Hide')
; dotfiles - vscode
^+F6::Run('code.cmd --new-window E:\dotfiles', 'E:\dotfiles', 'Hide')
; TinyORM - vscode
!+F7::Run('code.cmd --new-window O:\Code\c\qMedia\TinyORM\TinyORM',
    'O:\Code\c\qMedia\TinyORM\TinyORM', 'Hide')

; Alpha keys
; ---

; Callback for the HotIf function for not PHPStorm
NotPhpStormHotIf(*)
{
    return !WinActive('ahk_exe phpstorm64.exe')
}
; Callback for the HotIf function for not Windows Calculator
NotCalculatorHotIf(*)
{
    return !WinActive(WinTitleCalculator)
}
; Combined callback for the HotIf function for Alt+1-5 hotkeys
NotAlt15HotIfGroup(*)
{
    return (*) => NotPhpStormHotIf() && NotCalculatorHotIf()
}

; Microsoft Edge - sc029 '`' (en) and ';' (cz) (left to 1 key)
CreateSwitchWindowsHotkeys('!sc029', 'N', NotAlt15HotIfGroup(),
     WinTitleEdgeSwitcherMain, 'MicrosoftEdgeActivateGroup',
     'shell:AppsFolder\Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe!App',
     EdgeWd, 'Max', () => WinMaximize())

; Microsoft Edge DevTools - sc002 '1' (en) and '+' (cz) (is the 1 key)
CreateSwitchWindowsHotkeys('!sc002', 'N', NotAlt15HotIfGroup(),
    WinTitleEdgeDevToolsSwitcher, 'MicrosoftEdgeDevToolsActivateGroup',
    'shell:AppsFolder\Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe!App', '', '',
    unset, '', unset, 10, true)

; Firefox - sc003 '2' (en) and 'ě' (cz) (is the 2 key)
; CreateSwitchWindowsHotkeys('!sc003', 'N', NotAlt15HotIfGroup(),
;      WinTitleFirefoxSwitcherMain, 'FirefoxActivateGroup',
;      FirefoxExeRaw, FirefoxWd, 'Max', () => WinMaximize())

; X - sc003 '2' (en) and 'ě' (cz) (is the 2 key)
CreateSwitchWindowsHotkeys('!sc003', 'N', NotAlt15HotIfGroup(),
    WinTitleXPwaChrome, 'XActivateGroup',
    ChromeProxyExe . ' --profile-directory=Default --app-id=lodlkdfmihgonocnmddehnfgiljnadcf',
    ChromeWd, 'Max')

; Firefox Developer Tools - sc004 '3' (en) and 'š' (cz) (is the 3 key)
CreateSwitchWindowsHotkeys('!sc004', 'N', NotAlt15HotIfGroup(),
    WinTitleFirefoxDevToolsSwitcher, 'FirefoxDevToolsActivateGroup',
    FirefoxExe, FirefoxWd, '', unset, '', unset, 10, true)

; Thesaurus.com - Edge
#HotIf NotAlt15HotIfGroup()()
!sc005::RunOrActivateIfExist(
    '^(?:Synonyms & Antonyms - Thesaurus\.com(?: - ' .
        '(?:\d+) Synonyms & Antonyms for [\w-]+| - Synonyms and Antonyms of Words) \| ' .
        'Thesaurus\.com) ' . WinTitleEdgeMain,
    ; CUR create helper function eg. EdgeProxyCmd(appId, appUrl, profile?) to avoid repeating this everywhere silverqx
    EdgeProxyExe . ' --profile-directory=Default --app-id=pmcbkjoagpdhpneecimdejmkegihmiic ' .
        '--app-url=https://www.thesaurus.com/',
    EdgeWd, 'Max', () => Send('{F11}'))
#HotIf ; NotAlt15HotIf()

; TypeScript Documentation - Chrome
CreateSwitchWindowsHotkeys('!sc006', 'N', NotAlt15HotIfGroup(),
    '^TypeScript Documentation - TypeScript: ' . WinTitleChromeMain,
    'TypeScriptDocsActivateGroup',
    ChromeProxyExe . ' --profile-directory=Default --app-id=epnipbjiakmdfpldbglcffpholipmpbi',
    ChromeWd, 'Max', () => Send('{F11}'), ChromeNewCallbackDelay)

; Chrome for Developers - Chrome
CreateSwitchWindowsHotkeys('!sc007', 'N', NotAlt15HotIfGroup(),
    '^Chrome for Developers(?:$|(?: - .+)*(  \|  .+)?(  \|  Chrome for Developers)$) ' .
        WinTitleChromeMain,
    'ChromeForDevelopersActivateGroup',
    ChromeProxyExe . ' --profile-directory=Default --app-id=aoeeckacjnficgikkpbofpdcjoohpkld',
    ChromeWd, 'Max', () => Send('{F11}'), ChromeNewCallbackDelay)

MdnNewOrActivateCallback() => Send('^k')

; MDN Web Docs - Chrome
CreateSwitchWindowsHotkeys('!sc008', 'N', NotAlt15HotIfGroup(),
    WinTitleMdnPwaChrome, 'MdnDocsActivateGroup',
    'shell:AppsFolder\Chrome._crx_nfmchjfdeggjcknfcaialahihh',
    ChromeWd, 'Max',
    MdnNewOrActivateCallback, ChromeNewCallbackReadyDelay, MdnNewOrActivateCallback, 60)

; Bugfix/workaround for LButton stuck down during LButton Down - Ctrl Down
; ~Control Up::
; ~Alt Up::
; ~Shift Up::
; {
;     for mouseButton in ['LButton', 'RButton', 'MButton', 'XButton1', 'XButton2']
;         if (GetKeyState(mouseButton))
;             Send(Format('{{:s} Up}', mouseButton))
; }

; Open Control Panel
!<#i::Run(A_Programs . '\System Tools\Control Panel.lnk')

; Kindroid - Edge
; ^!+k::RunOrActivateIfExist(WinTitleKindroidEdge,
;     EdgeProxyExe . ' --profile-directory=Default --app-id=bifnnlhooalafhamofapphmipeanlkgb ' .
;         '--app-url=https://kindroid.ai/home/',
;     EdgeWd, 'Max', () => Send('{F11}'))

; Microsoft Edge
<#j::RunOnly(WinTitleEdgeNewTabMain,
    A_ProgramFiles . ' (x86)\Microsoft\Edge\Application\msedge.exe',
    ; 'shell:AppsFolder\Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe!App',
    '', 'Max', () => WinMaximize())
; Microsoft Edge - Incognito window
+<#j::RunOnly(WinTitleEdgeNewPrivTabMain,
    A_ProgramFiles . ' (x86)\Microsoft\Edge\Application\msedge.exe --inprivate',
    '', 'Max', () => WinMaximize())

; Google Chrome
<#m::RunOnly(WinTitleChromeNewTabMain,
    A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',
    '', 'Max', () => WinMaximize())
; Google Chrome - Incognito window
+<#m::RunOnly(WinTitleChromeNewPrivTabMain,
    A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe --incognito',
    '', 'Max', () => WinMaximize())

; Switch to the next/previous tab in the Firefox Developer Tools (Ctrl + [ or Ctrl + ])
#HotIf WinActive(WinTitleDevToolsFirefox)
^sc01A::Send('^{U+005B}')
^sc01B::Send('^{U+005D}')
#HotIf ; WinTitleDevToolsFirefox

; MDN Web Docs - Chrome
; ^!Space::RunOrActivateIfExist('^MDN Web Docs(( - .+){1,2} \| MDN$)? ' . WinTitleChromeMain,
;     'shell:AppsFolder\Chrome._crx_nfmchjfdeggjcknfcaialahihh',
;     ChromeWd, 'Max', () => Send('{F11}'),
;     MdnActivateCallback)
; MDN Web Docs - Edge
; ^!Space::RunOrActivateIfExist('^MDN Web Docs(( - .+){1,2} \| MDN$)? ' . WinTitleEdgeMain,
;     'shell:AppsFolder\developer.mozilla.org-6546C33F_vy8s4cepe0emg!App',
;     EdgeWd, 'Max', () => Send('{F11}'),
;     MdnActivateCallback)

; Send the Play/Pause command to the Last Found Window
;
; Legend for PostMessage:
; wParam must be window handle, if not defined the DefWindowProc will send it to its parent window
; lParam must be APPCOMMAND_XYZ
; << 16 is used to shift the APPCOMMAND value to the left, so it can be used as lParam
; WM_APPCOMMAND                0x0319
; APPCOMMAND_MEDIA_PLAY_PAUSE  14
SendPlayPauseCommand()
{
    PostMessage(0x0319,, 14 << 16)
}

PlayPauseMpcHc()
{
    if WinExist(WinTitleMpcHc)
        SendPlayPauseCommand()
}

; Alt-\ collides with PHPStorm GH Copilot - Show Completions shortcut

; Un/pause Spotify or MPC-HC (based on how long the key is pressed)
; Search Media_Play_Pause for Spotify.
~!sc056::HandleDualKey('sc056', 'T.3', unset, PlayPauseMpcHc)

; Open ChatGpt - Firefox
#HotIf WinExist(WinTitleChatGptFirefox)
!Space::WinActivate(WinTitleChatGptFirefox)
#HotIf ; WinTitleChatGptFirefox
; Open Grok - Firefox
#HotIf WinExist(WinTitleGrokFirefox)
#^Space::WinActivate(WinTitleGrokFirefox)
#HotIf ; WinTitleGrokFirefox
; Open ChatGpt - Chrome
; !Space:: RunOrActivateIfExist('^ChatGPT( - .+)?$ ' . WinTitleChromeMain,
;     ChromeProxyExe . ' --profile-directory=Default --app-id=pjcajilgilmeimpehofbnboikmkhmefb',
;     ChromeWd, 'Max', () => Send('{F11}'))
; Open ChatGpt - Edge PWA
; !Space:: RunOrActivateIfExist(WinTitleChatGptPwaEdge,
;     EdgeProxyExe . ' --profile-directory=Default --app-id=pjcajilgilmeimpehofbnboikmkhmefb ' .
;         '--app-url=https://chatgpt.com/c/681ca9b8-f930-8007-a6df-790af5298a12',
;     EdgeWd, 'Max', () => Send('{F11}'))
; Open ChatGpt - Windows Desktop
; !Space:: RunOrActivateIfExist(WinTitleChatGpt,
;     'shell:AppsFolder\OpenAI.ChatGPT-Desktop_2p2nqsd0c76g0!ChatGPT')

; Open Copilot - Windows Desktop
; ^!+Space::RunOrActivateIfExist(WinTitleCopilot,
;     'shell:AppsFolder\Microsoft.Copilot_8wekyb3d8bbwe!App', '', '',
;     () => Send('+{Tab 2}'), () => Send('{Esc}'))
; Open Copilot - Edge
; #!Space::RunOrActivateIfExist(
;     '^Copilot Web - Microsoft Copilot: Your AI companion$ ' . WinTitleEdgeMain,
;     EdgeProxyExe . ' --profile-directory=Default --app-id=aioglfahffbnednffnodjbiiojbochai ' .
;         '--app-url=https://copilot.microsoft.com/chats',
;     EdgeWd, 'Max', () => Send('{F11}'))

; Numpad keys
; ---

; Don't disable numlock if the shift is pressed
; SC052::Numpad0
; SC04F::Send('{Shift}{Numpad1}')11
; SC050::+Numpad2
; SC051::+Numpad3
; SC04B::+Numpad4
; SC04C::+Numpad5
; SC04D::+Numpad6
; SC047::+Numpad7
; SC048::+Numpad8
; SC049::+Numpad9

sendReloadFlowMonkeyExts(apiPath := '')
{
    http := SimpleHTTP(5, 5000) ; seconds, ms
    http.Patch('https://flowmonkey.merydeye-pulse.test/api/sw' . apiPath)

    SoundBeep(8000, 50)
}

^!+BackSpace::sendReloadFlowMonkeyExts('/reload/all')
#+F10::sendReloadFlowMonkeyExts('/chrome/reload')
#+F11::sendReloadFlowMonkeyExts('/edge/reload')
#+F12::sendReloadFlowMonkeyExts('/firefox/reload')

#^+F9::KeyHistory()
#^+F10::ListHotkeys()

; Close this script's own process
#^+F2::
{
    SoundBeep(7300, 70)
    DetectHiddenWindows(true)
    ProcessClose(WinGetPID('ahk_id ' . A_ScriptHwnd))
}
