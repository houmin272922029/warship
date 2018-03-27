--[[
    客户端打点请求服务
    Author: H.X.Sun
    Date: 2015-08-28
]]

local ClientDotService = {}

local dkjson = require "utils.dkjson"
local userDefault = cc.UserDefault:getInstance()
local version = userDefault:getStringForKey("version", "1.0");
local ver = (function()
    if qy.product == "local" or qy.product == "develop" then
        return "develop"
    else
        local package_code = userDefault:getStringForKey("package_code", "0")
        return package_code
    end
end)()

local _data = {}
_data.m = "stat.click"
_data.p = {}
_data.p.platform = device.platform
_data.p.d = device.platform == "android" and 2 or 1
_data.p.mac = cc.UserDefault:getInstance():getStringForKey("uuid", "")
_data.p.idfa = require("utils.Analytics"):getIDFA()

local sUrl = string.format("%s://%s:%s/%s&ver=%s&client_ver=%s",
    qy.SERVER_SCHEME,
    qy.SERVER_DOMAIN,
    qy.SERVER_PORT,
    qy.SERVER_PATH,
    ver,
    version
)

function ClientDotService:onEvent(param)
    -- mac平台不统计
    if qy.product == "local" then
        return
    end

    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("POST", sUrl)

    _data.p.keywords = param

    xhr:send(dkjson.encode(_data))

    if qy.DEBUG then
        print(sUrl)
        print(dkjson.encode(_data))
    end
end

return ClientDotService
