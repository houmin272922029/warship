--[[
    查看资料
    Author: Aaron Wei
	Date: 2015-09-09 14:22:04
]]

local ExamineService = qy.class("ExamineService", qy.tank.service.BaseService)

function ExamineService:show(id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.show",
        ["p"] = {["uid"] = id}
    })):send(function(response, request)
        qy.tank.model.ExamineModel:init(response.data)
        callback()
    end)
end

--跨服军神榜用，用来看ai的信息。。
function ExamineService:show_ai(uid, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.show",
        ["p"] = {["uid"] = uid, ["type"] = 200}
    })):send(function(response, request)
        qy.tank.model.ExamineModel:init(response.data)
        callback()
    end)
end
--跨服军团战用
function ExamineService:show_ai1(uid, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.show",
        ["p"] = {["uid"] = uid, ["type"] = 300}
    })):send(function(response, request)
        qy.tank.model.ExamineModel:init(response.data)
        callback()
    end)
end

return ExamineService