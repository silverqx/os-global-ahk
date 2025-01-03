#Include WithModifier.ahk
#Include WithoutModifier.ahk

; Leader key ctrl-g shortcuts
; ---------------------------

^g::
{
    ih := InputHook('T.8 L1 M', '{Enter}.{Esc}{Tab}',
                    'a,b,c,č,d,é,f,g,k,l,m,n,p,q,r,ř,s,š,t,w,u,y,ž')
    ih.Start()
    result := ih.Wait()

    ; Send original shortcut on timeout
    if (result = 'Timeout')
        return Send('^g')

    ; TODO Ask on the forum how to do this in ahk v2 silverqx
    ; if (result = 'NewInput')
    ;     return
    ; Terminated by end key
    if (result == 'EndKey')
        return

    userInput := ih.Input

    ; With the ctrl modifier, has to be first
    ; Look appropriate number mappings at https://en.wikipedia.org/wiki/ASCII#Control_code_chart
    if (userInput == Chr(1))
        Sca() ; TinyActions vmware
    else if (userInput == Chr(2))
        Scb() ; Manjaro vmware
    else if (userInput == Chr(4))
        Scd() ; Arch Docker Server vmware
    else if (userInput == Chr(13))
        Scm() ; TamperMonkey
    else if (userInput == Chr(15))
        Sco() ; GitHub
    else if (userInput == Chr(16))
        Scp() ; pgAdmin
    else if (userInput == Chr(19))
        Scs() ; SumatraPDF
    else if (userInput == Chr(20))
        Sct() ; Sk-CzTorrent
    else if (userInput == Chr(22))
        Scv() ; Gentoo vmware
    else if (userInput == Chr(23))
        Scw() ; Windows vmware
    else if (userInput == Chr(25))
        Scy() ; Youtube with WinExist()

    ; Without modifiers
    else if (userInput = 'a')
        Sa() ; access
    else if (userInput = 'b')
        Sb() ; Google Sheets - bash_or_cmd_useful_commands
    else if (userInput = 'c')
        Sc() ; open new čsfd.cz page in chrome
    else if (userInput = 'č')
        Sč() ; čsfd.cz search in chrome
    else if (userInput = 'd')
        Sd() ; Dolby Access
    else if (userInput = 'é')
        Sé() ; List all registered hotkeys (w/o they descriptions 🥺)
    else if (userInput = 'ý')
        Sý() ; VMware Workstation
    else if (userInput = 'f')
        Sf() ; Facebook
    else if (userInput = 'g')
        Sg() ; Grammly
    else if (userInput = 'k')
        Sk() ; Skylink
    else if (userInput = 'l')
        Sl() ; SQLiteStudio
    else if (userInput = 'm')
        Sm() ; Messenger
    else if (userInput = 'n')
        Sn() ; Notepad++
    else if (userInput = 'p')
        Sp() ; PhpStorm
    else if (userInput = 'q')
        Sq() ; qMedia
    else if (userInput = 'r')
        Sr() ; Registry Editor
    else if (userInput = 'ř')
        Sř() ; Google Sheets - Seriály
    else if (userInput = 's')
        Ss() ; qBittorrent
    else if (userInput = 'š')
        Sš() ; Google Sheets
    else if (userInput = 't')
        St() ; Microsoft To Do
    else if (userInput = 'u')
        Su() ; Control Panel - Sound Playback devices
    else if (userInput = 'v')
        Sv() ; Settings - Volume Mixer
    else if (userInput = 'w')
        Sw() ; WinMerge
    else if (userInput = 'y')
        Sy() ; Youtube w/o WinExist()
    else if (userInput = 'ž')
        Sž() ; Google Drive
}
