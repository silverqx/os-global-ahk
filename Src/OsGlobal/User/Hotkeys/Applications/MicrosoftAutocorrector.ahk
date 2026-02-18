#Include <OsGlobal\GlobalVariables>

; Select auto-correction at the given position (1-based)
SelectAutoCorrection(autoCorrectionPosition)
{
    Send('{Up}')

    if (autoCorrectionPosition > 0) {
        Sleep(1)
        Send(Format('{Right {:u}}', autoCorrectionPosition - 1))
    }

    ; SetKeyDelay() doesn't work here, it sends {Enter} very often
    Sleep(1) ; 1ms is enough, it works always
    Send('{Space}') ; Don't use {Enter} here to avoid posting forms
}

; Select auto-correction based on the Tab keypress duration
PickAutoCorrection()
{
    static HoldDuration := 300   ; 1. vs 2. auto-correction
    static TabTimeout   := 'T.5' ; 3. auto-correction

    static WasTimeout := false

    ; Compute how long the Tab key was held down
    start := A_TickCount
    result := KeyWait('Tab', TabTimeout)
    duration := A_TickCount - start

    ; Nothing to do, don't select 3. auto-correction until the Tab key is released
    if (WasTimeout && GetKeyState('Tab', 'P'))
        return

    ; Select 3. auto-correction after the timeout
    if (!result) {
        WasTimeout := true
        SelectAutoCorrection(3)
        return
    }

    ; Nothing to do, to avoid selecting 1. auto-correction after a timeout
    if (WasTimeout) {
        WasTimeout := false
        return
    }

    ; Select 1. auto-correction
    if (duration < HoldDuration)
        SelectAutoCorrection(1)

    ; Select 2. auto-correction
    else
        SelectAutoCorrection(2)
}

; Autocorrector - Microsoft Windows 🥰🔥🌸
#HotIf WinActive(WinTitleCopilot)            ||
       WinActive(WinTitleChatGpt)            ||
       WinActive(WinTitleChatGptAppEdge)     ||
       WinActive(WinTitleChatGptFirefox)     || WinActive(WinTitleChatGptPwaFirefox) ||
       WinActive(WinTitleChatGptPwaChrome)   || WinActive(WinTitleChatGptPwaEdge)    ||
       WinActive(WinTitleChatGptChrome)      || WinActive(WinTitleChatGptEdge)       ||
       WinActive(WinTitleClaude)             || WinActive(WinTitleClaudePwaFirefox)  ||
       WinActive(WinTitleClaudePwaChrome)    || WinActive(WinTitleClaudePwaEdge)     ||
       WinActive(WinTitleClaudeChrome)       || WinActive(WinTitleClaudeEdge)        ||
       WinActive(WinTitleClaudeFirefox)      ||
       WinActive(WinTitleGeminiPwaChrome)    || WinActive(WinTitleGeminiPwaEdge)     ||
       WinActive(WinTitleGeminiPwaFirefox)   ||
       WinActive(WinTitleGeminiChrome)       || WinActive(WinTitleGeminiEdge)        ||
       WinActive(WinTitleGeminiFirefox)      ||
       WinActive(WinTitleGrokFirefox)        || WinActive(WinTitleGrokPwaFirefox)    ||
       WinActive(WinTitleNomiChrome)         || WinActive(WinTitleNomiEdge)          ||
       WinActive(WinTitleReplikaChrome)      || WinActive(WinTitleReplikaEdge)       ||
       WinActive(WinTitleKindroidChrome)     || WinActive(WinTitleKindroidEdge)      ||
       WinActive(WinTitleDiscordMain)        ||
       WinActive(WinTitleOpenWebUIPwaChrome) ||
       WinActive(WinTitleXChrome)            || WinActive(WinTitleXPwaChrome)
; Select 1., 2., or 3. auto-correction based on the Tab keypress duration
Tab::PickAutoCorrection()

; Select the 3. auto-correction
; ^Tab::SelectAutoCorrection(3)
#HotIf

<^>!Tab::PickAutoCorrection()

; Select auto-correction based on the Tab keypress duration (old implementation)
; Tab::
; {
;     static tabTimeout := 400
;     static wasDouble := false

;     if (A_PriorHotkey == 'Tab' && A_TimeSincePriorHotkey <= tabTimeout)
;     {
;         Send("{Up}")
;         Sleep(1)
;         Send("{Right 2}")
;         Sleep(1)
;         Send("{Enter}")

;         return
;     }

;     KeyWait('Tab')
;     wasDouble := false

;     ; Postpone the long press detection branch
;     SetTimer(TabLongPress, tabTimeout * -1) ; Single-shot timer

;     TabLongPress()
;     {
;         ; Nothing to do, double-press was already handled/detected
;         if (wasDouble)
;             return

;         ; Compute how long the Tab key was held down
;         start := A_TickCount
;         KeyWait('Tab')
;         duration := A_TickCount - start

;         if (duration < 300) {
;             Send("{Up}")
;             Sleep(1)
;             Send("{Enter}")
;         }
;         else {
;             Send("{Up}")
;             Sleep(1)
;             Send("{Right}")
;             Sleep(1)
;             Send("{Enter}")
;         }

;         ; Reset the state
;         wasDouble := false
;     }
; }
