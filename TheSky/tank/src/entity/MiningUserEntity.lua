--[[
--矿区用户信息
--Author: H.X.Sun
--Date: 2015-05-25

	掠夺力阶段	掠夺系数	升下一级花费钻石
	默认1阶初级	30%		100
	2阶中级	50%		200
	3阶高级	70%		400
	4阶专家级	90%		600
	5阶大师级	120%		0

]]

local MiningUserEntity = qy.class("MiningUserEntity", qy.tank.entity.BaseEntity)

local mineModel = qy.tank.model.MineModel

function MiningUserEntity:ctor(data)
	if type(data) == "table" then
		--1玩家 2.AI
		self:setproperty("type", data.type)
		-- 0 :未抢 1：已抢
		self:setproperty("status", data.status or 0)
		--用户ID
		self:setUserId(data)
		--玩家等级
		self:setproperty("level", data.level)
		--玩家战斗力
		self:setproperty("fight_power", data.fight_power)
		--昵称
		self:setproperty("nickname", tostring(data.nickname))
		--头像
		self:setproperty("head_img", data.head_img or "head_1")
		--是否是仇敌 0：否 1：是
		self:setproperty("isRevenge", 0)
		--军团名称
		self:setproperty("legion_name", data.legion_name or qy.TextUtil:substitute(21056))
	elseif type(data) == "number" or type(data) == "string" then
		--用户ID
		self:setproperty("id", tonumber(data))
	end
end

function MiningUserEntity:updateLegionId(_lid)
	self.legion_id = _lid
end

--[[--
--设置用户ID
--]]
function MiningUserEntity:setUserId(data)
	local id = 0
	if data.id then
		id = data.id
	elseif data.owner_id then
		id = data.owner_id
	end
	self:setproperty("id",id)
end

--[[--
--更新状态
--]]
function MiningUserEntity:updateStatus(data)
	--是否需要复工 1：是 0 ：否
	if type(data) == "table" then
		self:setproperty("status", data.status)
	elseif type(data) == "number" or type(data) == "string" then
		self:setproperty("status", tonumber(data))
	end
end

--[[--
--更新油量
--]]
function MiningUserEntity:updateOil(data)
	if type(data) == "table" then
		self:setproperty("oil", data.oil)
	elseif type(data) == "number" or type(data) == "string" then
		self:setproperty("oil", tonumber(data))
	end
end

--[[--
--更新油量增加时间
--]]
function MiningUserEntity:updateAddOilTime(data)
	if type(data) == "table" then
		self:setproperty("oil_uptime", data.oil_uptime)
	elseif type(data) == "number" or type(data) == "string" then
		self:setproperty("oil_uptime", tonumber(data))
	end
end

--[[--
--获取剩余时间字符串
--]]
function MiningUserEntity:getRemainTimeStr()
	local seconds = 1800 -  (qy.tank.model.UserInfoModel.serverTime - self.oil_uptime)
	if seconds > 0 then
		return qy.tank.utils.NumberUtil.secondsToTimeStr(seconds, 4)
	else
		self.oil_uptime_:set(qy.tank.model.UserInfoModel.serverTime)
		if self.oil < 4 then
			self.oil_:set(self.oil + 1)
		end
		--TODO 时间数字刷新比时间字符串出现的慢
		qy.Event.dispatch(qy.Event.MINE_OIL_UPDATE)
		return qy.TextUtil:substitute(21057)
	end
end

--[[--
--更新免费刷新次数
--]]
function MiningUserEntity:updateFreeRefresh(data)
	if type(data) == "table" then
		self:setproperty("free_times", data.free_times)
	elseif type(data) == "number" or type(data) == "string" then
		self:setproperty("free_times", tonumber(data))
	end
end

--[[--
--更新掠夺
--]]
function MiningUserEntity:updatePlunderInfo(data)
	if type(data) == "table" then
		self:setproperty("plunderLevel", data.plunder_jie)
	elseif type(data) == "number" or type(data) == "string" then
		self:setproperty("plunderLevel", tonumber(data))
	end
end

--[[--
--更新复仇标志
--]]
function MiningUserEntity:updateRevengeStatus(nStatus)
	--0:不是仇敌 1 仇敌
	self.isRevenge_:set(nStatus)
end

--[[--
--获取掠夺等级名称
--]]
function MiningUserEntity:getPlunderName(level)
	if level == nil then
		level = self.plunderLevel
	end

	if level == 1 then
		return qy.TextUtil:substitute(21058)
	elseif level == 2 then
		return qy.TextUtil:substitute(21059)
	elseif level == 3 then
		return qy.TextUtil:substitute(21060)
	elseif level == 4 then
		return qy.TextUtil:substitute(21061)
	elseif level == 5 then
		return qy.TextUtil:substitute(21062)
	end
end

--[[--
--获取产量的百分比字符串
--]]
function MiningUserEntity:getPlunderPercentByLevel(level)

	if level == 1 then
		return "30%"
	elseif level == 2 then
		return "50%"
	elseif level == 3 then
		return "70%"
	elseif level == 4 then
		return "90%"
	elseif level == 5 then
		return "120%"
	end
end

--[[--
--获取升级生产力花费
--]]
function MiningUserEntity:getUpgradePlunderCost()
	local curLevel = self.plunderLevel
	if curLevel == 1 then
		return 100
	elseif curLevel == 2 then
		return 200
	elseif curLevel == 3 then
		return 400
	elseif curLevel == 4 then
		return 600
	elseif curLevel == 5 then
		return 0
	end
end

function MiningUserEntity:getVipLevelForUpgradePlunder()
	local level = self.plunderLevel
	-- print("plunderLevel ==", qy.json.encode(mineModel.plunderVipLevel))
	return mineModel.plunderVipLevel[tonumber(level + 1)]
end

--[[--
--获取掠夺力描述
--]]
function MiningUserEntity:getPlunderDes()
	return qy.TextUtil:substitute(21063, self:getPlunderPercentByLevel(self.plunderLevel))
end

--[[--
--获取生产力icon
--]]
function MiningUserEntity:getPlunderIcon()
	local level = self.plunderLevel
	return "Resources/mine/plunder_level_" .. level .. ".png"
end

--[[--
--获取掠夺等级名称颜色
--]]
function MiningUserEntity:getPlunderColor()
	return qy.tank.utils.ColorMapUtil.qualityMapColor(self.plunderLevel)
end

--[[--
--获取掠夺等级名称颜色
--]]
function MiningUserEntity:getPlunderColorFor3b()
	local level = self.plunderLevel
	return qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(level)
end

return MiningUserEntity
