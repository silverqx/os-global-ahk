#Include <OsGlobal\Window>

; Without any modifier
; --------------------
; Leader key ctrl-g related

; access
Sa()
{
    if (WinExist('__prístupy - Google Sheets'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\access.lnk')
}

; Google Sheets - bash_or_cmd_useful_commands
Sb()
{
    if (WinExist('bash_or_cmd_useful_commands - Google Sheets'))
        WinActivate()
    else
        Run(A_Programs . '\__my__\bash_or_cmd_useful_commands.lnk')
}

; open new čsfd.cz page in chrome
Sc()
{
    Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',, 'Max')
    Sleep(250)
    Send('csfd.cz{Enter}')
}

; čsfd.cz search in chrome
Sč()
{
    Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',, 'Max')
    Sleep(250)
    Send('csfd{Tab}')
}

; Dolby Access
Sd()
{
    if (WinExist('Dolby Access'))
        WinActivate()
    else
        Run('shell:AppsFolder\DolbyLaboratories.DolbyAccess_rz1tebttyb220!App')
}

; List all registered hotkeys (w/o they descriptions 🥺)
Sé()
{
    ListHotkeys()
}

; VMware Workstation
Sý()
{
    if (WinExist('(?:^| - )VMware Workstation$'))
        WinActivate()
    else
        Run(A_ProgramFiles . ' (x86)\VMware\VMware Workstation\vmware.exe')
}

; Facebook
Sf()
{
    if (WinExist('Facebook'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\Facebook.lnk')
}

; Grammly
Sg()
{
    if (WinExist('Free Grammar Checker | Grammly'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\Grammarly Checker.lnk')
}

; Skylink
Sk()
{
    Run(A_Programs . '\Chrome Apps\Skylink.lnk')
}

; SQLiteStudio
Sl()
{
    if (WinExist('SQLiteStudio (.*)'))
        WinActivate()
    else
        Run(A_Programs . '\Scoop Apps\SQLiteStudio.lnk')
}

; Messenger
Sm()
{
    if (WinExist('^Messenger(?:$| - .*)'))
        WinActivate()
    else
        Run('shell:AppsFolder\FACEBOOK.317180B0BB486_8xx8rvfyw5nnt!App')
}

; Notepad++
Sn()
{
    if (WinExist(' - Notepad++'))
        WinActivate()
    else
        Run(A_ProgramsCommon . '\Notepad++.lnk')
}

; PhpStorm
Sp()
{
    Run(A_ProgramsCommon . '\JetBrains\PhpStorm 2021.2.1.lnk')
}

; qMedia
Sq()
{
    if (WinExist('i)^ *qMedia v\d+\.\d+\.\d+$'))
        WinActivate()
    else
        Run(A_Programs . '\__my__\qMedia.lnk')
}

; Registry Editor
Sr()
{
    if (WinExist('i)^Registry Editor$'))
        WinActivate()
    else
        Run(A_WinDir . '\regedit.exe')
}

; Google Sheets - Seriály
Sř()
{
    if (WinExist('Seriály - Google Sheets'))
        WinActivate()
    else
        Run(A_Programs . '\__my__\Seriály.lnk')
}

; Google Sheets
Sš()
{
    if (WinExist('Sheets - Google Sheets'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\Sheets.lnk')
}

; Microsoft To Do
St()
{
    if (WinExist('Microsoft To Do'))
        WinActivate()
    else
        Run('shell:AppsFolder\Microsoft.Todos_8wekyb3d8bbwe!App')
}

; Control Panel - Sound Playback devices
Su()
{
    if (WinExist('^Sound$'))
        WinActivate()
    else {
        Run(A_WinDir . '\System32\rundll32.exe shell32.dll`,Control_RunDLL mmsys.cpl`,`,playback',,, &PID)
        WinWait('ahk_pid ' . PID)
        WinActivate('ahk_pid ' . PID)
        CenterWindow()
    }
}

; Settings - Volume Mixer
Sv()
{
    Run(A_WinDir . '\explorer.exe ms-settings:apps-volume')
}

; WinMerge
Sw()
{
    if (WinExist('^WinMerge'))
        WinActivate()
    else
        Run(A_ProgramsCommon . '\WinMerge\WinMerge.lnk')
}

; Youtube
Sy()
{
    Run(A_Programs . '\Chrome Apps\YouTube.lnk')
}

; Google Drive
Sž()
{
    if (WinExist('Google Drive - (?:.*) - Google Drive'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\Google Drive.lnk')
}
