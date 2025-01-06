#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Window>

#Include FullscreenGlobal.ahk

; Global Keyboard hotkeys
; -----------------------

; Restart the AhkOsGlobal scheduled task
^!BackSpace::
{
    SoundBeep(8000, 70)
    Run('powershell.exe -WindowStyle Hidden -NoLogo ' .
        'E:\autohotkey\os-global\Src\OsGlobal\User\Recompile-User.ps1',, 'Hide')
}

; Multimedia keys
; ---

; mpc-hc
CreateSwitchWindowsHotkeys('Browser_Home', 'N',
    WinTitleMpcHc, 'MpcHcActivateGroup',
    A_StartMenuCommon . '\Programs\MPC-HC x64\MPC-HC x64.lnk')

; Windows Calculator
CreateSwitchWindowsHotkeys('Launch_App2', 'N',
    'Calculator ahk_exe ApplicationFrameHost.exe ahk_class ApplicationFrameWindow',
    'CalculatorActivateGroup', 'shell:AppsFolder\Microsoft.WindowsCalculator_8wekyb3d8bbwe!App')

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

^!F3::Run(A_AppDataCommon . '\chocolatey\bin\Autoruns.exe',, 'Max')
; Black screensaver
^!F5::Run('scrnsave.scr /s',, 'Hide')
^!F6::Run('code.cmd --new-window E:\autohotkey\os-global', 'E:\autohotkey\os-global', 'Hide')
^+F6::Run('code.cmd --new-window E:\dotfiles', 'E:\dotfiles', 'Hide')

; qBittorrent
<#F8::
{
    if (WinExist('i)( |^)qBittorrent v\d{1,2}\.\d{1,2}\.\d{1,3}$'))
        WinActivate()
    else
        Run(A_ProgramsCommon . '\qBittorrent\qBittorrent.lnk')
}

; Alpha keys
; ---

; Open Control Panel
!<#i::Run(A_Programs . '\System Tools\Control Panel.lnk')

; Open Google Chrome
<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',, 'Max')
; Open Google Chrome - Incognito window
+<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe --incognito',, 'Max')

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
