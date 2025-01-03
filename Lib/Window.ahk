; Window related
; --------------

; Resize window almost to maximum and center it
TileWindowCenterFull(winTitle := 'A')
{
    ; Current Foreground window
    WinMove(8, 8, 1904, 1000, winTitle)
}

; Resize window to 800px and center it
TileWindowCenter800(winTitle := 'A')
{
    ; Current Foreground window
    WinMove(560, 8, 800, 1000, winTitle)
}

; Center the given window
CenterWindow(winTitle := 'A')
{
    WinExist(winTitle)
    WinGetPos(&initX, &initY, &width, &height)

    ; Do nothing if the geometry is the same as in the TileWindowCenterFull()
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

; Checks if the specified window is in the Fullscreen mode
IsWindowFullScreen(winTitle, skipPositionCheck := false)
{
    winHwnd := WinExist(winTitle)

    if (!winHwnd)
        return false

    style := WinGetStyle('ahk_id ' . winHwnd)
    WinGetPos(&x, &y, &width, &height, 'ahk_id ' . winHwnd)

    ; No border, caption, sizing border (thick frame), not minimized, and it has (of course) removed
    ; a border with a raised edge as it does not have the border.
    ; The fullscreen window may or may not be maximized.
    ; 0x00800000 is WS_BORDER
    ; 0x00C00000 is WS_CAPTION (WS_BORDER + WS_DLGFRAME)
    ; 0x20000000 is WS_MINIMIZE
    ; 0x00040000 is WS_THICKFRAME
    ; 0x00000100 is WS_EX_WINDOWEDGE
    return (style & 0x20C40100) = 0 &&
           (skipPositionCheck || (x = 0 && y = 0 && width = A_ScreenWidth && height = A_ScreenHeight))
}

; Checks if the specified window is Maximized
IsWindowMaximized(winTitle, skipPositionCheck := false)
{
    winHwnd := WinExist(winTitle)

    if (!winHwnd)
        return false

    style := WinGetStyle('ahk_id ' . winHwnd)
    WinGetPos(&x, &y, &width, &height, 'ahk_id ' . winHwnd)

    ; Maximized and not minimized
    ; 0x01000000 is WS_MAXIMIZE
    ; 0x20000000 is WS_MINIMIZE
    return (style & 0x1000000) = 0x1000000 && (style & 0x20000000) = 0 &&
           (skipPositionCheck || (x < 0 && y < 0 && width > A_ScreenWidth && height > A_ScreenHeight))
}

; Checks if the specified window has No Borders
IsNoBorderWindow(winTitle)
{
    winHwnd := WinExist(winTitle)

    if (!winHwnd)
        return false

    style := WinGetStyle('ahk_id ' . winHwnd)

    ; No border and not minimized
    ; 0x00800000 is WS_BORDER
    ; 0x20000000 is WS_MINIMIZE
    return (style & 0x20800000) = 0
}

; Switch windows callback
SwitchWindows(ThisHotkey, winTitle, groupName, runCallback)
{
    ; Nothing to switch, invoke the given target
    if (!WinExist(winTitle))
        return runCallback()

    ; Activate if it exists but is not focused
    if (!WinActive())
        return WinActivate()

    ; Switch to the next most recent matching window if it is already active
    GroupAdd(groupName, winTitle)
    GroupActivate(groupName, 'R')
}

; Create hotkeys for switching windows
CreateSwitchWindowsHotkeys(keyName, options, winTitle, groupName, runTarget)
{
    ; Switch between windows
    Hotkey(keyName, (ThisHotkey) => SwitchWindows(ThisHotkey, winTitle, groupName, runTarget))

    ; Run application (+keyName hotkey)
    if (InStr(options, 'N'))
        Hotkey(Format('+{:s}', keyName), (*) => Run(runTarget))
}
