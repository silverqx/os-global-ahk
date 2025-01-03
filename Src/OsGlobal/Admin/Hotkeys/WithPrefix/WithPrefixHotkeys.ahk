#Include WithoutModifier.ahk

; Leader key ctrl-¨ shortcuts
; ---------------------------

; The ¨ is next to Enter key, it's key with |\ characters
^¨::
{
    ih := InputHook('T.8 L1 M', '{Enter}.{Esc}{Tab}', 'c,e,p,r')
    ih.Start()
    result := ih.Wait()

    ; Send original shortcut on timeout
    if (result = 'Timeout')
        return Send('^¨')

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; Without modifiers
    if (userInput = 'e')
        Se() ; Environment Variables
}
