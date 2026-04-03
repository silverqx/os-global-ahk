#Include WithModifier.ahk
#Include WithoutModifier.ahk

; Leader key Ctrl-Alt-¨ or AltGr-¨ shortcuts
; ------------------------------------------

; The ¨ is next to Enter key, it's key with |\ characters
^!¨::
{
    ih := InputHook('T.8 L1 M', '{Enter}.{Esc}{Tab}', 'a,c,e,p,r')
    ih.Start()
    result := ih.Wait()

    ; Send original shortcut on timeout
    if (result = 'Timeout')
        return Send('^!¨')

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; With the ctrl modifier, has to be first
    ; Look appropriate Decimal (Dec column) number mappings at:
    ; https://en.wikipedia.org/wiki/ASCII#Control_code_table
    if (userInput == Chr(1))
        Sca() ; Suspend/Run all VMs (vms/r-all.ps1)

    ; Without modifiers
    else if (userInput = 'e')
        Se() ; Environment Variables
}
