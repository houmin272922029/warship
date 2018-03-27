local WebSocket = class("WebSocket")

WebSocket.EVENT_OPEN    = "WEBSOCKET_EVENT_OPEN"
WebSocket.EVENT_MESSAGE = "WEBSOCKET_EVENT_MESSAGE"
WebSocket.EVENT_CLOSE   = "WEBSOCKET_EVENT_CLOSE"
WebSocket.EVENT_ERROR   = "WEBSOCKET_EVENT_ERROR"

local Timer = qy.tank.utils.Timer
local _host, _port = nil, nil
local _not_reconnect = false  -- 换服务器不要重新连接
local ws = nil

-- 重连定时
local _reconnect_timer = nil
-- 重连间隔时间s
local _reconnect_delay = 10

-- 打开回调
function WebSocket.wsOpen(strData)
    if qy.DEBUG then
        print("wsOpen")
    end
    qy.Event.dispatch(WebSocket.EVENT_OPEN)

    if _reconnect_timer then
        _reconnect_timer:stop()
        _reconnect_timer = nil
    end

    _not_reconnect = false
end

-- 消息回调
function WebSocket.wsMessage(strData)
    if qy.DEBUG then
        local response = qy.json.decode(strData)
        print("wsMessage", qy.json.encode(response))
    end
    qy.Event.dispatch(WebSocket.EVENT_MESSAGE, strData)
end

-- 服务器关闭回调
function WebSocket.wsClose()
    if qy.DEBUG then
        print("wsClose")
    end
    qy.Event.dispatch(WebSocket.EVENT_CLOSE)

    if not _not_reconnect then
        ws = nil
        WebSocket:reconnect()
    end
end

-- 错误回调
function WebSocket.wsError(error)
    if qy.DEBUG then
        print("wsError", error)
    end
    qy.Event.dispatch(WebSocket.EVENT_ERROR)
    ws = nil
    WebSocket:reconnect()
end

-- 链接
function WebSocket:connect(host, port)
    if host and port then
        _host = host
        _port = port
    end
    ws = cc.WebSocket:create("ws://" .. _host .. ":" .. _port)
    ws:registerScriptHandler(self.wsOpen,      cc.WEBSOCKET_OPEN)
    ws:registerScriptHandler(self.wsMessage,   cc.WEBSOCKET_MESSAGE)
    ws:registerScriptHandler(self.wsClose,     cc.WEBSOCKET_CLOSE)
    ws:registerScriptHandler(self.wsError,     cc.WEBSOCKET_ERROR)
end

-- 换服务器后需要断开重新连接
function WebSocket:close()
    if ws then
        _not_reconnect = true
        ws:close()
        ws = nil
    end
end

-- 发送信息
function WebSocket:send(params)
    if qy.DEBUG then
        print("params:", qy.json.encode(params))
    end
    if ws then
        ws:sendString(qy.json.encode(params))
    end
end

-- 重新链接
function WebSocket:reconnect()
    if _reconnect_timer == nil then
        _reconnect_timer = Timer.new(_reconnect_delay, 0, function()
            print("reconnect...")
            self:connect()
        end)
        _reconnect_timer:start()
    end
end

return WebSocket
