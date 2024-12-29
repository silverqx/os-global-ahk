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
KeyDelay25 := 25
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

; Touch Window from Outside/Inside
MpcHcTouchOutsideFrameToggle := false
; Pause/Unpause vmwrun.exe
VmrunPauseToggle := false
; Maximize the currently focused panel
TCPanelListingToggle := false

; WinTitle-s
WinTitleQBittorrent := 'ahk_exe qbittorrent.exe'
WinTitleMpcHc := 'ahk_exe mpc-hc64.exe ahk_class MediaPlayerClassicW'
WinTitleSmartGit := 'ahk_exe smartgit.exe ahk_class SWT_Window0'
WinTitleTC := 'ahk_exe TOTALCMD.EXE ahk_class TTOTAL_CMD'

; Testing
; -------

; #HotIf WinActive('Xyz ahk_exe xyz.exe ahk_class Xyz')
; ^!+F10::
; {
;     ; MsgBox('xyz')
;     ; Send('^+ř')
;     ; WinSetStyle('^0xC40000', 'A')
; }
; #HotIf ; WinActive('Xyz ahk_exe xyz.exe ahk_class Xyz')

; General Section
; ---------------
; TODO check and try to somehow use Morse; see https://www.autohotkey.com/board/topic/15574-morse-find-hotkey-press-and-hold-patterns/ silverqx

; Mouse shortcut for ctrl+home/end
~LButton & WheelRight::Send('^{Home}')
~LButton & WheelLeft::Send('^{End}')

; Exclude some applications from RButton related hotkeys
; GroupAdd('RButtonGroup', WinTitleMpcHc)

; Suspend2Ram
; #HotIf !WinActive('ahk_group RButtonGroup')
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
; #HotIf ; !WinActive('ahk_group RButtonGroup')

; Hibernate
; ~RButton & WheelDown::
; {
;     Sleep(2000)
;     DllCall('PowrProf\SetSuspendState', 'Int', 1, 'Int', 0, 'Int', 0)
; }

Browser_Home::
{
    if (WinExist(WinTitleMpcHc))
        WinActivate()
    else
        Run(A_StartMenuCommon . '\Programs\MPC-HC x64\MPC-HC x64.lnk')
}

; Browser_Home::
; {
;     winTitle := '( - Google Chrome)$ ahk_exe chrome.exe'
;     groupName := 'xyz'
;     if (WinExist(winTitle)) {
;         GroupAdd(groupName, winTitle)

;         ; Check if a matching window is in already focus
;         ; Switch to the next matching window
;         if WinActive(winTitle)
;             GroupActivate(groupName, 'R')
;         ; If a window is currently open but not focused, activate it
;         else
;             WinActivate(winTitle)
;     }
;     else
;         Run(A_StartMenuCommon . '\Programs\MPC-HC x64.lnk')
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
    ; If Options dialog is opened then activate it, instead of activate the Main window
    if (WinExist('^Options$ ahk_class TFormOptionsDialog') || WinExist('^ComputerOff$'))
        return WinActivate()

    Run('C:\optx64\computeroff\ComputerOff.exe',,, &PID)
    WinWait('ahk_pid ' . PID)
    WinActivate('ahk_pid ' . PID)
}

; Show Windows Start Menu
~LButton & WheelDown::Send('{LWin}')

^!F3::Run(A_AppDataCommon . '\chocolatey\bin\Autoruns.exe',, 'Max')
; Black screensaver
^!F5::Run('scrnsave.scr /s',, 'Hide')
^!F6::Run('code.cmd --new-window E:\autohotkey\os-global', 'E:\autohotkey\os-global', 'Hide')
^+F6::Run('code.cmd --new-window E:\dotfiles', 'E:\dotfiles', 'Hide')

; Open Google Chrome
<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',, 'Max')
; Open Google Chrome - Incognito window
+<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe --incognito',, 'Max')

