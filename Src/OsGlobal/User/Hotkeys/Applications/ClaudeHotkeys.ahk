#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Keyboard>

; Claude
; ------

; Callback for the HotIf function for Claude
ClaudeCodeBlockHotIf(*)
{
    return WinActive(WinTitleClaude)          ||
           WinActive(WinTitleClaudeChrome)    || WinActive(WinTitleClaudeEdge)    ||
           WinActive(WinTitleClaudePwaChrome) || WinActive(WinTitleClaudePwaEdge) ||
           WinActive(WinTitleClaudeFirefox)   || WinActive(WinTitleClaudePwaFirefox)
}

; Create hotkeys for generating code blocks (at runtime)
CreateAiTextareaHotkeys(ClaudeCodeBlockHotIf, AiType.Claude)

+§::Send('``')
