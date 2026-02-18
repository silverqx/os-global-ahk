#Include <OsGlobal\Routing\Route>

Route.Post('/send', HttpRoute_Send)

HttpRoute_Send(request, *)
{
    input := request.Content.Get('input', '')
    if (input = '')
        return 400 ; Bad Request

    Send(input)
    return 204 ; No Content
}