; Restart the AhkOsGlobal scheduled task
^!BackSpace::
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

; Leader key ctrl-g shortcuts
; ---------------------------

^g::
{
    ih := InputHook('T.8 L1 M', '{Enter}.{Esc}{Tab}',
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

; Manually toggle MpcHcPip
#HotIf WinActive(WinTitleMpcHc)
^F7::
{
    global MpcHcPip

    MpcHcPip := !MpcHcPip

    value := MpcHcPip ? 'enabled' : 'disabled'
    MsgBox('PIP mode : ' . value, 'Toggle MpcHcPip flag', 'T1')
}

; Reset x, y restore positions and sizes for pip mode
^F8::
{
    MpcHcResetPipPositions()

    MsgBox('Reset x, y restore positions and sizes', 'Reset PIP mode positions', 'T1')
}

; Disable PIP mode
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

^!Left::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveLeft()
}

^!Right::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveRight()
}

^!Up::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveTop()
}

^!Down::
{
    ; pip mode disabled OR ahk script was restarted so MpcHcPip := false and mpc-hc is still in pip mode
    if (!MpcHcPip && !(!isWindowFullScreen('A') && isNoBorderWindow('A') && !MpcHcPip))
        return

    MpcHcResetPipPositions()

    MpcHcMoveBottom()
}
#HotIf ; WinActive(WinTitleMpcHc)

; qBittorrent Section
; -------------------

; Assign to video category and force/ seed tag
QbtAssignVideoCategoryAndSeedTag(closeAction := 'SubMenu', assignForceSeed := false)
{
    ; Assign to video category
    Send('{AppsKey}y{Up}{Enter}')
    ; Assign seed tag
    Send('{AppsKey}g{Up 2}{Enter}')

    ; Assign force seed tag (for Trezzor Tracker)
    if (assignForceSeed)
        Send('{Down}{Enter}')

    ; Close Tags sub-menu or context menu
    switch closeAction {
        case 'SubMenu': Send('{Esc}')
        case 'AppMenu': Send('{Esc 2}')
    }
}

; Download in sequential order and first/last pieces first
QbtDownloadSequentialAndFirstLast()
{
    ; Download in sequential order
    Send('{Down 4}{Enter}')
    ; Download first and last pieces first
    Send('{AppsKey}g{Esc}{Down 5}{Enter}')
}

; Open Torrent options modal dialog and wait for it
QbtOpenTorrentOptionsModal()
{
    Send('{AppsKey}o')
    WinWait('^(Torrent Options)$ ' . WinTitleQBittorrent)
}

; Limit download speed to the given value
QbtSetDownloadSpeedLimit(value)
{
    ; Open Torrent options modal dialog and wait for it
    QbtOpenTorrentOptionsModal()
    Send(Format('{Tab 2}{:u}{Enter}', value))
}

; Classic video
#HotIf WinActive(WinTitleQBittorrent)
^BackSpace::
{
    ; Assign to video category and seed tag
    QbtAssignVideoCategoryAndSeedTag()
    ; Download in sequential order and first/last pieces first
    QbtDownloadSequentialAndFirstLast()
}

; No-limit video (for Trezzor Tracker)
^+BackSpace::
{
    ; Force resume
    Send('{AppsKey}t')
    ; Assign to video category and force/ seed tag
    QbtAssignVideoCategoryAndSeedTag('SubMenu', true)
    ; Download in sequential order and first/last pieces first
    QbtDownloadSequentialAndFirstLast()

    ; Open Torrent options modal and wait for it
    QbtOpenTorrentOptionsModal()
    ; Set no share limit
    Send('+{Tab 9}{Down}{Enter}')
    ; Close Torrent options modal
    Send('{Enter}')
}

; Assign to video category and seed tag
^F11::QbtAssignVideoCategoryAndSeedTag('AppMenu')
; Assign to video category and force/ seed tag (for Trezzor Tracker)
^+F11::QbtAssignVideoCategoryAndSeedTag('AppMenu', true)

