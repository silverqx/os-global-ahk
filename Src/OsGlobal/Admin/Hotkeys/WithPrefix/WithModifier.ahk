#Include <OsGlobal\Globals\Paths>

; With the ctrl modifier
; ----------------------
; Leader key Ctrl-g related

; Suspend/Run all VMs (vms/r-all.ps1)
Sca()
{
    ih := InputHook('T.9 L1 M', '{Enter}.{Esc}{Tab}', 'r,s')
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
    ; Suspend
    if (userInput = 'r') {
        MsgBox('Running all VMs', 'All VMs - vmr-all.ps1', 'T1')
        Run(PwshHiddenFile . 'E:\dotfiles\bin\vmr-all.ps1',, 'Hide')
    }
    ; Run
    else if (userInput = 's') {
        MsgBox('Suspending all running VMs', 'All VMs - vms-all.ps1', 'T1')
        Run(PwshHiddenFile . 'E:\dotfiles\bin\vms-all.ps1',, 'Hide')
    }
}
