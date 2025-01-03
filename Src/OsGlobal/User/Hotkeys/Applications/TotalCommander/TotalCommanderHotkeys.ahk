#Include <OsGlobal\GlobalVariables>

#Include Core.ahk

; Total Commander
; ---------------

#HotIf WinActive(WinTitleTC)
^!t::{
    ; Maximize the currently focused panel
    static TCPanelListingToggle := false

    if (TCPanelListingToggle)
        TCRestorePanelListing()
    else
        TCMaximizePanelListing()

    TCPanelListingToggle := !TCPanelListingToggle
}
#HotIf ; WinActive(WinTitleTC)
