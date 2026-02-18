#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Keyboard>

; Copilot
; -------

; Create hotkeys for generating code blocks (at runtime)
CreateAiTextareaHotkeys((*) => WinActive(WinTitleCopilot) || WinActive(WinTitleCopilotPwaEdge))
