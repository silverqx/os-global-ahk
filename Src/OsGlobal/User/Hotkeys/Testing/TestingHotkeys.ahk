; Silver Zachara <silver.zachara@gmail.com> 2018-2025

#Requires AutoHotkey v2

Persistent()
#SingleInstance Force
#UseHook true

; AutoHotkey settings
; -------------------

SetTitleMatchMode('RegEx')

; TestingHotkeys.ahk
; ------------------

#Include <OsGlobal\GlobalVariables>

#Include <OsGlobal\Containers>
#Include <OsGlobal\Title>
#Include <OsGlobal\Utils>
#Include <OsGlobal\Window>

; Testing
; -------

^!F9::
{
    activeWin := WinGetTitle("A") ; Get the title of the active window
    activeControl := ControlGetFocus("A") ; Get the focused control

    MsgBox("Active Window: " activeWin "`nFocused Control: " activeControl)
}

; ^!F11::
; {
;     MsgBox(DllCall("GetACP"))
;     MsgBox(A_FileEncoding)
; }

; #HotIf WinActive('Xyz ahk_exe xyz.exe ahk_class Xyz')
^!F10::
{
    ; WriteMainLog('TestingHotkeys.ahk F10 pressed')
    ; Loop
    ; {
    ;     WriteMainLog('TestingHotkeys.ahk F10 pressed')
    ;     Sleep(10)
    ;     ; if !GetKeyState("F10", "P")  ; The key has been released, so break out of the loop.
    ;     ;     break
    ; }
    ; MsgBox(Format(WinTitleFirefoxPwaSuffixRaw, 'Chatgpt'))
    ; MsgBox(WinGetTitle("ahk_id 1647568"))
    ; MsgBox('Hello from User Script')
    ; DetectHiddenText(true)
    ; DetectHiddenWindows(true)
    ; 201106 31192
    ; 201100 3118c
    ; 329624
    ; 329492
    ; 197248
    ; MsgBox(WinGetPID('ahk_id 5048144'))
    ; MsgBox(WinGetPID('ahk_id 1710636'))
    ; MsgBox(JoinArray(WinGetList('Windows Input Experience ahk_class Windows.UI.Core.CoreWindow')))
    ; WinGetPos(&x,&y,&w,&h,'ahk_id 201106')
    ; MsgBox('x: ' . x . ' y: ' . y . ' w: ' . w . ' h: ' . h)
    ; Send('{F12}')
    ; Sleep(100)
    ; ar := ['a1', false, 'c3']
    ; MsgBox(JoinArray(ar))
    ; for i, v in ar {
    ;     ar.Delete(i)
    ; }
    ; x := ar.suba
    ; MsgBox(ar.Length)
    ; MsgBox(JoinArray(ar))
    ; ; hwnd := DllCall('GetTopWindow', 'Ptr', '0')
    ; xx := WinGetList()
    ; MsgBox(JoinArray(xx))
    ; MsgBox(WinGetTitle('ahk_id ' xx[1]))

    ; WinSetAlwaysOnTop(-1, 'A')
    ; WinSetTransparent(170, 'A')
    ; MsgBox('xyz')
    ; Send('^+ř')
    ; winTitle := '^TV Program Tiviko$ ahk_class ApplicationFrameWindow'
    ; SoundBeep(10000, 70)
    ; WinSetStyle('^0xC00000', 'A')
    ; ControlSend('{Esc}', 'TEditControl1', winTitle)
    ; WinClose('ahk_class TEditorDockPanel3' . winTitle)
    ; PostMessage('0x0010', 0, 0, 'TPanel18', winTitle)
    ; MsgBox(ControlGetClassNN('Messages', winTitle))
    ; MsgBox(ControlGetHwnd('TMessageViewForm1', winTitle))
    ; MsgBox(ControlGetClassNN(ControlGetFocus(winTitle)))
    ; MsgBox((ControlGetHwnd('TEditControl2')))
    ; MsgBox(ControlGetHwnd('TEditControl2') ' ' ControlGetHwnd('TEditControl1'))
    ; ControlFocus('TButtonedEdit1', 'A')
}

; Close this script's own process
^!+F10::
{
    SoundBeep(7000, 70)
    DetectHiddenWindows(true)
    ProcessClose(WinGetPID('ahk_id ' . A_ScriptHwnd))
}
