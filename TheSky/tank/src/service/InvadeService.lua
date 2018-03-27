--[[
    伞兵入侵  服务
]]

local InvadeService = qy.class("InvadeService", qy.tank.service.BaseService)

InvadeService.model = qy.tank.model.InvadeModel

--主接口
function InvadeService:main(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Invade.main",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init()
        self.model:update(response.data)
        callback(response.data)
    end)
end

-- fight接口
function InvadeService:fight(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Invade.fight",
        ["p"] = param
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        self.model:update(response.data)
        callback(response.data)
    end)
end

function InvadeService:getAward(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Invade.getAward",
        ["p"] = {}
    })):send(function(response, request)
        callback(response.data)
    end)
end



return InvadeService