; Preview
F3::Send('{AppsKey}v')

; Limit download rate shortcuts
^;::QbtSetDownloadSpeedLimit(0)
^+::QbtSetDownloadSpeedLimit(1024)
^ě::QbtSetDownloadSpeedLimit(2048)
^š::QbtSetDownloadSpeedLimit(3072)
^č::QbtSetDownloadSpeedLimit(4096)
^ř::QbtSetDownloadSpeedLimit(5120)
^ž::QbtSetDownloadSpeedLimit(6144)
^ý::QbtSetDownloadSpeedLimit(7168)
^á::QbtSetDownloadSpeedLimit(8192)
^í::QbtSetDownloadSpeedLimit(9216)
^é::QbtSetDownloadSpeedLimit(10240)
#HotIf ; WinActive(WinTitleQBittorrent)

; Fullscreen mode
; -------------------------

; Create a group to target more applications
; GroupAdd('FullscreenGroup', 'ahk_exe PSPad.exe') ; Doesn't work
GroupAdd('FullscreenGroup', WinTitleQBittorrent)
GroupAdd('FullscreenGroup', WinTitleTC)
GroupAdd('FullscreenGroup', 'ahk_exe TOTALCMD64.EXE ahk_class TTOTAL_CMD')

; Fullscreen
#HotIf WinActive('ahk_group FullscreenGroup')
F11::WinSetStyle('^0xC00000')
#HotIf ; WinActive('ahk_group FullscreenGroup')

; Visual Studio
; -------------------------

; Focus Navigation bar - Function Dropdown list
#HotIf WinActive('(?:Microsoft Visual Studio)$ ahk_exe devenv.exe')
^F2::Send('^{F2}{Tab 2}{Down}')

; Duplicate Selection and Comment
^NumpadDiv::Send('^!{Down}^{NumpadMult}{Up}{Left 2}')
^+NumpadDiv::Send('^!{Down}^{NumpadMult}{Up}')
#HotIf ; WinActive('(?:Microsoft Visual Studio)$ ahk_exe devenv.exe')

; Tiviko TV Program
; -------------------------

; Zoom in the Grid page
TivikoIncreaseZoom()
{
    ; Mouse must be inside this area
    MouseMove(40, 380, 0)
    ; Increase zoom
    Send('^{WheelUp 3}')
}

; Zoom in the Grid page
TivikoIncreaseZoomWithRestore()
{
    MouseGetPos(&xOriginal, &yOriginal)
    ; Increase zoom
    TivikoIncreaseZoom()
    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}

; Zoom in the Grid page after clicking the Grid button
TivikoIncreaseZoomOnGridClick()
{
    MouseGetPos(&xOriginal, &yOriginal)

    ; Nothing to do, not inside the Grid button area
    if(!((xOriginal >=  26 && yOriginal >= 280) &&
         (xOriginal <= 208 && yOriginal <= 326))
    )
        return

    ; Wait until the Grid view loads
    Sleep(1200) ; ~1100ms is minimum

    ; Increase zoom
    TivikoIncreaseZoom()
    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}

; Reload TV program and increase zoom
TivikoReloadGrid()
{
    MouseGetPos(&xOriginal, &yOriginal)

    ; Back
    Send('{Browser_Back}')
    Sleep(150)
    ; Grid button
    Click('100', '300')
    MouseMove(xOriginal, yOriginal, 0)
    Sleep(150)
    ; Increase zoom
    TivikoIncreaseZoom()

    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}

#HotIf WinActive('^TV Program Tiviko$ ahk_class ApplicationFrameWindow')
^\::TivikoIncreaseZoomWithRestore()

; Zoom in the Grid page on double right mouse button click (anywhere)
~RButton::
{
    if (ThisHotkey == A_PriorHotkey && A_TimeSincePriorHotkey < 300)
        TivikoReloadGrid()
}

