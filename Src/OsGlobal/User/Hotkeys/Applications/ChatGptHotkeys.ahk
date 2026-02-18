#Include <OsGlobal\GlobalVariables>
#Include <OsGlobal\Keyboard>

; ChatGPT
; -------

; Callback for the HotIf function for ChatGPT
ChatGptCodeBlockHotIf(*)
{
    return WinActive(WinTitleChatGpt)        || WinActive(WinTitleChatGptEdge)      ||
           WinActive(WinTitleChatGptPwaEdge) || WinActive(WinTitleChatGptPwaChrome) ||
           WinActive(WinTitleChatGptFirefox) || WinActive(WinTitleChatGptPwaFirefox)
}

; Create hotkeys for generating code blocks (at runtime)
CreateAiTextareaHotkeys(ChatGptCodeBlockHotIf)

#HotIf ChatGptCodeBlockHotIf
^sc01a::Send('^k')
; Mitigate conflict (^k focuses the address bar in browsers)
^k::Send('^k')
#HotIf
