#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Keyboard>

; Gemini
; ------

; Callback for the HotIf function for Gemini
GeminiCodeBlockHotIf(*)
{
    return WinActive(WinTitleGeminiChrome)  || WinActive(WinTitleGeminiEdge)      ||
           WinActive(WinTitleGeminiPwaEdge) || WinActive(WinTitleGeminiPwaChrome) ||
           WinActive(WinTitleGeminiFirefox) || WinActive(WinTitleGeminiPwaFirefox)
}

; Create hotkeys for generating code blocks (at runtime)
CreateAiTextareaHotkeys(GeminiCodeBlockHotIf)