; Zoom in the Grid page on double right mouse button click (anywhere)
~MButton::
{
    if (ThisHotkey == A_PriorHotkey && A_TimeSincePriorHotkey < 300)
        TivikoIncreaseZoomWithRestore()
}

~LButton::TivikoIncreaseZoomOnGridClick()
#HotIf ; WinActive('^TV Program Tiviko$ ahk_class ApplicationFrameWindow')

; Open Tiviko TV Program
; ~LButton & XButton1::
; {
;     if (WinExist('^TV Program Tiviko$'))
;         WinActivate()
;     else
;         Run('shell:AppsFolder\0BB81222.TVProgramTiviko_hev1qd965vk4r!App')
; }

; Total Commander
; -------------------------

; Get the currently focused panel (with the default value handling)
TCGetFocusedPanelClassNN()
{
    focusedHwnd := ControlGetFocus('A')
    focusedClassNN := ControlGetClassNN(focusedHwnd)

    ; Default is the Left panel
    if (focusedClassNN != 'TMyListBox1' && focusedClassNN != 'TMyListBox2')
        return 'TMyListBox1'

    return focusedClassNN
}

; Get the maximize position by the given ClassNN
TCGetMaximizePosition(classNN)
{
    ; Right panel
    if (classNN == 'TMyListBox1')
        return 0

    ; Left panel (TMyListBox2) or any other control
    return A_ScreenWidth
}

; Restore panels to 50/50
TCRestorePanelListing()
{
    MouseGetPos(&xOriginal, &yOriginal)
    ; Mouse must be in the center of the screen to correctly restore to 50/50
    MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2, 0)

    SetControlDelay(25) ; It fails often with the default value (20)
    ; Double click
    ControlClick('TPanel1', 'A',, 'Left', 2, 'NA')

    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}

; Maximize the currently focused panel
TCMaximizePanelListing()
{
    MouseGetPos(&xOriginal, &yOriginal)

    SetControlDelay(40) ; It fails often with the default value (20) even 35 is too low
    ControlClick('TPanel1', 'A',, 'Left', 1, 'NA D') ; Hold Down
    MouseMove(TCGetMaximizePosition(TCGetFocusedPanelClassNN()) , yOriginal)
    ControlClick('TPanel1', 'A',, 'Left', 1, 'NA U') ; Release (Up)

    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)
}

#HotIf WinActive(WinTitleTC)
^!t::{
    global TCPanelListingToggle

    if (TCPanelListingToggle)
        TCRestorePanelListing()
    else
        TCMaximizePanelListing()

    TCPanelListingToggle := !TCPanelListingToggle
}
#HotIf ; WinActive(WinTitleTC)

; mpc-hc
; ---------------

#HotIf WinActive(WinTitleMpcHc)
MButton::
{
    ; Only propagate the MButton when RButton is down/pressed because mpc-hc itself allows
    ; to define combined mouse hotkeys like RButton & MButton.
    if (GetKeyState('RButton'))
        return Send('{MButton}')

    ; Nothing to do, VRWindow1 isn't under the cursor
    MouseGetPos(,,, &mouseClassNN)
    if (mouseClassNN != 'VRWindow1')
        return

    global MpcHcTouchOutsideFrameToggle

    if (MpcHcTouchOutsideFrameToggle)
        Send('{F9}')
    else
        Send('{F10}')

    MpcHcTouchOutsideFrameToggle := !MpcHcTouchOutsideFrameToggle
}
#HotIf ; WinActive(WinTitleMpcHc)

; SmartGit
; --------

; Commits History button
#HotIf WinActive(WinTitleSmartGit)
^+h::
{
    SetControlDelay(-1)
    ControlClick('SWT_Window090', 'A',,,, 'NA')
}
#HotIf ; WinActive(WinTitleSmartGit)

; Google Chrome
; --------

