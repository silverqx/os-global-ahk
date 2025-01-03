; Silver Zachara <silver.zachara@gmail.com> 2018-2025

; I don't need to open Skylink Prima ZOOM so I extracted it to own file.
; I have refactored all code to ahk v2 but it was never tested (so unfinished).
; When I will have Skylink again then I can finish this.

#Requires AutoHotkey v2

Persistent()
#NoTrayIcon
#SingleInstance Force
#UseHook true

; Common functions
; ----------------

; Open Skylink Prima ZOOM
Splus(fullscreen := false)
{
    Run(A_ProgramFiles . ' (x86)\Google\Chrome\Application\chrome.exe https://livetv.skylink.cz/?qaction=wakeup --new-window',, 'Max')

    if (!fullscreen)
        return

    Sleep(15000)
    Send('f')
}

; Open the Skylink Prima ZOOM on wakeup from suspend
; --------------------------------------------------

; Listen to the Windows power event WM_POWERBROADCAST (ID: 0x218)
OnMessage(0x218, OnWmPowerBroadcast)

OnWmPowerBroadcast(wParam, lParam, *)
{
    ; The time when the PC got to sleep state, used by open Skylink
    static SuspendTime := ''
    ; Skylink open time, to avoid opening Skylink two times
    static OpenTime := ''

    WriteLogSkylink('begin; wParam = ' wParam '; lParam = ' lParam)

    ; https://learn.microsoft.com/en-us/windows/win32/power/wm-powerbroadcast
    ; https://www.autohotkey.com/board/topic/19984-running-commands-on-standby-hibernation-and-resume-events/
    ; Nothing to do, I'm only checking the resume and suspend states
    if (wParam != 4 && wParam != 7 && wParam != 18) {
        WriteLogSkylink('wParam != 4 && wParam != 7 && wParam != 18; return')
        return false
    }

    ; PBT_APMSUSPEND 0x0004
    ; Save a time when the PC got to the suspend state, used later for compare
    if (wParam = 4) {
        SuspendTime := A_Now
        WriteLogSkylink('wParam = 4; SuspendTime := ' SuspendTime '; return')
        return false
    }

    ; PBT_APMRESUMESUSPEND 0x0007 or PBT_APMRESUMEAUTOMATIC 0x0012 (18) section
    ; Prepare the 15 minutes later time and during the day variables
    later15Mins := SuspendTime
    later15Mins := DateAdd(later15Mins, 15, 'Minutes')
    isDuringDay := A_Hour >= 8 && A_Hour <= 22

    ; Open Skylink even during wake up between 08-22 hours, but it must sleep longer than 15 minutes,
    ; eg. when I come back from outside or whatever, but not at evening or midnight,
    ; because something can wake up PC and I don't want to open Skylink in these cases.
    if (!isDuringDay || (isDuringDay && A_Now < later15Mins)) {
    ; I'm waking PC at 08:14, so open Skylink only at this time
    ;if (A_Hour != 8 || A_Min not between 11 and 17)
        WriteLogSkylink('!isDuringDay || (isDuringDay && A_Now < later15Mins); isDuringDay := ' isDuringDay '; later15Mins := ' later15Mins '; return')
        return false
    }

    ; Prepare 5 second interval to avoid opening Skylink two times.
    ; Windows sends both 7 and 18 resume codes during resume WOL and timer resume, and
    ; it sends only 7 resume code if resumed using the keyboard.
    if (OpenTime != '') {
        ; Now happened that it last 1m35s between 18 and 7 resume codes,
        ; resume code 7 was fired 1m35s later after the 18 code,
        ; so I'm increasing this interval to 3min.
        openLaterInterval := OpenTime
        openLaterInterval := DateAdd(openLaterInterval, 3, 'Minutes')
        WriteLogSkylink('Checking openLaterInterval : ' A_Now ' < ' openLaterInterval)

        if (A_Now < openLaterInterval) {
            WriteLogSkylink('A_Now < openLaterInterval; return')
            return false
        }
    }
    else
        WriteLogSkylink("OpenTime = ''")

    WriteLogSkylink('openSkylink')

    OpenTime := A_Now

    Sleep(25000)
    Run(A_ProgramFiles . ' (x86)\TC UP\MEDIA\Programs\Poweroff\poweroffcz.exe monitor_on',, 'Hide')
    Sleep(10000)
    openSkylinkPrimaZoom()
    Sleep(60000)
    Send('f')

    return false
}

openSkylinkPrimaZoom()
{
    Splus(false)
}

; Write to the Open Skylink log file
WriteLogSkylink(text) {
    WriteLog(text, 'E:/tmp/openskylink.log')
}

; Write to the given log file
WriteLog(text, logFilepath) {
	FileAppend(A_NowUTC ': ' text '`n', logFilepath)
}
