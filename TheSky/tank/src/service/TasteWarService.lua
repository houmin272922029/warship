--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local TasteWarService = qy.class("TasteWarService", qy.tank.service.BaseService)

local model = qy.tank.model.TasteWarModel
-- 获取
function TasteWarService:main(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "ZongziFight.index",
        ["p"] = {}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function TasteWarService:jointeam(team,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "ZongziFight.join_team",
       ["p"] = {["team"] = team}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end

function TasteWarService:Buytime(nums,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "ZongziFight.buy_attack_times",
       ["p"] = {["times"] = nums}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end

function TasteWarService:attack(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "ZongziFight.attack",
       ["p"] = {}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end

function TasteWarService:exchange(id,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "ZongziFight.buy",
       ["p"] = {["id"] = id}
    })):send(function(response, request)
        model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end




return TasteWarService



