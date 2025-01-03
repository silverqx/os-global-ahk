#Include Core.ahk

; Classic video
#HotIf WinActive(WinTitleQBittorrent)
^BackSpace::
{
    ; Assign to video category and seed tag
    QbtAssignVideoCategoryAndSeedTag()
    ; Download in sequential order and first/last pieces first
    QbtDownloadSequentialAndFirstLast()
}

; No-limit video (for Trezzor Tracker)
^+BackSpace::
{
    ; Force resume
    Send('{AppsKey}t')
    ; Assign to video category and force/ seed tag
    QbtAssignVideoCategoryAndSeedTag('SubMenu', true)
    ; Download in sequential order and first/last pieces first
    QbtDownloadSequentialAndFirstLast()

    ; Open Torrent options modal and wait for it
    QbtOpenTorrentOptionsModal()
    ; Set no share limit
    Send('+{Tab 9}{Down}{Enter}')
    ; Close Torrent options modal
    Send('{Enter}')
}

; Assign to video category and seed tag
^F12::QbtAssignVideoCategoryAndSeedTag('AppMenu')
; Assign to video category and force/ seed tag (for Trezzor Tracker)
^+F12::QbtAssignVideoCategoryAndSeedTag('AppMenu', true)

; Preview
F3::Send('{AppsKey}v')
; Open Options
^!+s::Send('!o')

; Limit download rate shortcuts
^;::QbtSetDownloadSpeedLimit(0)
^+::QbtSetDownloadSpeedLimit(1024)
^ě::QbtSetDownloadSpeedLimit(2048)
^š::QbtSetDownloadSpeedLimit(3072)
^č::QbtSetDownloadSpeedLimit(4096)
^ř::QbtSetDownloadSpeedLimit(5120)
^ž::QbtSetDownloadSpeedLimit(6144)
^ý::QbtSetDownloadSpeedLimit(7168)
^á::QbtSetDownloadSpeedLimit(8192)
^í::QbtSetDownloadSpeedLimit(9216)
^é::QbtSetDownloadSpeedLimit(10240)
#HotIf ; WinActive(WinTitleQBittorrent)
