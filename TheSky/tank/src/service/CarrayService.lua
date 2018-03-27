--[[
    押运服务
    Author: Your Name
    Date: 2015-05-26 16:12:18
]]

local CarrayService = qy.class("CarrayService", qy.tank.service.BaseService)

local model = qy.tank.model.CarrayModel
function CarrayService:init(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.get",
    })):send(function(response, request)
        model:init(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        -- qy.tank.command.AwardCommand:show(response.data.award)
        callback()
    end)
end

function CarrayService:getlist(param, callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.getList",
        ["p"] = {
        	["page"] = param.page
    	}
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

function CarrayService:appoint(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.appoint",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

function CarrayService:confirmAppoint(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.confirmAppoint",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

function CarrayService:getTeamList(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.getTeamList",
    })):send(function(response, request)
        model:setList(response.data)
        callback()
    end)
end

function CarrayService:getTeamList(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.getTeamList",
    })):send(function(response, request)
        model:setList(response.data)
        callback()
    end)
end

-- 加入
function CarrayService:joinTeam(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.joinTeam",
        ["p"] = {
            ["pos_one"] = param.pos_one,
            ["pos_two"] = param.pos_two,
            ["pos_two_other_kid"] = param.pos_two_other_kid,
        }
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

-- 离开
function CarrayService:leaveTeam(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.leaveTeam",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

-- 强制押运
function CarrayService:forceEscort(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.forceEscort",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

-- 掠夺
function CarrayService:plunder(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.plunder",
        ["p"] = {
            ["escort_id"] = param.id
        }
    })):send(function(response, request)
        model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        -- qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end

-- 日志
function CarrayService:getLog(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionescort.getLog",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

return CarrayService