; Show bookmarks bar
#HotIf WinActive('ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1')
^\::Send('^+b')
#HotIf ; WinActive('ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1')

; Dark Souls 1 Save Manager
; -------------------------

; Save Hotkey
; This hotkey will create a new save in the current run, and select it.
#HotIf WinActive('ahk_exe DATA.exe')
F6::PostMessage(0x312, 1000, 0,, 'DarkSaves')
#HotIf ; WinActive('ahk_exe DATA.exe')

; Load Hotkey
; This hotkey loads the last save selected, or last save created - whichever is most recent.
#HotIf WinActive('ahk_exe DATA.exe')
F8::PostMessage(0x312, 1001, 0,, 'DarkSaves')
#HotIf ; WinActive('ahk_exe DATA.exe')

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

    ih := InputHook('T.9 L1 M', '{Enter}.{Esc}{Tab}', 'a,c,d,g,h,p,r,s')
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

    ih := InputHook('T.9 L1 M', '{Enter}.{Esc}{Tab}', 'a,c,d,g,p,r,s')
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

    ih := InputHook('T.9 L1 M', '{Enter}.{Esc}{Tab}', 'a,c,d,p,r,s')
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

    ih := InputHook('T.9 L1 M', '{Enter}.{Esc}{Tab}', 'a,c,d,g,h,p,r,s')
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

    ih := InputHook('T.9 L1 M', '{Enter}.{Esc}{Tab}', 'a,c,d,p,r,s')
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
    global KeyDelay25, KeyDelayDefault
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    if (!WinExist('A'))
        return

    SetKeyDelay(KeyDelay25)

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
    global KeyDelay25, KeyDelayDefault
    global MpcHcZoomKey, MpcHcDefaultNormalWidth
    global MpcHcPipX, MpcHcPipY
    global MpcHcPipWidth, MpcHcPipHeight

    if (!WinExist('A'))
        return

    SetKeyDelay(KeyDelay25)

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

; Windows Events
; -------------------

; Qt Maintenance Tool
; -------------------

; Set initial window properties
WinEvent.Show(WEQtMaintenanceTool, 'Maintain Qt ahk_exe MaintenanceTool.exe ahk_class Qt660QWindowIcon')

WEQtMaintenanceTool(hook, hWnd, *) {
    FullTileWindow('ahk_id ' . hWnd)
}

; SmartGit
; --------

; Focus the Graph view (send hotkey) after displaying the Log Window
WinEvent.Show(WESmartGit, '(?:.*SmartGit .* )(?:\(Log\) Non-Commercial)$ ' . WinTitleSmartGit)

WESmartGit(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    Send('^+5')
}

; Visual Studio
; -------------

; Options - Focus the Search Input
WinEvent.Show(WEVisualStudioOptions, '^Options$ ahk_exe devenv.exe ahk_class #32770')

WEVisualStudioOptions(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    Send('^e')
}

; QtCreator
; -------------

; Preferences - Focus the Search Input
WinEvent.Show(WEQtCreatorPreferences, '^Preferences - Qt Creator$ ahk_exe qtcreator.exe')

WEQtCreatorPreferences(hook, hWnd, *) {
    WinWait('ahk_id ' . hWnd)
    Send('+{Tab}')
}

; Fullscreen on Open
; -------------

; WinEvent.Show(WEFullscreenOnOpen, WinTitleQBittorrent)
; WinEvent.Show(WEFullscreenOnOpen, WinTitleTC)

; WEFullscreenOnOpen(hook, hWnd, *) {
;     WinWait('ahk_id ' . hWnd)
;     WinSetStyle('^0xC00000')
; }

; mpc-hc
; -------------

; WinEvent.Show(WEMpcHc, WinTitleMpcHc)

; WEMpcHc(hook, hWnd, *) {
;     global MpcHcTouchOutsideFrameToggle
;     MpcHcTouchOutsideFrameToggle := false
; }
