--[[
    说明：请求库，支持co.lua
    作者：林国锋
]]

local Requests = {}

function Requests.request(method, url, params)
    return function(next)
        local xhr = cc.XMLHttpRequest:new()
        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
        xhr:open(method, url)
        xhr:registerScriptHandler(function()
            next(xhr.status, xhr.response)
        end)
        if method == "POST" then
            xhr:send(qy.json.encode(params))
        else
            xhr:send()
        end
    end
end

function Requests.post(url, params)
    return Requests.request("POST", url, params)
end

function Requests.get(url)
    return Requests.request("GET", url)
end

return Requests
