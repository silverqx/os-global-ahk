; Global variables
; ----------------

; Pause/Unpause vmwrun.exe
VmrunPauseToggle := false

; With the ctrl modifier
; ----------------------
; Leader key ctrl-g related

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
