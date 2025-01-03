#Include Core.ahk

; Tiviko TV Program
; -----------------

#HotIf WinActive('^TV Program Tiviko$ ahk_class ApplicationFrameWindow')
^\::TivikoIncreaseZoomWithRestore()

; Zoom in the Grid page on double right mouse button click (anywhere)
~RButton::
{
    if (ThisHotkey == A_PriorHotkey && A_TimeSincePriorHotkey < 300)
        TivikoReloadGrid()
}

; Zoom in the Grid page on double right mouse button click (anywhere)
~MButton::
{
    if (ThisHotkey == A_PriorHotkey && A_TimeSincePriorHotkey < 300)
        TivikoIncreaseZoomWithRestore()
}

~LButton::TivikoIncreaseZoomOnGridClick()
#HotIf ; WinActive('^TV Program Tiviko$ ahk_class ApplicationFrameWindow')

; Open Tiviko TV Program
~MButton & XButton1::
{
    if (WinExist('^TV Program Tiviko$'))
        WinActivate()
    else
        Run('shell:AppsFolder\0BB81222.TVProgramTiviko_hev1qd965vk4r!App')
}
