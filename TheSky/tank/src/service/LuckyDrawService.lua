--[[
    押运服务
    Author: Your Name
    Date: 2015-05-26 16:12:18
]]

local LuckyDrawService = qy.class("LuckyDrawService", qy.tank.service.BaseService)

local model = qy.tank.model.LuckyDrawModel
function LuckyDrawService:init(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "tiger_machine"}
    })):send(function(response, request)
        model:init(response.data)
        callback()
    end)
end

function LuckyDrawService:satrt(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getaward",
        ["p"] = {["activity_name"] = "tiger_machine",["step"] = 1}
    })):send(function(response, request)
        model:initawarddata(response.data)
        if response.data.award then
            qy.tank.command.AwardCommand:add(response.data.award)
        end
        callback(response.data)
    end)
end

function LuckyDrawService:getranklist(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getaward",
        ["p"] = {["activity_name"] = "tiger_machine",["step"] = 2}
    })):send(function(response, request)
        model:initRanklist(response.data)
        callback()
    end)
end

function LuckyDrawService:getaward( callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getaward",
        ["p"] = {["activity_name"] = "tiger_machine",["step"] = 3}
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback()
    end)
end



return LuckyDrawService