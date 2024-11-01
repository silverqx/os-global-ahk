; Silver Zachara <silver.zachara@gmail.com> 2018-2024

#Requires AutoHotkey v2

Persistent
#NoTrayIcon
#SingleInstance Force
#UseHook True

;@Ahk2Exe-Base ../v2/AutoHotkey64.exe
;@Ahk2Exe-SetMainIcon %A_ScriptName~\.[^\.]+$~.ico%
;@Ahk2Exe-SetCompanyName Crystal Studio
;@Ahk2Exe-SetCopyright Copyright (©) 2024 Silver Zachara
;@Ahk2Exe-SetDescription OS Global (AutoHotkey)
;@Ahk2Exe-SetFileVersion %A_AhkVersion%
;@Ahk2Exe-SetName OS Global
;@Ahk2Exe-SetOrigFilename %A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-SetProductVersion 1.0.0.0
;@Ahk2Exe-UseResourceLang 0x0409

; TODO revisit the ordering and how this works silverqx
#Include ..\Lib\AHK-v2-libraries\Lib\WinEvent.ahk

; Global variables
; ----------------

SetTitleMatchMode('RegEx')

; Higher value for SetKeyDelay
KeyDelayqBt := 25
KeyDelayDefault := 10

; mpc-hc
MpcHcPip := false
MpcHcZoom25Key := '!;'
MpcHcZoom50Key := '!{+}'
MpcHcZoom100Key := '!ě'
; Default to 25%
MpcHcZoomKey := MpcHcZoom25Key
; Default width in normal mode
MpcHcDefaultNormalWidth := 1240
; Default pip mode width
MpcHcDefaultPipWidth := 420
; Custom position and size
MpcHcPipX := ''
MpcHcPipY := ''
MpcHcPipWidth := ''
MpcHcPipHeight := ''

; Pause/Unpause vmwrun.exe
VmrunPauseToggle := false

; Testing
; -------

; ^!+F9::
; {
;     MsgBox('xyz')
; }

; General Section
; ---------------

; Mouse shortcut for ctrl+home/end
~LButton & WheelRight::Send('^{Home}')
~LButton & WheelLeft::Send('^{End}')

; Suspend2Ram
~RButton & WheelUp::
{
    ; Hopefully this prevents strange sleep bug
    Sleep(2000)
    DllCall('PowrProf\SetSuspendState', 'Int', 0, 'Int', 0, 'Int', 0)
}

; Black screensaver
~RButton & WheelDown::
{
    Sleep(2000)
    Run('scrnsave.scr /s',, 'Hide')
}

; Hibernate
; ~RButton & WheelDown::
; {
;     Sleep(2000)
;     DllCall('PowrProf\SetSuspendState', 'Int', 1, 'Int', 0, 'Int', 0)
; }

; Hibernate (shift+calc)
+Launch_App2::
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

; Open ComputerOff
~LButton & WheelUp::
{
    ; If Options dialog is opened then activete it, instead of activate the Main window
    if (WinExist('^Options$ ahk_class TFormOptionsDialog') || WinExist('^ComputerOff$'))
        return WinActivate()

    Run('C:\optx64\computeroff\ComputerOff.exe',,, &PID)
    WinWait('ahk_pid ' . PID)
    WinActivate('ahk_pid ' . PID)
}

; Show Windows Start Menu
~LButton & WheelDown::Send('{LWin}')

^!F1::Run(A_Programs . '\__my__\Process Explorer.lnk',, 'Max')
^!F2::Run(A_Programs . '\__my__\WindowSpy (ahk).lnk')
^!F3::Run(A_AppDataCommon . '\chocolatey\bin\Autoruns.exe',, 'Max')
; Black screensaver
^!F5::Run('scrnsave.scr /s',, 'Hide')
^!F6::Run('code.cmd --new-window E:\autohotkey\os-global', 'E:\autohotkey\os-global', 'Hide')

; Open Google Chrome
<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',, 'Max')
; Open Google Chrome - Incognito window
+<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe --incognito',, 'Max')

; Center Window
^+F7::CenterWindow()
; Max. Tile Window
^+F8::FullTileWindow()

; Restart the AhkOsGlobal scheduled task
^+´::
{
    SoundBeep(8000, 70)
    Run('powershell.exe -WindowStyle Hidden -NoLogo E:\autohotkey\os-global\recompile.ps1',, 'Hide')
}

