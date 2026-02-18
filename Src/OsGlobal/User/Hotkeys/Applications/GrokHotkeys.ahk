#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Keyboard>

; Grok
; ----

; Callback for the HotIf function for Grok
GrokCodeBlockHotIf(*)
{
    return WinActive(WinTitleGrokFirefox) || WinActive(WinTitleGrokPwaFirefox)
}

; Create hotkeys for generating code blocks (at runtime)
CreateAiTextareaHotkeys(GrokCodeBlockHotIf, AiType.Grok)
