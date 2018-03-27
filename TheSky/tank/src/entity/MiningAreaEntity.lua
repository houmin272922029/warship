--[[
    矿区实体
    Author: H.X.Sun
    Date: 2015-05-25

    普通矿
	产量阶段	产量系数	升下一级花费钻石	储量系数（当前产量可生产时间）
	默认1阶初级	100%		100			4小时
	2阶中级	150%		200			8小时
	3阶高级	225%		400			12小时
	4阶专家级	300%		600			16小时
	5阶大师级	400%		0			24小时

	每6分钟产量算法=产量系数*指挥官等级*120
]]

local MiningAreaEntity = qy.class("MiningAreaEntity", qy.tank.entity.BaseEntity)

local mineModel = qy.tank.model.MineModel

function MiningAreaEntity:ctor(data)
	if tonumber(data._id) then
		--稀有矿区--
		--矿区ID
		self:setproperty("id", data._id)
		--等级段
		self:setproperty("levelKey", data.level_key)
		--位置
		self:setproperty("number", data.number)
		--1:普通 2:龙头
		self:setproperty("type", data.type)
		self:updateRareMine(data)
	elseif data.outSilverNum then
		--自己的矿区--
		self.owner = qy.tank.entity.MiningUserEntity.new(qy.tank.model.UserInfoModel.userInfoEntity.kid)
		self.owner:updatePlunderInfo(data.plunder_jie)
		--更新生产力
		self:updateProductInfo(data.silver_info)
		--当前产量
		self:setproperty("curProduct", data.outSilverNum + self.remainProduct)
		--最大产量
		self:updateMaxProduct(data)
		--每小时产出
		self:setproperty("perSecondProduct", data.perSecondNum)
		--更新油量
		self.owner:updateOil(data.oil)
		--更新增加油量时间
		self.owner:updateAddOilTime(data.oil_uptime)
	elseif data.nickname then
		--掠夺矿区--
		self.owner = qy.tank.entity.MiningUserEntity.new(data)
		--当前产量
		self:setproperty("curProduct", data.product)
		self:updateLegionId(data.legion_id or 0)
	end
end

function MiningAreaEntity:updateLegionId(_lid)
	self.owner:updateLegionId(_lid)
end

function MiningAreaEntity:updateSecondProduct(_perSecondNum)
	--每小时产出
	self.perSecondProduct = _perSecondNum
end

--[[--
--更新稀有矿区
--]]
function MiningAreaEntity:updateRareMine(data)
	--拥有者
	self.owner = qy.tank.entity.MiningUserEntity.new(data)
	--开始时间
	self:setproperty("startTime", data.start_time)
	--产量
	self:setRareMineProduct()
end

--[[--
--是否可以收获
--]]
function MiningAreaEntity:canHarvest()
	if self.curProduct / self.maxProduct > 0.1 then
		return true
	else
		return false
	end
end

--[[--
--设置产量
--]]
function MiningAreaEntity:setRareMineProduct()
	--每分钟产量
	local product = self:calculateProductEveryMin()
	self:setproperty("productEveryMin", product)
	--最大产量
	self:updateMaxProduct(product * 120)
	--当前产量
	local curProduct = self:calculateCurProduct()
	self:setproperty("curProduct", curProduct)
end

--[[--
--每分钟的产量描述
--]]
function MiningAreaEntity:getProductEveryMinuteDes()
	return self.productEveryMin .. " / "..qy.TextUtil:substitute(21049)
end

--[[--
--计算当前产量
--]]
function MiningAreaEntity:calculateCurProduct()
	local curProduct = self.maxProduct * (qy.tank.model.UserInfoModel.serverTime - self.startTime) / 7200
	if curProduct > self.maxProduct then
		return self.maxProduct
	elseif curProduct > 0 then
		return curProduct
	else
		return 0
	end
end

--[[--
--获取稀有矿当前产量
--]]
function MiningAreaEntity:getRareMineCurProduct()
	if self.curProduct < self.maxProduct then
		local curProduct = self.maxProduct * (qy.tank.model.UserInfoModel.serverTime - self.startTime) / 7200
		self.curProduct_:set(curProduct)
		if curProduct > self.maxProduct then
			return self.maxProduct
		elseif curProduct > 0 then
			return curProduct
		else
			return 0
		end
	else
		return self.maxProduct
	end
end

--[[--
--是否满矿
--]]
function MiningAreaEntity:isProductFull()
	if self.curProduct < self.maxProduct then
		local curProduct = self.maxProduct * (qy.tank.model.UserInfoModel.serverTime - self.startTime) / 7200
		if curProduct > self.maxProduct then
			return true
		else
			return false
		end
	else
		return true
	end
end

--[[--
--计算稀有矿每分钟产量
--]]
function MiningAreaEntity:calculateProductEveryMin()
	local product = 0
	local levelParam =mineModel:getRareMineLevelParam()
	if self.type == 1 then
		--普通矿
		product = levelParam * 120
	elseif self.type == 2 then
		--稀有矿
		product = levelParam * 180
	end
	return product