; Open Control Panel
!#i::Run(A_Programs . '\System Tools\Control Panel.lnk')

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

; Make the active window transparent
+ScrollLock::
{
	if (WinGetTransparent('A') = '')
        WinSetTransparent(190, 'A')
    else
        WinSetTransparent('Off', 'A')
}

; Switch to the previous window
ScrollLock::!Tab

; Leader key ctrl-g shortcuts
; ---------------------------

^g::
{
    ih := InputHook('T.8 L1 M', '{enter}.{esc}{tab}',
                    'a,b,c,č,d,é,f,g,k,l,m,n,p,q,r,ř,s,š,t,w,u,y,ž')
    ih.Start()
    result := ih.Wait()

    ; Send original shortcut on timeout
    if (result = 'Timeout')
        return Send('^g')

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; With the ctrl modifier, has to be first
    ; Look appropriate number mappings at https://en.wikipedia.org/wiki/ASCII#Control_code_chart
    if (userInput == Chr(1))
        Sca() ; TinyActions vmware
    else if (userInput == Chr(2))
        Scb() ; Manjaro vmware
    else if (userInput == Chr(4))
        Scd() ; Arch Docker Server vmware
    else if (userInput == Chr(13))
        Scm() ; TamperMonkey
    else if (userInput == Chr(15))
        Sco() ; GitHub
    else if (userInput == Chr(16))
        Scp() ; pgAdmin
    else if (userInput == Chr(19))
        Scs() ; SumatraPDF
    else if (userInput == Chr(20))
        Sct() ; Sk-CzTorrent
    else if (userInput == Chr(22))
        Scv() ; Gentoo vmware
    else if (userInput == Chr(23))
        Scw() ; Windows vmware
    else if (userInput == Chr(25))
        Scy() ; Youtube with WinExist()

    ; Without modifiers
    else if (userInput = 'a')
        Sa() ; access
    else if (userInput = 'b')
        Sb() ; Google Sheets - bash_or_cmd_useful_commands
    else if (userInput = 'c')
        Sc() ; open new čsfd.cz page in chrome
    else if (userInput = 'č')
        Sč() ; čsfd.cz search in chrome
    else if (userInput = 'd')
        Sd() ; Dolby Access
    else if (userInput = 'é')
        Sé() ; List all registered hotkeys (w/o they descriptions 🥺)
    else if (userInput = 'ý')
        Sý() ; VMware Workstation
    else if (userInput = 'f')
        Sf() ; Facebook
    else if (userInput = 'g')
        Sg() ; Grammly
    else if (userInput = 'k')
        Sk() ; Skylink
    else if (userInput = 'l')
        Sl() ; SQLiteStudio
    else if (userInput = 'm')
        Sm() ; Messenger
    else if (userInput = 'n')
        Sn() ; Notepad++
    else if (userInput = 'p')
        Sp() ; PhpStorm
    else if (userInput = 'q')
        Sq() ; qMedia
    else if (userInput = 'r')
        Sr() ; Registry Editor
    else if (userInput = 'ř')
        Sř() ; Google Sheets - Seriály
    else if (userInput = 's')
        Ss() ; qBittorrent
    else if (userInput = 'š')
        Sš() ; Google Sheets
    else if (userInput = 't')
        St() ; Microsoft To Do
    else if (userInput = 'u')
        Su() ; Control Panel - Sound Playback devices
    else if (userInput = 'v')
        Sv() ; Settings - Volume Mixer
    else if (userInput = 'w')
        Sw() ; WinMerge
    else if (userInput = 'y')
        Sy() ; Youtube w/o WinExist()
    else if (userInput = 'ž')
        Sž() ; Google Drive
}

; mpc-hc PIP mode
; ---------------
; PIP doesn't work well, doing whatever it wants, it behaves the same in ahk v1 as well so upgrade
; to ahk v2 isn't a problem.

; Manually toogle MpcHcPip
#HotIf WinActive('ahk_exe mpc-hc64.exe')
^F7::
{
    global MpcHcPip

    MpcHcPip := !MpcHcPip

    value := MpcHcPip ? 'enabled' : 'disabled'
    MsgBox('PIP mode : ' . value, 'Toogle MpcHcPip flag', 'T1')
}

