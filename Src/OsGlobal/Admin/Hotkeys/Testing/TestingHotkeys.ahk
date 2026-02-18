#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Utils>
#Include <OsGlobal\Window>

; Testing
; -------

; ^!+F9::
; {
;     activeWin := WinGetTitle("A") ; Get the title of the active window
;     activeControl := ControlGetFocus("A") ; Get the focused control

;     MsgBox("Active Window: " activeWin "`nFocused Control: " activeControl)
; }


ss := 'Snipping Tool Overlay ahk_class XamlWindow ahk_exe SnippingTool.exe'
; #HotIf WinActive('Xyz ahk_exe xyz.exe ahk_class Xyz')
^!F11::
{
    MouseGetPos(&xOriginal, &yOriginal)

    ; Sleep(100)
    Click(918, 46) ; Move to Snipping Tool mode dropdown
    ; Sleep(100)
    ; Click() ; Open the dropdown

    ; Restore the original mouse position
    MouseMove(xOriginal, yOriginal, 0)

    ; ControlFocus('Type: 50003 (ComboBox) Name: "Snipping Area Dropdown Menu" LocalizedType: "combo box" AutomationId: "SnippingModeComboBox" ClassName: "ComboBox"')
    ; MsgBox('Hello from Admin Script')
    ; Send('{Tab}{Space}{Home}{Enter}+{Tab}')
    ; DetectHiddenText(true)
    ; DetectHiddenWindows(true)
    ; 201106
    ; 201100
    ; 329624
    ; 329492
    ; 197248
    ; MsgBox(JoinArray(WinGetList('Windows Input Experience')))
    ; MsgBox(JoinArray(WinGetList('ahk_class ApplicationFrameWindow')))
    ; MsgBox(JoinArray(WinGetList('ahk_class ApplicationFrameWindow ahk_exe explorer.exe')))
    ; WinGetPos(&x,&y,&w,&h,'ahk_id 201106')
    ; MsgBox('x: ' . x . ' y: ' . y . ' w: ' . w . ' h: ' . h)
    ; MsgBox(WinGetText('ahk_id 201106'))
    ; MsgBox(JoinArray(WinGetControlsHwnd('ahk_id 201100')))
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
