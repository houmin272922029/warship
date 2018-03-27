--[[

]]

local CouponShopModel = class("CouponShopModel", qy.tank.model.BaseModel)
 



--初始化
function CouponShopModel:init( _data, _type )
	if _data == nil then
		print("FireRebateModel获取活动数据失败--传入数据为nil")
		return
	end

	self.mSurplusTimes = _data.update_time - _data.time
	self.mGwcData = {}
	self.mClikIndex = -1
	self.mlastClickItem = nil
	self:SetDiamond( _data.diamond )
	self:SetProps( _data.props )

	self.mType = _type
	self.mShopDisCout = qy.Config.shop_props_discount--折扣表
	self.mShopCf = _data.list

	local t = {}
	for i,v in pairs(self.mShopCf) do
		t[#t + 1] = v 
	end
	self.mShopCf = t
   
end


function CouponShopModel:SetDiamond( _d )
	self.mDiamond = _d
end

function CouponShopModel:GetDiamond(  )
	return self.mDiamond
end


function CouponShopModel:SetProps( _d )
	self.mProps = _d
end

function CouponShopModel:GetProps(  )
	return self.mProps
end


--[[
	返回当前活动类型
]]--
function CouponShopModel:GetAtType(  )
	return self.mType
end


function CouponShopModel:SetLastClickItem( _item )
	self.mlastClickItem = _item
end

function CouponShopModel:GetLastClickItem(  )
	return self.mlastClickItem
end



--[[
	获取活动剩余的时间
]]--
function CouponShopModel:GetSurplusTiems(  )
	if self.mSurplusTimes == nil then
		self.mSurplusTimes = 0
	end
	return self.mSurplusTimes
end

function CouponShopModel:SetSurplusTiems( num )
	self.mSurplusTimes = num
end
--[[
	算出是否是最后一天
]]--
function CouponShopModel:GetSurplusTiemsState()
	if self.mSurplusTimes <= 0 then
		return true
	else
		return false
	end
end




--[[
	购物车数据
]]--
function CouponShopModel:SetGwcData( idex )

	-- local _bool = false 
	-- for k,v in pairs(self.mGwcData) do
	-- 	if tonumber(v.id) == tonumber(self.mShopCf[idex].id) then
	-- 		self.mGwcData[k].mdqbuy_num = self.mGwcData[k].mdqbuy_num + 1
	-- 		_bool = true
	-- 	end
	-- end

	-- local len = #self.mGwcData+1
	-- if _bool == false then
	-- 	self.mGwcData[len] = self.mShopCf[idex]
	-- 	self.mGwcData[len].mdqbuy_num = 1
	-- end

	local _index = idex
	self.mGwcData[#self.mGwcData+1] = self.mShopCf[_index]

	self.mShopCf[_index].buy_num = self.mShopCf[_index].buy_num - 1
	if self.mShopCf[_index].buy_num <= 0 then
		self.mShopCf[_index].buy_num = 0
	end
end

--[[
	返回你选择的商品 id 剩余数量有木有
]]--
function CouponShopModel:GetShopCfInDexBuyNum( idex )
	return self.mShopCf[idex].buy_num
end


function CouponShopModel:GetGwcData(  )
	return self.mGwcData
end

--[[
	记住选中的是多少ID
]]--
function CouponShopModel:SetClikIndex( num )
	self.mClikIndex = num
end

function CouponShopModel:GetClikIndex(  )
	return self.mClikIndex
end

--[[
	移出被删除的列表id  移除后要加到原有商店中
]]--
function CouponShopModel:RemoveGwcDataInid( id )


	for i,v in pairs(self.mShopCf) do
		if v.id == self.mGwcData[id].id then
			self.mShopCf[i].buy_num = self.mShopCf[i].buy_num + 1 
			break
		end
	end

	table.remove(self.mGwcData , tonumber(id) )

end



--[[
	算出选中商品一共的价钱  和当前的折扣
]]--
function CouponShopModel:GetShopDisPrice(  )
	local price = 0
	local discount = 0
	local beishu = 10
	for i=1,#self.mGwcData do
		if self.mType == 2 then
			price = self.mGwcData[i].shop_card_num + price
		else
			price = self.mGwcData[i].diamond_num + price

		end
	end

	for k,v in pairs(self.mShopDisCout) do
		if v.cost_type == 1 then
			if price >= v.cost_num   then
				discount = v.discount
			end
		end
	end

	if tonumber(discount) <= 0 then
		discount = 1
		beishu = 1
	end

	local t = { ["price"] = price, ["discount"] = discount, ["ssprice"] = price * discount / beishu }

	return t
end

function CouponShopModel:GetShopTable(  )
	local st = {}
	local a = 1
	for i=1,#self.mGwcData do
		local id = self.mGwcData[i].id
		if st[tostring(id)] then
			st[tostring(id)] = st[tostring(id)] + a
		else
			st[tostring(id)] = 1
		end
	end

	for k,v in pairs(st) do
	end
	return st
end

--[[
	
]]--
function CouponShopModel:OnEnter( _layer )
	self.mModleMainlayer = _layer
end

function CouponShopModel:GetModleMainlayer(  )
	return self.mModleMainlayer
end




return CouponShopModel
