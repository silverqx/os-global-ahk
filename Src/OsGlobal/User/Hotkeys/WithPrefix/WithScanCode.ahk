#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Window>

; With the scan code (scXYZ)
; ----------------------
; Leader key ctrl-g related

; AutoHotkey v2 - documentation - ahk
Ss002()
{
    RunOrActivateIfExist(WinTitleAhk2DocsEdge,
        '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe" ' .
            '--profile-directory=Default --app-id=fcealjmigcjniemoeofdephofkblhdai ' .
            '--app-url=https://www.autohotkey.com/docs/v2/',
        'C:\Program Files (x86)\Microsoft\Edge\Application', 'Max')
}

; Adobe Photoshop 2022
Ss003()
{
    RunOrActivateIfExist('ahk_class Photoshop ahk_exe photoshop.exe',
        A_ProgramFiles . '\Adobe\Adobe Photoshop 2022\photoshop.exe',
        A_ProgramFiles . '\Adobe\Adobe Photoshop 2022', 'Max')
}
