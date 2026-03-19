#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Mouse>
#Include <OsGlobal\Window>

#Include TaskSwitcher.ahk

; Global Keyboard hotkeys
; -----------------------

; Restart the AhkOsGlobal scheduled task
^!´::
{
    SoundBeep(8000, 70)
    Run(PwshHiddenFile . A_InitialWorkingDir . '\Recompile-Admin.ps1',, 'Hide')
}

; Fn keys
; ---

TaskSchedulerNewCallback()
{
    Sleep(1000)
    Send('{Right}{Down 2}')
    Sleep(1800)
    Send('{Tab}')
}

^+F1::RunOrActivateIfExist('^Process Explorer - Sysinternals: ',
    A_Programs . '\__my__\Process Explorer.lnk',, 'Max')
^+F2::RunOrActivateIfExist('^Window Spy for AHKv2$',
    A_Programs . '\__my__\WindowSpy (ahk).lnk')
^!+F2::Run('pwsh.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\spyxx.ps1',, 'Hide')
#+F2::RunOrActivateIfExist('^Autoruns - Sysinternals: ',
    A_AppDataCommon . '\chocolatey\bin\Autoruns.exe', '', 'Max')
#+F3::RunOrActivateIfExist('^Registry Editor$',
    A_ProgramsCommon . '\Administrative Tools\Registry Editor.lnk')
#+F4::RunOrActivateIfExist('^Services$',
    A_ProgramsCommon . '\Administrative Tools\Services.lnk')
#+F5::RunOrActivateIfExist('^Task Scheduler$',
    A_ProgramsCommon . '\Administrative Tools\Task Scheduler.lnk', '', 'Max',
    TaskSchedulerNewCallback)

; Center Window
^+F7::CenterWindow()
; Max. Tile Window
^+F8::TileWindowCenterFull()
; Max. Tile Window
^!+F8::TileWindowCenter800()

; Special keys
; ---

; Make the active window transparent
+ScrollLock::
{
	if (WinGetTransparent('A') = '')
        WinSetTransparent(190, 'A')
    else
        WinSetTransparent('Off', 'A')
}

; Toggle Stay on Top
^!+ScrollLock::
{
    ; Get active window position
    hwnd := WinExist('A')
    if (hwnd == 0)
        return

    ahkId := 'ahk_id ' . hwnd
    WinSetAlwaysOnTop(-1, ahkId)
}

; Toggle Stay on Top
; ^!+ScrollLock::
; {
;     static Dimensions := 'w25 h25'
;     static PinX := 400, PinY := 11
;     static Timeout := 10 ; ms
;     static Ui := Gui()

;     ; Get active window position
;     hwnd := WinExist('A')
;     if (hwnd == 0)
;         return

;     static toggleOnTop := false
;     ahkId := 'ahk_id ' . hwnd
;     toggleOnTop := !IsAlwaysOnTop(ahkId)

;     WinSetAlwaysOnTop(toggleOnTop, ahkId)

;     ; Nothing to do, window have not enabled the topmost flag
;     if (!toggleOnTop) {
;         if (IsWindowVisible('ahk_id ' . Ui.Hwnd))
;             Ui.Hide()
;         return
;     }

;     WinGetPos(,, &widthInitial, &heightInitial, ahkId) ; Affected by DPIScaling (isn't scaled)

;     ; +E0x80020, +BackgroundTrans, Ui.BackColor, WinSetTransColor all are needed to correctly
;     ; render semi-transparent pixels
;     Ui.Opt('+AlwaysOnTop +ToolWindow -Caption -DPIScale -SysMenu +E0x80020 +Parent' . hwnd)
;     Ui.BackColor := '000000'

;     pin := Ui.AddPicture('x0 y0 ' . Dimensions, 'Resources\images\pin.png')
;     pin.Opt('+BackgroundTrans')
;     WinSetTransColor(Ui.BackColor . ' 255', pin)

;     Ui.Show(Format('NoActivate x{:d} y{:d} ' . Dimensions, widthInitial - PinX, PinY))
;     WinActivate(ahkId)
;     ; Critical('On')

;     SetTimer(CheckResize, Timeout)

;     CheckResize()
;     {
;         static LastWidth := 0, LastHeight := 0

;         if (!WinExist(ahkId))
;             return
;         WinGetPos(,, &width, &height, ahkId) ; Affected by DPIScaling (isn't scaled)

;         if ((width == LastWidth    && height == LastHeight) ||
;             (width == widthInitial && height == heightInitial)
;         )
;             return

;         Ui.Move(width - PinX)

;         LastWidth  := width
;         LastHeight := height
;     }
; }

; Switch to the previous window
ScrollLock::!Tab

; Alpha keys
; ---

; Snipping Tool - Preselect Window screenshot mode
PrintScreen::
{
    Send('{PrintScreen}')
    if (WinWait(WinTitleSnippingToolOverlay,, 1.2) == 0)
        return

    ; Focus follows mouse move after Window mode is selected, so +{Tab} doesn't make sense here
    MemorizeClick(918, 46, () => Send('{Home}{Down}{Enter}'))
}

; Snipping Tool - Preselect Rectangle screenshot mode
#+s::
{
    Send('{PrintScreen}')
    if (WinWait(WinTitleSnippingToolOverlay,, 1.2) == 0)
        return

    MemorizeClick(918, 46, SelectRectangleMode)
}

; Snipping Tool - Preselect Rectangle screenshot mode
SelectRectangleMode()
{
    ; Select Rectangle mode
    Send('{Home}{Enter}')
    Sleep(60)
    Send('+{Tab}') ; Focus doesn't follow mouse move after Rectangle mode is selected
}

; Microsoft Edge
<#j::RunOnly(WinTitleEdgeNewTabMain,
    A_ProgramFiles . ' (x86)\Microsoft\Edge\Application\msedge.exe',
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

; Voice typing
^!z::Send('#h')
; Open Settings
<#z::Send('#i')
; Open Control Panel - All Control Panel Items
<#+z::Run(A_Programs . '\System Tools\Control Panel',, 'Max')

#^+F7::KeyHistory()
#^+F8::ListHotkeys()

; Close this script's own process
#^+F3::
{
    SoundBeep(7300, 70)
    DetectHiddenWindows(true)
    ProcessClose(WinGetPID('ahk_id ' . A_ScriptHwnd))
}