end

--[[--
--更新最大产量
--]]
function MiningAreaEntity:updateMaxProduct(data)
	if type(data) == "table" then
		self:setproperty("maxProduct", data.maxSilverNum)
	elseif type(data) == "number" or type(data) == "string" then
		self:setproperty("maxProduct", tonumber(data))
	end
end

--[[--
--获取每小时产量
--]]
function MiningAreaEntity:getProductEveryHour()
	return self.perSecondProduct * 3600
end

--[[--
--更新当前产量
--]]
function MiningAreaEntity:updateCurrentProduct()
	local time = math.floor((qy.tank.model.UserInfoModel.serverTime - self.startTime) / 10) * 10
	local currentProduct = self.perSecondProduct * time + self.remainProduct
	if  currentProduct > self.maxProduct then
		self.curProduct_:set(self.maxProduct)
	elseif currentProduct > 0 then
		self.curProduct_:set(currentProduct)
	else
		self.curProduct_:set(0)
	end
end

--[[--
--更新生产力
--]]
function MiningAreaEntity:updateProductInfo(data)
	if type(data) == "table" then
		--更新生产信息--
		--是否需要复工 0:不需要 1：需要
		self.owner:updateStatus(data.is_two_work)
		if data.is_two_work == 1 then
			--如果处在待复工状态，则当前产量为剩余
			self:setproperty("curProduct", data.balance)
		end
		--开始时间
		self:setproperty("startTime", data.start_time)
		--结束时间
		self:setproperty("endTime", data.end_time)
		--剩余产量
		self:setproperty("remainProduct", data.balance or 0)
		--生产力的等级
		self:setproperty("productLevel", data.jie)
	elseif type(data) == "number" or type(data) == "string" then
		--更新生产等级
		self:setproperty("productLevel", tonumber(data))
	end
end

--[[--
--获取生产等级名称
--]]
function MiningAreaEntity:getProductivityName(level)
	if level == nil then
		level = self.productLevel
	end

	if level == 1 then
		return qy.TextUtil:substitute(21050)
	elseif level == 2 then
		return qy.TextUtil:substitute(21051)
	elseif level == 3 then
		return qy.TextUtil:substitute(21052)
	elseif level == 4 then
		return qy.TextUtil:substitute(21053)
	elseif level == 5 then
		return qy.TextUtil:substitute(21054)
	end
end

--[[--
--获取生产力描述
--]]
function MiningAreaEntity:getProductivityDes()
	return qy.TextUtil:substitute(21055) .. self:getProductivityPercent(self.productLevel)
end

--[[--
--获取产量的百分比字符串
--]]
function MiningAreaEntity:getProductivityPercent(level)
	if level == 1 then
		return "100%"
	elseif level == 2 then
		return "150%"
	elseif level == 3 then
		return "255%"
	elseif level == 4 then
		return "300%"
	elseif level == 5 then
		return "400%"
	end
end

--[[--
--获取生产等级名称颜色
--]]
function MiningAreaEntity:getProductivityColor()
	return qy.tank.utils.ColorMapUtil.qualityMapColor(self.productLevel)
end

--[[--
--获取生产等级名称颜色
--]]
function MiningAreaEntity:getProductivityColorFor3b()
	local level = self.productLevel
	-- return qy.tank.model.MineModel:getColorFor3b(level)
	return qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(level)
end

--[[--
--获取升级生产力花费
--]]
function MiningAreaEntity:getUpgradeProductivityCost()
	local curLevel = self.productLevel
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

--[[--
--获取升级生产力对应的VIP等级
--]]
function MiningAreaEntity:getVipLevelForUpgradeProductivity()
	local level = self.productLevel
	return mineModel.productVipLevel[tonumber(level + 1)]
	-- if level == 1 then
	-- 	return mineModel.productVipLevel[1]
	-- elseif level == 2 then
	-- 	return 1
	-- elseif level == 3 then
	-- 	return 1
	-- elseif level == 4 then
	-- 	return 3
	-- elseif level == 5 then
	-- 	return 5
	-- end
end

--[[--
--获取生产力icon
--]]
function MiningAreaEntity:getProductIcon()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/mine/mine.plist")
	local level = self.productLevel
	return "Resources/mine/product_level_" .. level .. ".png"
end

--[[--
--产量百分比
--]]
function MiningAreaEntity:getProductPercent()
	if self.owner.status == 0 then
		--活跃状态
		return math.floor(self.curProduct / self.maxProduct * 100)
	else
		--待复工状态
		return math.floor(self.remainProduct / self.maxProduct * 100)
	end
end

--[[--
--产量数
--]]
function MiningAreaEntity:getProductNum()
	if self.owner.status == 0 then
		--活跃状态
		return self.curProduct .. "/ " .. self.maxProduct
	else
		--待复工状态
		return self.remainProduct .. "/ " .. self.maxProduct
	end

end

return MiningAreaEntity
