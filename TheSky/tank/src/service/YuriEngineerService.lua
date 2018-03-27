--[[
	
	Author: 
]]

local YuriEngineerService = qy.class("YuriEngineerService", qy.tank.service.BaseService)

local model = qy.tank.model.YuriEngineerModel
-- 获取
function YuriEngineerService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "yuri_engineer"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


function YuriEngineerService:startGame(callback, best)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "yuri_engineer", ["op"] = "p", ["best"] = best}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



function YuriEngineerService:endGame(callback, level, double)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "yuri_engineer", ["op"] = "o", ["level"] = level, ["double"] = double }
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



function YuriEngineerService:getRank(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "yuri_engineer", ["op"] = "r"}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


function YuriEngineerService:share(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "yuri_engineer", ["op"] = "f"}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end

return YuriEngineerService



