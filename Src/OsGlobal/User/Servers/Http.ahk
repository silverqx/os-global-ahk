; #Requires AutoHotkey v2

; Persistent()
; #NoTrayIcon
; #SingleInstance Force
; #UseHook true

#Include <ahk2_lib\HttpServer>
#Include <ahk2_lib\JSON>

#Include <OsGlobal\Error>
#Include <OsGlobal\Http\Headers>

; TODO revisit silverqx
#Include "%A_ScriptDir%\Config\Routes.ahk"

hs := HttpServer()
hs.Add('http://127.0.0.1:50790/', HttpHandler)

HttpHandler(request, response)
{
    try {
        ; Set CORS headers and handle OPTIONS requests
        if (HttpHeaders(request, response).PrepareResponse())
            return

        ; Dispatch the request to the appropriate route
        Router.DispatchRequest(request, response)
    }
    catch Error as e {
        response('', 500) ; Internal Server Error
        ShowException(e)
    }
}
