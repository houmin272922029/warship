--[[--
--矿区service
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local MineService = qy.class("MineService", qy.tank.service.BaseService)

MineService.model = qy.tank.model.MineModel

--[[--
--获取用户自己的矿区信息
--]]
function MineService:getMineInfo(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "mining.myMining",
		["p"] = {}
	})):send(function(response, request)
		self.model:initUserMine(response.data)
		callback(response.data)
	end)
end

--[[--
--获取掠夺列表
--]]
function MineService:getPlunderList(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "mining.myPlunder",
		["p"] = {}
	})):send(function(response, request)
		self.model:initPlunderInfo(response.data)
		callback(response.data)
	end)
end

--[[--
--刷新普通矿
--]]
function MineService:refresh(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "mining.refresh",
		["p"] = {}
	})):send(function(response, request)
		self.model:refreshPlunderInfo(response.data)
		callback(response.data)
	end,function ()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE)
    end)
end

--[[--
--刷新稀有矿
--]]
-- function MineService:refreshRareMine(callback)
-- 	qy.Http.new(qy.Http.Request.new({
-- 		["m"] = "mining.refresh",
-- 		["p"] = {}
-- 	})):send(function(response, request)
-- 		self.model:refreshPlunderInfo(response.data)
-- 		callback(response.data)
-- 	end)
-- end

--[[--
--收获
--]]
function MineService:harvest(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "mining.harvest",
		["p"] = {}
	})):send(function(response, request)
		self.model:harvestSuccess(response.data)
		local award = {{["type"] = 3, ["num"] = response.data.outSilverNum}}
		qy.tank.command.AwardCommand:show(award)
		callback(response.data)
	end)
end

--[[--
--收获稀有矿
--]]
function MineService:harvestRareMine(mineId, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "RareMineral.harvest",
		["p"] = {id = mineId}
	})):send(function(response, request)
		self.model:harvestRareMine(response.data, mineId)
		if response.data.list and response.data.list.list then
			--收取上一个等级段的稀有矿，应刷新到当前等级段
			self.model:initRareMineInfo(response.data.list)
			-- qy.tank.view.mine.RareMineView:refreshPage()
		end
		callback(response.data)
	end)
end

--[[--
--升级生产力
--]]
function MineService:upgradeProduct(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "mining.upProduct",
		["p"] = {}
	})):send(function(response, request)
		self.model:updateMineProductInfo(response.data)
		callback(response.data)
	end)
end

--[[--
--升级掠夺力
--]]
function MineService:upgradePlunder(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "mining.upPlunder",
		["p"] = {}
	})):send(function(response, request)
		self.model:updateUserPlunderInfo(response.data)
		callback(response.data)
	end)
end

--[[--
--掠夺普通矿
--]]
function MineService:plunder(entity, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "mining.plunder",
		["p"] = {plunderid = entity.owner.id, type = entity.owner.type}
	}))
	-- :setShowLoading(false)
	:send(function(response, request)
		qy.tank.model.BattleModel:init(response.data.fight_result)
		if response.data.is_win == 1 then
			entity.owner:updateRevengeStatus(0)
		end
		if response.data.award then
			qy.tank.model.BattleModel:initAward(response.data.award)
		end
		self.model:setPlunderResult(response.data)
		callback(response.data)
	end)
end

--[[--
--掠夺稀有矿
--]]
function MineService:plunderRareMine(entity, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "RareMineral.plunder",
		["p"] = {id = entity.id, owner_id = entity.owner.id}
	}))
	-- :setShowLoading(false)
	:send(function(response, request)
		self.model:setPlunderRareMineResult(response.data, entity.id)
		qy.tank.model.BattleModel:init(response.data.fight_result)
		if response.data.award then
			qy.tank.model.BattleModel:initAward(response.data.award)
		end
		callback(response.data)
	end)
end

--[[--
--复工
--]]
function MineService:toWork(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "mining.twowork",
		["p"] = {}
	})):send(function(response, request)
		self.model:setToWorkResult(response.data)
		-- local award = {{["type"] = 3, ["num"] = response.data.outSilverNum}}
		-- qy.tank.command.AwardCommand:show(award)
		callback(response.data)
	end)
end

--[[--
--稀有矿列表
--]]
function MineService:getRareMineList(nPage, callback)
	local param = {}
	if tonumber(nPage) then
		param.page = nPage
	end
	qy.Http.new(qy.Http.Request.new({
		["m"] = "RareMineral.getList",
		["p"] = param
	})):send(function(response, request)
		self.model:initRareMineInfo(response.data)
		callback(response.data)
	end)
end

--[[--
--占有稀有矿
--]]
function MineService:occupation(mineId, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "RareMineral.occupation",
		["p"] = {id = mineId}
	})):send(function(response, request)
		self.model:updateRareMine(response.data, mineId)
		callback(response.data)
	end)
end

function MineService:getPlunderLog(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Mining.combat",
		["p"] = {}
	})):send(function(response, request)
		self.model:initLog(response.data)
		callback(response.data)
	end)
end

function MineService:showCombat(combatId, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "user.show_combat",
		["p"] = {["combat_id"] = combatId}
	})):send(function(response, request)
		qy.tank.model.BattleModel:init(response.data.combat)

		if response.data.award then
			qy.tank.model.BattleModel:initAward(response.data.award)
		end
		-- self.model:initLog(response.data)
		callback(response.data)
	end)
end

return MineService
