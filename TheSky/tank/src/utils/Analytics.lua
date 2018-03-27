local Analytics = class("Analytics")

local json = require("utils.dkjson")
local platform = device.platform

if platform == "ios" then
    Analytics.luaoc = require "cocos.cocos2d.luaoc"
elseif platform == "android" then
    Analytics.luaj = require "cocos.cocos2d.luaj"
    Analytics.className = "com/qiyouhudong/tank/lib/AnalyticsLua"
end

local _onPay = {cosh = 0, coin = 0}
local _onCrash = {message = ""}
local _onLevelTable = {name = "", status = ""}
local _doAction = {action = ""}
local _params = {}

function Analytics:doAction(action, args)
    _doAction.action = action
    _doAction.params = args
    local jsonStr = json.encode(_doAction)

    if qy.DEBUG then
        print("doAction", jsonStr)
    end

    if platform == "android" then
        _params[1] = jsonStr
        self.luaj.callStaticMethod(self.className, "doAction", _params, "(Ljava/lang/String;)V")
    elseif platform == "ios" then
        if  action == "onCrash" then
            self.luaoc.callStaticMethod("AppController", action, args)
        elseif action == "setInfo" then
            self.luaoc.callStaticMethod("Analytics", action, args)
        end
    end
end

function Analytics:setInfo(infos)
    self:doAction("setInfo", infos)
end

-- event_params: 事件参数，必须要有一个name属性
-- Analytics:onEvent({name = "xxx", xxx = "xxx"})
function Analytics:onEvent(event_params)
    if event_params.name == nil then
        error(qy.TextUtil:substitute(70001))
    end

    self:doAction("onEvent", event_params)
end

-- name: 关卡id
-- status: 关卡挑战状态, 0为挑战失败，1为挑战成功
-- 一个关卡在开始时会调用一次，结束时也会调用一次
-- Analytics:onLevel("levelidxxxx", 1)
-- Analytics:onLevel("levelidxxxx", 2)
function Analytics:onLevel(name, status)
    _onLevelTable.name = name
    _onLevelTable.status = status
    self:doAction("onLevel", _onLevelTable)
end

function Analytics:onCrash(message)
    _onCrash.message = message
    self:doAction("onCrash", _onCrash)
end

function Analytics:onPay(cosh, coin)
    _onPay.cosh = tonumber(cosh)
    _onPay.coin = tonumber(coin)
    self:doAction("onPay", _onPay)
end

function Analytics:getIDFA()
    if platform == "ios" then
        ok, ret = self.luaoc.callStaticMethod("SDK", "IDFA")
    else
        return
    end
    return ret
end

return Analytics
