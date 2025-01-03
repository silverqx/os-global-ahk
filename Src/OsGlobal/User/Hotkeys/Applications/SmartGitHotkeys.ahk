#Include <OsGlobal\GlobalVariables>

; SmartGit
; --------

; Commits History button
#HotIf WinActive(WinTitleSmartGit)
^+h::
{
    SetControlDelay(-1)
    ControlClick('SWT_Window085', 'A',,,, 'NA')
}
#HotIf ; WinActive(WinTitleSmartGit)
