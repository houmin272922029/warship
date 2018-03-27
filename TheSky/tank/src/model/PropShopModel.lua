--[[
	商店道具&装备model
	Author: Aaron Wei
	Date: 2015-05-13 16:47:31
]] 

local PropShopModel = qy.class("PropShopModel", qy.tank.model.BaseModel)

function PropShopModel:init()
	self.list = {} 			--普通商店
	self.aid_shop_list = {} --战地援助商店
	for k,v in pairs(qy.Config.shop_props) do
		local entity = PropShopModel.ShopPropEntity.new(v)
		if entity.panel == 1 then
			-- 战地援助商店
			table.insert(self.aid_shop_list,entity)
		else
			-- 普通商店
			table.insert(self.list,entity)
		end
	end

	table.sort(self.list,function(a,b)
		return tonumber(a.sort) < tonumber(b.sort)
	end)

	if #self.aid_shop_list > 0 then
		table.sort(self.aid_shop_list,function(a,b)
			return tonumber(a.sort) < tonumber(b.sort)
		end)
	end
end

function PropShopModel:getAidPropEntityByIndex(_idx)
	return self.aid_shop_list[_idx]
end

-- function PropShopModel:getPropsEntityById(_id)
-- 	-- b
-- end

function PropShopModel:getAlloyChestIdx()
	if self.alloyChestIdx == nil then
		for i = 1, #self.list do
			if self.list[i].props then
				if tonumber(self.list[i].props.id) == 19  then
					self.alloyChestIdx = i
					return i
				end
			end
		end
		return 1
	else
		return self.alloyChestIdx
	end
end

function PropShopModel:getShopPropsIdByProsId(_id)
	for k,v in pairs(qy.Config.shop_props) do
		if v.shop_id == _id then
			return v.id
		end
	end

	return -1
end

function PropShopModel:getShopPropsEntityById(_id)
	-- print("_id ===" .. _id)
	for i = 1, #self.list do
		-- print("self.list[i].shop_id ===" .. self.list[i].shop_id)
		if tonumber(self.list[i].id) == tonumber(_id) then
			-- print("self.list[i].shop_id ==-----=" .. self.list[i].shop_id)
			return self.list[i]
		end
	end

	return nil
end

function PropShopModel:updateConsum(id, consume)
	local entity = self:getShopPropsEntityById(id)
	if entity then
		entity.number = consume
		print("updateConsum ==entity.number==" ..entity.number)
	end
end

function PropShopModel:updateAllConsume(_data)
	for i = 1, #_data do
		for _k, _v in pairs(_data[i]) do
			local entity = self:getShopPropsEntityById(tonumber(_k))
			if entity then
				entity.number = _v
				print("updateConsum ==entity.number==" ..entity.number)
			end
		end
	end
end

function PropShopModel:createPropEntity(data)
	return qy.tank.entity.PropsEntity.new(data)
end

PropShopModel.ShopPropEntity = qy.class("ShopPropEntity", qy.tank.entity.BaseEntity)

function PropShopModel.ShopPropEntity:ctor(data)
	--[[
		id
		shop_type —— 商品类型
		shop_id
		sort
		currency_type —— 出售货币类型
		increase —— 每次递增价格
		number —— 货币数额
		trigger_radio —— 是否触发广播
		vip_limit —— VIP等级限制
		max_buy_limit —— 最大购买限制
		panel -- 作用于的商店 0：普通商店 1：战地援助
	]]
	for k,v in pairs(data) do
		-- print("data=====>>>>>>"..data.shop_type.."======",data.shop_id)
		self[k] = v
	end

	if data.shop_type == 1 then -- 道具
		self.props = qy.tank.entity.PropsEntity.new(data.shop_id)
		self.equip = nil
	elseif data.shop_type == 2 then -- 装备
		self.equip = qy.tank.entity.EquipEntity.new(data.shop_id)
		self.props = nil
	end

	if data.currency_type == 1 then
		self.priceIcon = "Resources/common/icon/coin/1.png"
	elseif data.currency_type == 2 then
		self.priceIcon = "Resources/common/icon/coin/3.png"
	elseif data.currency_type == 3 then
		self.priceIcon = "Resources/common/icon/coin/6.png"
	elseif data.currency_type == 4 then
		self.priceIcon = "Resources/common/icon/coin/7.png"
	end
end

return PropShopModel
