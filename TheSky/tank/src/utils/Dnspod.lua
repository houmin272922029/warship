local Dnspod = class("Dnspod")

local socket = require("socket")
local platform = device.platform
local userDefault = cc.UserDefault:getInstance()

if platform == "ios" then
    Dnspod.luaoc = require "cocos.cocos2d.luaoc"
elseif platform == "android" then
    Dnspod.luaj = require "cocos.cocos2d.luaj"
    Dnspod.className = "com/qiyouhudong/tank/lib/Dnspod"
end

local id = 74
local key = "{AayTp2x"

function Dnspod:query(domain, callback)
    local starttime = socket.gettime()
    if platform == "android" then
        -- cache
        local cacheip = userDefault:getStringForKey("domain_" .. domain, "")
        if string.len(cacheip) > 0 then
            if qy.DEBUG then
                print("缓存IP:", cacheip)
            end
            callback(true, cacheip)
        else
            local function javacallback(ip)
                if qy.DEBUG then
                    print("查询IP用时:", socket.gettime() - starttime, ip)
                end
                if ip ~= domain then
                    userDefault:setStringForKey("domain_" .. domain, ip)
                end
                callback(true, ip)
            end
            local args = {domain, id, key, javacallback}
            local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
            local ok = self.luaj.callStaticMethod(self.className, "query", args, sigs)
            if not ok then
                callback(false)
            end
        end
    else
        local url = "http://119.29.29.29/d?ttl=1&dn=" .. domain
        if qy.DEBUG then
            print(url)
        end
        local ip = domain
        local xhr = cc.XMLHttpRequest:new()
        xhr.timeout = 5
        xhr:open("GET", url)
        xhr:registerScriptHandler(function()
            if xhr.status == 200 then
                local ret = string.split(xhr.response, ",")
                if ret and #ret == 2 then
                    callback(true, ret[1])
                else
                    callback(false)
                end
            else
                callback(false)
            end
            if qy.DEBUG then
                print("查询IP用时:", (socket.gettime() - starttime) .. "s", xhr.response)
            end
        end)
        xhr:send()
    end
end

return Dnspod
