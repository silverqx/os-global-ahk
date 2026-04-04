#Include WithModifier.ahk
#Include WithoutModifier.ahk
#Include WithScanCode.ahk

; Free to use
; -----------
;
; Without modifiers
; e,h,i,j,m,o,x
;
; With ctrl modifier
; c,d,e,f,g,i,j,k,l,n,o,u,x,z

; Leader key Ctrl-g shortcuts
; ---------------------------

^g::
{
    ; Function to map a key's virtual keycode to its scan code (vkXX to scXXX)
    GetScanCode(char) {
        vk := DllCall('VkKeyScan', 'Char', Ord(char), 'Int') & 0xFF ; Get Virtual Key from the character
        scanCode := DllCall('MapVirtualKey', 'UInt', vk, 'UInt', 0, 'UInt')

        return Format('sc{:03X}', scanCode) ; Format as scXXX
    }

    ih := InputHook('T.8 L1 M', '{Enter}.{Esc}{Tab}',
                    '{sc002},a,b,c,č,d,é,f,g,k,l,m,n,p,q,r,ř,s,š,t,w,u,y,ž')
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

    ; Example usage
    scanCode := GetScanCode(userInput)

    ; With the scan code (scXYZ) - Leader key Ctrl-g related
    ; Run any .ahk script (eg. TestingHotkeys.ahk), double-click tray icon (or right-click it
    ; and Open), then View - Key history and script info (Ctrl-K).
    ; AutoHotkey v2 - documentation - ahk
    if (scanCode == 'sc002')
        Ss002()
    ; Adobe Photoshop 2022
    else if (scanCode == 'sc003')
        Ss003()

    ; With the ctrl modifier, has to be first
    ; Look appropriate Decimal (Dec column) number mappings at:
    ; https://en.wikipedia.org/wiki/ASCII#Control_code_table
    else if (userInput == Chr(1))
        Sca() ; TinyActions vmware (merydeye-tinyactions)
    else if (userInput == Chr(2))
        Scb() ; Manjaro vmware (merydeye-build)
    ; else if (userInput == Chr(4))
    ;     Scd()
    else if (userInput == Chr(8))
        Sch() ; GitHub
    else if (userInput == Chr(13))
        Scm() ; TamperMonkey
    else if (userInput == Chr(16))
        Scp() ; pgAdmin
    else if (userInput == Chr(18))
        Scr() ; regex101
    else if (userInput == Chr(19))
        Scs() ; Arch Docker Server vmware (merydeye-server)
    else if (userInput == Chr(20))
        Sct() ; Sk-CzTorrent
    else if (userInput == Chr(22))
        Scv() ; Gentoo vmware (merydeye-gentoo)
    else if (userInput == Chr(23))
        Scw() ; Windows vmware (merydeye-win11-v)
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
    ; else if (userInput = 'é')
    ;     Sé() ; List all registered hotkeys (w/o they descriptions 🥺)
    else if (userInput = 'f')
        Sf() ; Facebook
    else if (userInput = 'g')
        Sg() ; Grammly
    else if (userInput = 'k')
        Sk() ; Skylink
    else if (userInput = 'l')
        Sl() ; SQLiteStudio
    ; else if (userInput = 'm')
    ;     Sm() ; Messenger
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
        Ss() ; SumatraPDF
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
    else if (userInput = 'ý')
        Sý() ; VMware Workstation
    else if (userInput = 'ž')
        Sž() ; Google Drive
}
