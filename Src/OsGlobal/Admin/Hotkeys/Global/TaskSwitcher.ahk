; Restore the End shortcut during the #1-9 hotkey is active (stopped working ~KB5050094 (2025-01))
; TODO added support also for Home key silverqx
GoToEndInTaskSwitcher(keyName)
{
    cursorPosition := 0

    loop {
        Sleep(10)

        if (GetKeyState(keyName)) {
            GetKeyState('RShift') ? --cursorPosition : ++cursorPosition
            KeyWait(keyName) ; To avoid repeating
        }

        ; Nothing to do, LWin was unpressed
        if (!GetKeyState('LWin'))
            break
        ; Nothing to do, we are only waiting/processing the End key
        if (endKeyState := GetKeyState('End'), !endKeyState || cursorPosition = 0)
            if (endKeyState)
                KeyWait('End') ; To avoid repeating
            else
                continue

        isCursorPositionNegative := cursorPosition < 0
        Send(Format('{LWin Down}{:s}', isCursorPositionNegative ? '' : '{RShift Down}'))
        ; Turn negative numbers into positive if needed
        loop isCursorPositionNegative ? cursorPosition * -1 : cursorPosition {
            Send(Format('{{:s}}', keyName))
            Sleep(1) ; Needed as {x X} hotkey format doesn't work (no repeated key presses)
        }
        cursorPosition := 0 ; The end item (window) position
        KeyWait('End') ; To avoid key repeating
        if (!isCursorPositionNegative)
            Send('{RShift Up}')
    }
}

~<#+::GoToEndInTaskSwitcher('+')
~<#ě::GoToEndInTaskSwitcher('ě')
~<#š::GoToEndInTaskSwitcher('š')
~<#č::GoToEndInTaskSwitcher('č')
~<#ř::GoToEndInTaskSwitcher('ř')
~<#ž::GoToEndInTaskSwitcher('ž')
~<#ý::GoToEndInTaskSwitcher('ý')
~<#á::GoToEndInTaskSwitcher('á')
~<#í::GoToEndInTaskSwitcher('í')
~<#é::GoToEndInTaskSwitcher('é')