; Reset x, y restore positions and sizes for pip mode
#HotIf WinActive('ahk_exe mpc-hc64.exe')
^F8::
{
    MpcHcResetPipPositions()

    MsgBox('Reset x, y restore positions and sizes', 'Reset PIP mode positions', 'T1')
}

; Disable PIP mode
#HotIf WinActive('ahk_exe mpc-hc64.exe')
^Enter::
{
    global MpcHcPip

    if (isWindowFullScreen('A') && MpcHcPip)
        return Send('!{Enter}')

    ; ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    else if (!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip)
        return MpcHcDisablePip()

    else if (MpcHcPip) {
        MpcHcDisablePip()
        MpcHcPip := false
        return
    }

    MpcHcEnablePip()
    MpcHcPip := true
}

#HotIf WinActive('ahk_exe mpc-hc64.exe')
^!Left::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveLeft()
}

#HotIf WinActive('ahk_exe mpc-hc64.exe')
^!Right::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveRight()
}

#HotIf WinActive('ahk_exe mpc-hc64.exe')
^!Up::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveTop()
}

#HotIf WinActive('ahk_exe mpc-hc64.exe')
^!Down::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveBottom()
}

; qBittorrent Section
; -------------------

; Classic video
#HotIf WinActive('ahk_exe qbittorrent.exe')
^BackSpace::
{
    ; Assign to video category
    Send('{AppsKey}{Down 7}{Right}{Up}{Enter}')
    ; Assign seed tag
    ; Send('{AppsKey}{Down 8}{Right}{Up 2}{Enter}')
    ; Close Tags sub-menu
    ; Send('{Esc}')
    ; Download in sequential order
    ; Send('{Down 4}{Enter}')
    Send('{AppsKey}{Up 8}{Enter}')
    ; Download first and last pieces first
    Send('{AppsKey}{Up 7}{Enter}')
}

; No-limit video
#HotIf WinActive('ahk_exe qbittorrent.exe')
^+BackSpace::
{
    ; Force resume
    Send('{AppsKey}{Down 2}{Enter}')
    ; Assign to video category
    Send('{AppsKey}{Down 7}{Right}{Up}{Enter}')
    ; Assign force seed tag
    Send('{AppsKey}{Down 8}{Right}{Up}{Enter}')
    ; Close Tags sub-menu
    Send('{Esc}')
    ; Download in sequential order
    Send('{Down 4}{Enter}')
    ; Download first and last pieces first
    Send('{AppsKey}{Up 7}{Enter}')

    ; Open Torrent options modal
    Send('{AppsKey}{Up 10}{Enter}')
    SetKeyDelay(KeyDelayqBt)
    Sleep(120)
    ; Set no share limit
    Send('{Tab 8}{Down}{Enter}')
    ; Close Torrent options modal
    Send('{Enter}')
    SetKeyDelay(KeyDelayDefault)
}

; When more torrents selected
#HotIf WinActive('ahk_exe qbittorrent.exe')
^+!BackSpace::
{
    ; Assign to video category
    Send('{AppsKey}{Down 6}{Right}{Up}{Enter}')
    ; Assign seed tag
    Send('{AppsKey}{Down 7}{Right}{Up 2}{Enter}')
    ; Close Tags sub-menu
    Send('{Esc}')
    ; Download in sequential order
    Send('{Down 4}{Enter}')
    ; Download first and last pieces first
    Send('{AppsKey}{Up 7}{Enter}')
}

; No-limit if more torrents selected
#HotIf WinActive('ahk_exe qbittorrent.exe')
^!F12::
{
    ; Force resume
    Send('{AppsKey}{Down 2}{Enter}')
    ; Assign to video category
    Send('{AppsKey}{Down 6}{Right}{Up}{Enter}')
    ; Assign seed and force seed tags
    Send('{AppsKey}{Down 7}{Right}{Up}{Enter}{Up}{Enter}')
    ; Close Tags sub-menu
    Send('{Esc}')
    ; Download in sequential order
    Send('{Down 4}{Enter}')
    ; Download first and last pieces first
    Send('{AppsKey}{Up 7}{Enter}')

    ; Open Torrent options modal
    Send('{AppsKey}{Up 10}{Enter}')
    SetKeyDelay(KeyDelayqBt)
    Sleep(120)
    ; Set no share limit
    Send('{Tab 6}{Down 2}{Up}{Space}')
    ; Close Torrent options modal
    Send('{Enter}')
    SetKeyDelay(KeyDelayDefault)
}

