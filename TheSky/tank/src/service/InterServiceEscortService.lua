--[[
    押运服务
    Author: Your Name
    Date: 2015-05-26 16:12:18
]]

local InterServiceEscortService = qy.class("InterServiceEscortService", qy.tank.service.BaseService)

local model = qy.tank.model.InterServiceEscortModel
function InterServiceEscortService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.get",
    })):send(function(response, request)
        model:init(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        -- qy.tank.command.AwardCommand:show(response.data.award)
        callback()
    end)
end

function InterServiceEscortService:getlist(param, callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.get",
        ["p"] = {
        	["page"] = param.page
    	}
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

function InterServiceEscortService:appoint(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.refreshGoods",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

function InterServiceEscortService:confirmAppoint(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.confirmAppoint",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

function InterServiceEscortService:getTeamList(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.getTeamList",
    })):send(function(response, request)
        model:setList(response.data)
        callback()
    end)
end

function InterServiceEscortService:getTeamList(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.getTeamList",
    })):send(function(response, request)
        model:setList(response.data)
        callback()
    end)
end

-- 加入
function InterServiceEscortService:joinTeam(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.joinTeam",
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
function InterServiceEscortService:leaveTeam(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.leaveTeam",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

-- 强制押运
function InterServiceEscortService:forceEscort(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.forceEscort",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

-- 掠夺
function InterServiceEscortService:plunder(id, callback)
    print(id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.plunder",
        ["p"] = {["escort_id"] = id}
    })):send(function(response, request)
        model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        -- qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end

-- 日志
function InterServiceEscortService:getLog(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "InterServiceEscort.getLog",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end

return InterServiceEscortService