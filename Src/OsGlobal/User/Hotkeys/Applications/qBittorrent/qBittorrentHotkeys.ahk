#Include Core.ahk

; Classic video
#HotIf WinActive(WinTitleQBittorrentExe)
QbtAssignCategoryAndDeqDownload()
{
    ; Assign to video category and seed tag
    QbtAssignVideoCategoryAndSeedTag()
    ; Download in sequential order and first/last pieces first
    QbtDownloadSequentialAndFirstLast()
}

^BackSpace::QbtAssignCategoryAndDeqDownload()
~LButton & RButton::QbtAssignCategoryAndDeqDownload()

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
*~MButton::Send('{AppsKey}v')
F3::Send('{AppsKey}v')
; Open Options
^!+s::Send('!o')

; Limit download rate shortcuts
^sc029::QbtSetDownloadSpeedLimit(0)
^sc002::QbtSetDownloadSpeedLimit(1024)
^sc003::QbtSetDownloadSpeedLimit(2048)
^sc004::QbtSetDownloadSpeedLimit(3072)
^sc005::QbtSetDownloadSpeedLimit(4096)
^sc006::QbtSetDownloadSpeedLimit(5120)
^sc007::QbtSetDownloadSpeedLimit(6144)
^sc008::QbtSetDownloadSpeedLimit(7168)
^sc009::QbtSetDownloadSpeedLimit(8192)
^sc00a::QbtSetDownloadSpeedLimit(9216)
^sc00b::QbtSetDownloadSpeedLimit(10240)
#HotIf ; WinTitleQBittorrentExe
