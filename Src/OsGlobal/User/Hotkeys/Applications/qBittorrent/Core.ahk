#Include <OsGlobal\GlobalVariables>

; qBittorrent core
; ----------------

; Assign to video category and force/ seed tag
QbtAssignVideoCategoryAndSeedTag(closeAction := 'SubMenu', assignForceSeed := false)
{
    ; Assign to video category
    Send('{AppsKey}y{Up}{Enter}')
    ; Assign seed tag
    Send('{AppsKey}g{Up 2}{Enter}')

    ; Assign force seed tag (for Trezzor Tracker)
    if (assignForceSeed)
        Send('{Down}{Enter}')

    ; Close Tags sub-menu or context menu
    switch closeAction {
        case 'SubMenu': Send('{Esc}')
        case 'AppMenu': Send('{Esc 2}')
    }
}

; Download in sequential order and first/last pieces first
QbtDownloadSequentialAndFirstLast()
{
    ; Download in sequential order
    Send('{Down 4}{Enter}')
    ; Download first and last pieces first
    Send('{AppsKey}g{Esc}{Down 5}{Enter}')
}

; Open Torrent options modal dialog and wait for it
QbtOpenTorrentOptionsModal()
{
    Send('{AppsKey}o')
    WinWait('^Torrent Options$ ' . WinTitleQBittorrent)
}

; Limit download speed to the given value
QbtSetDownloadSpeedLimit(value)
{
    ; Open Torrent options modal dialog and wait for it
    QbtOpenTorrentOptionsModal()
    Send(Format('{Tab 2}{:u}{Enter}', value))
}
