#Include <OsGlobal\Window>

; Global Keyboard hotkeys
; -----------------------

; Restart the AhkOsGlobal scheduled task
^!´::
{
    SoundBeep(8000, 70)
    Run('powershell.exe -WindowStyle Hidden ' .
        '-NoLogo E:\autohotkey\os-global\Src\OsGlobal\Admin\Recompile-Admin.ps1',, 'Hide')
}

; Fn keys
; ---

^+F1::Run(A_Programs . '\__my__\Process Explorer.lnk',, 'Max')
^!F2::Run(A_Programs . '\__my__\WindowSpy (ahk).lnk')
^!+F2::Run('pwsh.exe -WindowStyle Hidden -NoLogo E:\dotfiles\bin\spyxx.ps1',, 'Hide')

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

; Switch to the previous window
ScrollLock::!Tab

; Alpha keys
; ---

; Open Google Chrome
<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe',, 'Max')
; Open Google Chrome - Incognito window
+<#m::Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe --incognito',, 'Max')
