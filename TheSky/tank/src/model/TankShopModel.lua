--[[
	商店model
	Author: Aaron Wei
	Date: 2015-05-12 16:21:39
]]

local TankSHopModel = qy.class("TankSHopModel", qy.tank.model.BaseModel)
local userInfo = qy.tank.model.UserInfoModel

function TankSHopModel:init()
	self.general_list = {}
	for k,v in pairs(qy.Config.shop_tank) do
		local entity = TankSHopModel.ShopTankEntity.new(v)
		table.insert(self.general_list,entity)
	end
	self:sort(self.general_list)

	self.reputation_list = {}
	for k,v in pairs(qy.Config.reputation_tank) do
		local entity = TankSHopModel.ShopTankEntity.new(v)
		table.insert(self.reputation_list,entity)
	end
	self:sort(self.reputation_list)

end

function TankSHopModel:sort(arr)
	table.sort(arr,function(a,b)
		return tonumber(a.sort) < tonumber(b.sort)
	end)
end

function TankSHopModel:getTankList(view_idx)
	if view_idx == 3 then
		return self.reputation_list
	else
		return self.general_list
	end
end

--[[
	获取是否可以兑换的状态
	param:
		entity : 商店坦克实体
		idx: 商店页面idx 1：普通坦克商店 3：声望坦克商店
	返回值
		0:资源足够，可以兑换
		1：第一种物资不足
		2：第二种物资不足
--]]
function TankSHopModel:getStatusCanBeExchanged(entity,idx)
	local have1, have2
	-- 普通坦克兑换，type 1:蓝铁，2:紫铁,3:橙铁
	-- 声望坦克兑换 没有type 兑换物资 橙铁和声望
	if idx == 1 then
		-- 普通坦克兑换
		if entity.type == 1 then
			have1 = userInfo.userInfoEntity.blueIron
		elseif entity.type == 2 then
			have1 = userInfo.userInfoEntity.purpleIron
		elseif entity.type == 3 then
			have1 = userInfo.userInfoEntity.orangeIron
		end
		if have1 >= entity.number then
			return 0
		else
			return 1
		end
	else
		-- 声望坦克兑换
		have1 = userInfo.userInfoEntity.orangeIron
		have2 = userInfo.userInfoEntity.reputation
		if have1 >= entity.orange_iron then
			if have2 >= entity.reputation then
				return 0
			else
				return 2
			end
		else
			return 1
		end
	end

end

TankSHopModel.ShopTankEntity = qy.class("ShopTankEntity", qy.tank.entity.BaseEntity)

function TankSHopModel.ShopTankEntity:ctor(data)
	for k,v in pairs(data) do
		self[k] = v
	end

	self.tank = qy.tank.entity.TankEntity.new(self.tank_id,0)
	if data.type == 1 then
		self.priceIcon = qy.tank.utils.AwardUtils.getAwardIconByType(6)
	elseif data.type == 2 then
		self.priceIcon = qy.tank.utils.AwardUtils.getAwardIconByType(7)
	elseif data.type == 3 then
		self.priceIcon = qy.tank.utils.AwardUtils.getAwardIconByType(8)
	end

	local quality = self.tank.quality
	if quality == 1 then
		self.bg = ""
	elseif quality == 2 then
		self.bg = ""
	elseif quality == 3 then
		self.bg = "Resources/shop/zcgc_0007.png"
	elseif quality == 4 then
		self.bg = "Resources/shop/zcgc_0006.png"
	elseif quality == 5 then
		self.bg = "Resources/shop/zcgc_0005.png"
	elseif quality == 6 then
		self.bg = "Resources/shop/zcgc_000ss.png"
	end
end

-- 根据tank_id获取需要材料数量
function TankSHopModel:getTankNeedMeterials(tank_id)
	local nums = 0
	for k,v in pairs(qy.Config.shop_tank) do
		if v.id == tank_id then
			return v.number
		end
	end
end

function TankSHopModel:getMenuNum()
	if userInfo.userInfoEntity.level < 40 then
		return 2
	else
		return 2
	end
end

return TankSHopModel