; Assign to video category
; #HotIf WinActive('ahk_exe qbittorrent.exe')
; ^+BackSpace::
; {
;     ; Assign to video category
;     Send('{AppsKey}{Down 7}{Right}{Up}{Enter}')
;     ; Assign seed tag
;     Send('{AppsKey}{Down 8}{Right}{Up 2}{Enter}')
;     ; Close Tags sub-menu and context menu
;     Send('{Esc}{Esc}')
; }

; Preview
#HotIf WinActive('ahk_exe qbittorrent.exe')
F3::Send('{AppsKey}{Up 9}{Enter}')

; Preview when seeding
#HotIf WinActive('ahk_exe qbittorrent.exe')
F4::Send('{AppsKey}{Up 6}{Enter}')

; Limit download rate shortcuts
#HotIf WinActive('ahk_exe qbittorrent.exe')
^;::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}0{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^+::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}1024{Enter}')
;    Send('{Tab 2}102{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^ě::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}2048{Enter}')
;    Send('{Tab 2}204{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^š::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}3072{Enter}')
;    Send('{Tab 2}307{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^č::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}4096{Enter}')
;    Send('{Tab 2}409{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^ř::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}5120{Enter}')
;    Send('{Tab 2}512{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^ž::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}6144{Enter}')
;    Send('{Tab 2}614{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^ý::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}7168{Enter}')
;    Send('{Tab 2}716{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^á::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}8192{Enter}')
;    Send('{Tab 2}819{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^í::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}9216{Enter}')
;    Send('{Tab 2}921{Enter}')
}

#HotIf WinActive('ahk_exe qbittorrent.exe')
^é::
{
    ; Open Torrent options modal
    Send('{AppsKey}{Down 10}{Enter}')
    Sleep(120)
    Send('{Tab 2}10240{Enter}')
;    Send('{Tab 2}1024{Enter}')
}

; Dark Souls 1 Save Manager
; -------------------------

; Save Hotkey
; This hotkey will create a new save in the current run, and select it.
#HotIf WinActive('ahk_exe DATA.exe')
F6::PostMessage(0x312, 1000, 0,, 'DarkSaves')

; Load Hotkey
; This hotkey loads the last save selected, or last save created - whichever is most recent.
#HotIf WinActive('ahk_exe DATA.exe')
F8::PostMessage(0x312, 1001, 0,, 'DarkSaves')

; Window related
; --------------

FullTileWindow(winTitle := 'A')
{
    ; Current Foreground window
    WinMove(8, 8, 1904, 1000, winTitle)
}

CenterWindow(winTitle := 'A')
{
    WinExist(winTitle)
    WinGetPos(&initX, &initY, &width, &height)

    ; Do nothing if the geometry is the same as in the FullTileWindow()
    if (width == 1904 && height == 1000 && initX == 8 && initY == 8)
        return

    x := (A_ScreenWidth / 2) - (width / 2)
    ; + 78 to take into account also the taskbar
    y := (A_ScreenHeight / 2) - ((height + 78) / 2)

    ; Prevent to overlay the taskbar
    if (height > 1000)
        y := 0
    ; Move a little to the top, better for an eye
    else if (y > 30)
        y -= 14

    WinMove(x < 0 ? 0 : x, y < 0 ? 0 : y)
}

; Checks if the specified window is in the fullscreen mode
IsWindowFullScreen(winTitle)
{
    winId := WinExist(winTitle)

    if (!winId)
        return false

    style := WinGetStyle('ahk_id ' . winId)
    WinGetPos(&x, &y, &width, &height, 'ahk_id ' . winId)

    ; 0x800000 is WS_BORDER.
    ; 0x20000000 is WS_MINIMIZE.
    ; No border and not minimized
    return !(style & 0x20800000 || x > 0 || y > 0 || width < A_ScreenWidth || height < A_ScreenHeight)
}

; Checks if the specified window has no borders
IsNoBorderWindow(winTitle)
{
    winId := WinExist(winTitle)

    if (!winId)
        return false

    style := WinGetStyle('ahk_id ' . winId)

    ; 0x800000 is WS_BORDER.
    ; 0x20000000 is WS_MINIMIZE.
    ; No border and not minimized
    return !(style & 0x20800000)
}

