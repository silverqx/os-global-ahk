#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Window>

; Without any modifier
; --------------------
; Leader key Ctrl-g related

; access
Sa() =>
    RunOrActivateIfExist('__prístupy - Google Sheets', A_Programs . '\Chrome Apps\access.lnk',,,
        () => Send('{F11}'),, ChromeNewCallbackDelay)

; Google Sheets - bash_or_cmd_useful_commands
Sb() =>
    RunOrActivateIfExist('bash_or_cmd_useful_commands - Google Sheets',
        A_Programs . '\__my__\bash_or_cmd_useful_commands.lnk',,,
        () => Send('{F11}'),, ChromeNewCallbackDelay)

; open new čsfd.cz page in chrome
Sc()
{
    ; Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',, 'Max')
    ; Sleep(250)
    ; Send('csfd.cz{Enter}')
}

; čsfd.cz search in chrome
Sč() =>
    RunOrActivateIfExist('^ČSFD.cz($| - )', A_Programs . '\Chrome Apps\ČSFD.cz.lnk',,,
        () => Send('{F11}'),, ChromeNewCallbackDelay)

; Dolby Access
Sd() =>
    RunOrActivateIfExist('Dolby Access',
        'shell:AppsFolder\DolbyLaboratories.DolbyAccess_rz1tebttyb220!App')

; List all registered hotkeys (w/o they descriptions 🥺)
; Sé() => ListHotkeys()

; VMware Workstation
Sý() =>
    RunOrActivateIfExist('(?:^| - )VMware Workstation$',
        A_ProgramFiles . ' (x86)\VMware\VMware Workstation\vmware.exe')

; Facebook
Sf() =>
    RunOrActivateIfExist('Facebook(?:$| - .*(?: | Facebook))',
        'shell:AppsFolder\FACEBOOK.FACEBOOK_8xx8rvfyw5nnt!App',,,
        () => Send('{F11}'))

; Grammarly
Sg()
{
    ; if (WinExist('Free Grammar Checker | Grammly'))
    ;     WinActivate()
    ; else
    ;     Run(A_Programs . '\Chrome Apps\Grammarly Checker.lnk')
}

; Skylink
Sk()
{
    ; Run(A_Programs . '\Chrome Apps\Skylink.lnk')
}

; SQLiteStudio
Sl() =>
    RunOrActivateIfExist('SQLiteStudio (.*)', A_Programs . '\Scoop Apps\SQLiteStudio.lnk')

; Messenger
; Sm() =>
;     RunOrActivateIfExist('^Messenger(?:$| - .*)',
;         A_Programs . '\Chrome Apps\Messenger.lnk',,,
;         () => Send('{F11}'),, ChromeNewCallbackDelay)

; Notepad++
Sn() =>
    RunOrActivateIfExist('(?: - Notepad\+\+)$', A_ProgramsCommon . '\Notepad++.lnk',,, () => Send('{F11}'))

; PhpStorm
Sp() =>
    Run(A_Programs . '\JetBrains Toolbox\PhpStorm Early Access Program.lnk')

; qBittorrent
Sq() =>
    RunOrActivateIfExist(WinTitleQBittorrent, A_ProgramsCommon . '\qBittorrent\qBittorrent.lnk')

; Registry Editor
Sr() =>
    RunOrActivateIfExist('^Registry Editor$', A_WinDir . '\regedit.exe')

; Google Sheets - Seriály
Sř() =>
    RunOrActivateIfExist('Seriály - Google Sheets', A_Programs . '\__my__\Seriály.lnk',,,
        () => Send('{F11}'),, ChromeNewCallbackDelay)

; SumatraPDF
Ss() =>
    RunOrActivateIfExist('SumatraPDF', A_StartMenuCommon . '\SumatraPDF.lnk')

; Google Sheets
Sš() =>
    RunOrActivateIfExist('Sheets - Google Sheets', A_Programs . '\Chrome Apps\Sheets.lnk',,,
        () => Send('{F11}'),, ChromeNewCallbackDelay)

; Microsoft To Do
St() =>
    RunOrActivateIfExist('Microsoft To Do', 'shell:AppsFolder\Microsoft.Todos_8wekyb3d8bbwe!App')

; Control Panel - Sound Playback devices
Su() =>
    RunOrActivateIfExist('^Sound$',
        A_WinDir . '\System32\rundll32.exe shell32.dll`,Control_RunDLL mmsys.cpl`,`,playback',,,
        () => CenterWindow())

; Settings - Volume Mixer
Sv() =>
    Run(A_WinDir . '\explorer.exe ms-settings:apps-volume')

; WinMerge
Sw() =>
    RunOrActivateIfExist('^WinMerge', A_ProgramsCommon . '\WinMerge\WinMerge.lnk')

; Youtube
Sy() =>
    Run(A_Programs . '\Chrome Apps\YouTube.lnk')

; Google Drive
Sž() =>
    RunOrActivateIfExist('Google Drive - (?:.*) - Google Drive',
        A_Programs . '\Chrome Apps\Google Drive.lnk',,,
        () => Send('{F11}'),, 2800) ; GDrive takes much longer to load
