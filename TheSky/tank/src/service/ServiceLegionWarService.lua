--[[
    战斗数据服务
    Author: Aaron Wei
    Date: 2015-02-03 16:33:24
]]

local ServiceLegionWarService = qy.class("ServiceLegionWarService", qy.tank.service.BaseService)

ServiceLegionWarService.model = qy.tank.model.ServiceLegionWarModel

function ServiceLegionWarService:init(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.get",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init(response.data)
        callback(response.data)
    end)
end

function ServiceLegionWarService:enter(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.enter",
        ["p"] = {}
    }))
    -- :setShowLoading(true)
    :send(function(response, request)
   		self.model:update(response.data)
   		callback()
   	end)
end

function ServiceLegionWarService:getDefenceByid(id,callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.getGarrisonList",
        ["p"] = {["site"] = id}
    }))
    -- :setShowLoading(true)
    :send(function(response, request)
    	self.model:initDefencedate(response.data)
    	callback()
    end)
end
function ServiceLegionWarService:getDefencelist(id,Pos,callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.getMemberList",
        ["p"] = {["site"] = id,["pos"] = Pos}
    }))
    -- :setShowLoading(true)
    :send(function(response, request)
    	-- self.model:initDefencedate(response.data)
    	callback(response.data)
    end)
end
function ServiceLegionWarService:Defence(id,Pos,Kid,callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.garrison",
        ["p"] = {["site"] = id,["pos"] = Pos,["garrison_kid"] = Kid}
    }))
    -- :setShowLoading(true)
    :send(function(response, request)
    	self.model:initDefencedate(response.data)
    	callback()
    end)
end 
function ServiceLegionWarService:getReport(types,page1,callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.getReport",
        ["p"] = {["type"] = types,["page"] = page1}
    }))
    -- :setShowLoading(true)
    :send(function(response, request)
    	-- self.model:initDefencedate(response.data)
    	callback(response.data)
    end)
end 
function ServiceLegionWarService:getRank(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.getRank",
        ["p"] = {}
    }))
    :send(function(response, request)
    	self.model:initRankdate(response.data)
    	callback()
    end)
end
function ServiceLegionWarService:drawAward1(types,callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.drawAward",
        ["p"] = {["type"]= types}
    }))
    :send(function(response, request)
    	self.model:updateaward(response.data)
    	qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
    	callback()
    end)
end
function ServiceLegionWarService:drawAward2(types,ids,callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.drawAward",
        ["p"] = {["type"]= types,["id"] = ids}
    }))
    :send(function(response, request)
    	self.model:updateaward(response.data)
    	qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
    	callback()
    end)
end
function ServiceLegionWarService:enterfight(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.getAttackLegionList",
        ["p"] = {}
    }))
    :send(function(response, request)
    	self.model:initAttlist(response.data)
    	callback(response.data)
    end)
end
function ServiceLegionWarService:firepos( site,callback )
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.fire",
        ["p"] = {["legion_pos"] = site}
    }))
    :send(function(response, request)
    	-- self.model:initAttlist(response.data)
    	callback(response.data)
    end)
end
function ServiceLegionWarService:GetAttackSitelist( legion_pos,callback )
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.getAttackSiteList",
        ["p"] = {["legion_pos"] = legion_pos}
    }))
    :send(function(response, request)
    	self.model:initAttSitelist(response.data)
    	callback(response.data)
    end)
end
function ServiceLegionWarService:Buy( callback )
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.buy",
        ["p"] = {}
    }))
    :send(function(response, request)
    	self.model:updateziyuan(response.data)
    	callback(response.data)
    end)
end
function ServiceLegionWarService:GetAttackBypos(legion_pos,site, callback )
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.getAttackList",
        ["p"] = {["legion_pos"]= legion_pos,["site"] = site}
    }))
    :send(function(response, request)
    	self.model:initAttackSitelist(response.data)
    	callback(response.data)
    end)
end
function ServiceLegionWarService:Attack( legion_pos,site,Pos,callback )
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicelegionbattle.attack",
        ["p"] = {["legion_pos"]= legion_pos,["site"] = site,["pos"] = Pos}
    }))
    :send(function(response, request)
    	qy.tank.model.BattleModel:init(response.data.fight_result)
        qy.tank.manager.ScenesManager:pushBattleScene()
    	self.model:initAttackSitelist1(response.data)
    	callback(response.data)
    end)
end
return ServiceLegionWarService
