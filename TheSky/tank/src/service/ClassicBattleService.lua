--[[
	经典战役服务
	Author: Aaron Wei
	Date: 2015-04-29 11:25:42
]]

local ClassicBattleService = qy.class("ClassicBattleService", qy.tank.service.BaseService)

ClassicBattleService.model = qy.tank.model.ClassicBattleModel
ClassicBattleService.battleModel = qy.tank.model.BattleModel

-- 获取经典战役列表
function ClassicBattleService:getlist(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "classicbattle.getlist",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init(response.data)
        callback()
    end)
end

function ClassicBattleService:startfight(id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "classicbattle.startfight",
        ["p"] = {["fuben_id"]=id}
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        self.battleModel:init(response.data.fight_result)
        self.battleModel.classic_id = id
        self.model:battleResult(response.data)
        callback()
    end)
end

function ClassicBattleService:getrewards(times,id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "classicbattle.getrewards",
        ["p"] = {["times"]=times,["fuben_id"]=id}
    })):send(function(response, request)
        self.model:update(response.data)
        if type(callback) == "function" then
            callback(response.data)
        end
    end)
end

-- 手动刷新
function ClassicBattleService:manualrefresh(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "classicbattle.manualrefresh",
        ["p"] = {}
    })):send(function(response, request)
        self.model:update(response.data)
        callback(response.data)
    end)
end

return ClassicBattleService