; Leader key ctrl-g related
; -------------------------

; With the ctrl modifier
; TinyActions vmware
Sca()
{
    global VmrunPauseToggle

    ih := InputHook('T.9 L1 M', '{enter}.{esc}{tab}', 'a,c,d,g,h,p,r,s')
    ih.Start()
    result := ih.Wait()

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; Without modifiers
    ; Pause/Unpause
    if (userInput = 'a') {
        ; Switch
        VmrunPauseToggle := !VmrunPauseToggle

        if (VmrunPauseToggle) {
            MsgBox('Paused TinyActions KVM', 'TinyActions', 'T1')
            Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpa-ta.ps1',, 'Hide')
        }
        else {
            MsgBox('Unpaused TinyActions KVM', 'TinyActions', 'T1')
            Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpa-ta.ps1',, 'Hide')
        }
    }
    ; Connect
    else if (userInput = 'c')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vm-ta.ps1',, 'Hide')
    ; Detach
    else if (userInput = 'd') {
        MsgBox('Detaching TinyActions KVM', 'TinyActions', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmd-ta.ps1',, 'Hide')
    }
    ; WinActivate()
    else if (userInput = 'g') {
        if (WinExist('^TinyORMGitHubActions - VMware KVM$'))
            WinActivate()
    }
    ; htop
    else if (userInput = 'h') {
        if (WinExist('^TinyActions KVM$'))
            WinActivate()
        else
            Run('wt --title "TinyActions KVM" pwsh -NoLogo -nop -c ssh silverqx@merydeye-tinyactions -t htop')
    }
    ; Preferences
    else if (userInput = 'p') {
        MsgBox('Preferences for TinyActions KVM', 'TinyActions', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmp-ta.ps1',, 'Hide')
    }
    ; Run
    else if (userInput = 'r') {
        MsgBox('Starting TinyActions KVM', 'TinyActions', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmr-ta.ps1',, 'Hide')
    }
    ; Suspend
    else if (userInput = 's') {
        MsgBox('Suspending TinyActions KVM', 'TinyActions', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vms-ta.ps1',, 'Hide')
    }
}
; Manjaro vmware
Scb()
{
    global VmrunPauseToggle

    ih := InputHook('T.9 L1 M', '{enter}.{esc}{tab}', 'a,c,d,g,p,r,s')
    ih.Start()
    result := ih.Wait()

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; Without modifiers
    ; Pause/Unpause
    if (userInput = 'a') {
        ; Switch
        VmrunPauseToggle := !VmrunPauseToggle

        if (VmrunPauseToggle) {
            MsgBox('Paused Manjaro KVM', 'Manjaro', 'T1')
            Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpa-b.ps1',, 'Hide')
        }
        else {
            MsgBox('Unpaused Manjaro KVM', 'Manjaro', 'T1')
            Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpa-b.ps1',, 'Hide')
        }
    }
    ; Connect
    else if (userInput = 'c')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vm-b.ps1',, 'Hide')
    ; Detach
    else if (userInput = 'd') {
        MsgBox('Detaching Manjaro KVM', 'Manjaro', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmd-b.ps1',, 'Hide')
    }
    ; WinActivate
    else if (userInput = 'g') {
        if (WinExist('^Manjaro - VMware KVM$'))
            WinActivate()
    }
    ; Preferences
    else if (userInput = 'p') {
        MsgBox('Preferences for Manjaro KVM', 'Manjaro', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmp-b.ps1',, 'Hide')
    }
    ; Run
    else if (userInput = 'r') {
        MsgBox('Starting Manjaro KVM', 'Manjaro', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmr-b.ps1',, 'Hide')
    }
    ; Suspend
    else if (userInput = 's') {
        MsgBox('Suspending Manjaro KVM', 'Manjaro', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vms-b.ps1',, 'Hide')
    }
}
; Arch Docker Server vmware
Scd()
{
    global VmrunPauseToggle

    ih := InputHook('T.9 L1 M', '{enter}.{esc}{tab}', 'a,c,d,p,r,s')
    ih.Start()
    result := ih.Wait()

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; Without modifiers
    ; Pause/Unpause
    if (userInput = 'a') {
        ; Switch
        VmrunPauseToggle := !VmrunPauseToggle

        if (VmrunPauseToggle) {
            MsgBox('Paused Ubuntu Docker KVM', 'Arch Docker Server', 'T1')
            Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpa-d.ps1',, 'Hide')
        }
        else {
            MsgBox('Unpaused Ubuntu Docker KVM', 'Arch Docker Server', 'T1')
            Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpa-d.ps1',, 'Hide')
        }
    }
    ; Connect
    else if (userInput = 'c')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vm-d.ps1',, 'Hide')
    ; Detach
    else if (userInput = 'd') {
        MsgBox('Detaching Ubuntu Docker KVM', 'Arch Docker Server', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmd-d.ps1',, 'Hide')
    }
    ; htop
    else if (userInput = 'h') {
        if (WinExist('^Arch Docker Server KVM$'))
            WinActivate()
        else
            Run('wt --title "Arch Docker Server KVM" pwsh -NoLogo -nop -c ssh root@merydeye-server -t htop')
    }
    ; Preferences
    else if (userInput = 'p') {
        MsgBox('Preferences for Ubuntu Docker KVM', 'Arch Docker Server', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmp-d.ps1',, 'Hide')
    }
    ; Run
    else if (userInput = 'r') {
        MsgBox('Starting Ubuntu Docker KVM', 'Arch Docker Server', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmr-d.ps1',, 'Hide')
    }
    ; Suspend
    else if (userInput = 's') {
        MsgBox('Suspending Ubuntu Docker KVM', 'Arch Docker Server', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vms-d.ps1',, 'Hide')
    }
}
; TamperMonkey
Scm()
{
    if (WinExist('^TamperMonkey'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\TamperMonkey.lnk')
}
; GitHub
Sco()
{
    if (WinExist('^GitHub'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\GitHub.lnk')
}
; pgAdmin
Scp()
{
    if (WinExist('^pgAdmin 4$'))
        WinActivate()
    else
        Run(A_ProgramsCommon . '\PostgreSQL 16\pgAdmin 4.lnk')
}
; SumatraPDF
Scs()
{
    if (WinExist('SumatraPDF'))
        WinActivate()
    else
        Run(A_StartMenuCommon . '\SumatraPDF.lnk')
}
; Sk-CzTorrent
Sct()
{
    if (WinExist('(?:^Sk-CzTorrent \||\| SkTorrent\.eu)'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\SkTorrent.lnk')
}
; Gentoo vmware
Scv()
{
    global VmrunPauseToggle

    ih := InputHook('T.9 L1 M', '{enter}.{esc}{tab}', 'a,c,d,g,h,p,r,s')
    ih.Start()
    result := ih.Wait()

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; Without modifiers
    ; Pause/Unpause
    if (userInput = 'a') {
        ; Switch
        VmrunPauseToggle := !VmrunPauseToggle

        if (VmrunPauseToggle) {
            MsgBox('Paused Gentoo KVM', 'Gentoo', 'T1')
            Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpa-g.ps1',, 'Hide')
        }
        else {
            MsgBox('Unpaused Gentoo KVM', 'Gentoo', 'T1')
            Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpa-g.ps1',, 'Hide')
        }
    }
    ; Connect
    else if (userInput = 'c')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vm-g.ps1',, 'Hide')
    ; Detach
    else if (userInput = 'd') {
        MsgBox('Detaching Gentoo KVM', 'Gentoo', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmd-g.ps1',, 'Hide')
    }
    ; WinActivate
    else if (userInput = 'g') {
        if (WinExist('^gentoo - VMware KVM$'))
            WinActivate()
    }
    ; htop
    else if (userInput = 'h') {
        if (WinExist('^Gentoo KVM$'))
            WinActivate()
        else
            Run('wt --title "Gentoo KVM" pwsh -NoLogo -nop -c ssh silverqx@merydeye-gentoo -t htop')
    }
    ; Preferences
    else if (userInput = 'p') {
        MsgBox('Preferences for Gentoo KVM', 'Gentoo', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmp-g.ps1',, 'Hide')
    }
    ; Run
    else if (userInput = 'r') {
        MsgBox("Starting Gentoo KVM without Administrator privileges doesn't work.`n" .
            'Use ^<j>v r instead which has Administrator privileges.', 'Gentoo')
    }
    ; Suspend
    else if (userInput = 's') {
        MsgBox('Suspending Gentoo KVM', 'Gentoo', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vms-g.ps1',, 'Hide')
    }
}
; Windows vmware
Scw()
{
    global VmrunPauseToggle

    ih := InputHook('T.9 L1 M', '{enter}.{esc}{tab}', 'a,c,d,p,r,s')
    ih.Start()
    result := ih.Wait()

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; Without modifiers
    ; Pause/Unpause
    ; VM is encrypted, have to figure how to ask password somehow
    ; if (userInput = 'a') {
    ;     ; Switch
    ;     VmrunPauseToggle := !VmrunPauseToggle

    ;     if (VmrunPauseToggle) {
    ;         MsgBox('Paused Windows KVM', 'Windows', 'T1')
    ;         Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmpa-w.ps1',, 'Hide')
    ;     }
    ;     else {
    ;         MsgBox('Unpaused Windows KVM', 'Windows', 'T1')
    ;         Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmunpa-w.ps1',, 'Hide')
    ;     }
    ; }
    ; Connect
    if (userInput = 'c')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vm-w.ps1',, 'Hide')
    ; Detach
    else if (userInput = 'd') {
        MsgBox('Detaching Windows KVM', 'Windows', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmd-w.ps1',, 'Hide')
    }
    ; Preferences
    else if (userInput = 'p') {
        MsgBox('Preferences for Windows KVM', 'Windows', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmp-w.ps1',, 'Hide')
    }
    ; Run
    ; VM is encrypted, have to figure how to ask password somehow
    ; else if (userInput = 'r') {
    ;     MsgBox('Starting Windows KVM', 'Windows', 'T1')
    ;     Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vmr-w.ps1',, 'Hide')
    ; }
    ; Suspend
    else if (userInput = 's') {
        MsgBox('Suspending Windows KVM', 'Windows', 'T1')
        Run('powershell.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\vms-w-kvm.ps1',, 'Hide')
    }
}
; Youtube
Scy()
{
    if (WinExist('(?:\(\d+\) )?(?:.* - )?(?:YouTube(?: Studio)?)$'))
        WinActivate()
    else
        Run(A_Programs . '\Chrome Apps\YouTube.lnk')
}

; Without any modifier
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
    ListHotkeys
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
    if (WinExist('Messenger (.*)'))
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
; qBittorrent
Ss()
{
    if (WinExist('i)( |^)qBittorrent v\d{1,2}\.\d{1,2}\.\d{1,3}$'))
        WinActivate()
    else
        Run(A_ProgramsCommon . '\qBittorrent\qBittorrent.lnk')
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

; mpc-hc PIP mode
; ---------------

MpcHcEnablePip()
{
    global MpcHcZoomKey, MpcHcDefaultPipWidth
    global KeyDelayqBt, KeyDelayDefault
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    if (!WinExist('A'))
        return

    SetKeyDelay(KeyDelayqBt)

    ; Enable StayOnTop and Hide Playlist
    Send('^a^!a')
    ; Compact mode
    Send('{+}')

    ; Top right corner - default position
    if (MpcHcPipX == '' && MpcHcPipY == '') {
        ; Zoom by MpcHcZoomKey variable
        Send(MpcHcZoomKey)
        Sleep(60)

        ; Compute width and height, mpc-hc sets correct aspect ratio so use it to compute correct height
        WinGetPos(,, &width, &height)
        newWidth := MpcHcDefaultPipWidth
        newHeight := MpcHcDefaultPipWidth / (width / height)

        WinMove(A_ScreenWidth - MpcHcDefaultPipWidth - 20, 20, newWidth, newHeight)
    }
    ; Restore custom position and size
    else {
        ; Disable Fullscreen
        Send('!{Enter}')

        WinMove(MpcHcPipX, MpcHcPipY, MpcHcPipWidth, MpcHcPipHeight)
    }

    SetKeyDelay(KeyDelayDefault)
}

MpcHcDisablePip()
{
    global KeyDelayqBt, KeyDelayDefault
    global MpcHcZoomKey, MpcHcDefaultNormalWidth
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    if (!WinExist('A'))
        return

    SetKeyDelay(KeyDelayqBt)

    ; Store x and y positions and sizes in pip mode only if the pip window has been moved or resized
    WinGetPos(&x, &y, &width, &height)

    if (x != (A_ScreenWidth - width - 20) || y != 20 ||
        MpcHcPipWidth != width || MpcHcPipHeight != height
    ) {
        MpcHcPipX := x
        MpcHcPipY := y
        MpcHcPipWidth := width
        MpcHcPipHeight := height
    }

    ; Dummy shortcut to fix W11 alt bug
    Send('!-')
    ; Disable StayOnTop
    Send('^a')
    ; Normal mode
    Send('š')
    ; Zoom by MpcHcZoomKey variable
    Send(MpcHcZoomKey)
    ; Show playlist
    Send('^!a')

    ; Compute width and height, mpc-hc sets correct aspect ratio so use it to compute correct height
    Sleep(60)
    WinGetPos(,, &width, &height)
    newWidth := MpcHcDefaultNormalWidth
    newHeight := MpcHcDefaultNormalWidth / (width / height)

    ; Default position I want to
    WinMove(60, 40, newWidth, newHeight)

    ; Fullscreen
    Send('!{Enter}')

    SetKeyDelay(KeyDelayDefault)
}

MpcHcResetPipPositions()
{
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    MpcHcPipX := ''
    MpcHcPipY := ''
    MpcHcPipWidth := ''
    MpcHcPipHeight := ''
}

MpcHcMoveLeft()
{
    if (!WinExist('A'))
        return

    WinGetPos(&x, &y, &width, &height)

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (top, bottom) of pip window
    result := RegExMatch(snapPosition, '([TLBR][a-z]+)(?:[TLBR][a-z]+)', &Match)

    ; TODO add Match.Count check, check all other RegExMatch-es silverqx

    moveToX := 20

    if (Match[1] == 'Top')
        moveToY := 20

    else if (Match[1] == 'Bottom')
        moveToY := A_ScreenHeight - height - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove(moveToX, moveToY)
}

MpcHcMoveRight()
{
    if (!WinExist('A'))
        return

    WinGetPos(&x, &y, &width, &height)

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (top, bottom) of pip window
    result := RegExMatch(snapPosition, '([TLBR][a-z]+)(?:[TLBR][a-z]+)', &Match)

    moveToX := A_ScreenWidth - width - 20

    if (Match[1] == 'Top')
        moveToY := 20

    else if (Match[1] == 'Bottom')
        moveToY := A_ScreenHeight - height - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove(moveToX, moveToY)
}

MpcHcMoveTop()
{
    if (!WinExist('A'))
        return

    WinGetPos(&x, &y, &width, &height)

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (left, right) of pip window
    result := RegExMatch(snapPosition, '(?:[TLBR][a-z]+)([TLBR][a-z]+)', &Match)

    moveToY := 20

    if (Match[1] == 'Left')
        moveToX := 20

    else if (Match[1] == 'Right')
        moveToX := A_ScreenWidth - width - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove(moveToX, moveToY)
}

MpcHcMoveBottom()
{
    if (!WinExist('A'))
        return

    WinGetPos(&x, &y, &width, &height)

    snapPosition := MpcHcInferPreSnapPosition(x, y, width, height)

    ; Match[1] will store position (left, right) of pip window
    result := RegExMatch(snapPosition, '(?:[TLBR][a-z]+)([TLBR][a-z]+)', &Match)

    moveToY := A_ScreenHeight - height - 20

    if (Match[1] == 'Left')
        moveToX := 20

    else if (Match[1] == 'Right')
        moveToX := A_ScreenWidth - width - 20

    ; Already on position
    if (x == moveToX && y == moveToY)
        return

    WinMove(moveToX, moveToY)
}

; Infer current pip window position
MpcHcInferPreSnapPosition(x, y, width, height)
{
    result := ''

    if (y + height / 2 < A_ScreenHeight / 2)
        result .= 'Top'
    else
        result .= 'Bottom'

    if (x + width / 2 < A_ScreenWidth / 2)
        result .= 'Left'
    else
        result .= 'Right'

    return result
}

; Set initial window properties
; -----------------------------

WinEvent.Show(WIQtMaintenanceTool, 'Maintain Qt ahk_class Qt660QWindowIcon ahk_exe MaintenanceTool.exe')

WIQtMaintenanceTool(hook, hWnd, *) {
    FullTileWindow('ahk_id ' . hWnd)
}
