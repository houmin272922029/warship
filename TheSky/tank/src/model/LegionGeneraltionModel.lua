--[[

]]

local LegionGeneraltionModel = class("LegionGeneraltionModel", qy.tank.model.BaseModel)
 

--初始化
function LegionGeneraltionModel:init( _data )

	if _data == nil then
		print("FireRebateModel获取活动数据失败--传入数据为nil")
		return
	end
	local data =  _data.activity_info



	print("1==========="..qy.json.encode(data))

	self.mSurplusTimes = data.ent_time  - data.server_time
	self.mlegion_rank = data.legion_rank
	self.muser_rank = data.user_rank
	self.my_rank = data.my_rank
	self.mLeRankCf = qy.Config.legion_mobilization_rank
	self.mLeShopCf = qy.Config.legion_mobilization_shop
	self.mShopData = data.shop

	self.mShopCardNum = data.props.num



	self:InitShopData()
	self:InitRankData()
end

--[[
	塞选出表格2个商城的数据
]]--
function LegionGeneraltionModel:InitShopData(  )

	self.DiamondShop = {}
	self.BuyShop = {} 
	local dindex = 1
	local bindex = 1


	for k,v in pairs(self.mLeShopCf) do
		if v.type == 1 then
			-- table.insert(DiamondShop, v)
			self.DiamondShop[dindex] = v
			
			dindex = dindex + 1
		else
			-- table.insert(BuyShop, v)
			self.BuyShop[bindex] = v
			bindex = bindex + 1

		end
	end
end
--[[
	塞选出排名奖励数据
]]--
function LegionGeneraltionModel:InitRankData(  )

	self.PersonalRank = {}
	self.legionRank = {} 

	for k,v in pairs(self.mLeRankCf) do
		if v.type == 1 then
			self.PersonalRank[v.rank_id] = v
		else
			self.legionRank[v.rank_id] = v
		end
	end

end

--[[
	传入id查看当前id 买过没有
]]--
function LegionGeneraltionModel:GetShopInID( _id )
	for k,v in pairs(self.mShopData) do
		if tonumber(k) == _id then
			if v and v >= 1 then
				return true
			else
				return false
			end
		end
	end
	return false
end
--[[
	传入id查看当前id 买过以后次数加1
]]--
function LegionGeneraltionModel:SetShopInID( _id )
	for k,v in pairs(self.mShopData) do
		if tonumber(k) == _id then
			self.mShopData[k] = v - 1
		end
	end
end




--[[
	获取活动剩余的时间
]]--
function LegionGeneraltionModel:GetSurplusTiems(  )
	if self.mSurplusTimes == nil then
		self.mSurplusTimes = 0
	end
	return self.mSurplusTimes
end

--[[
	获取活动剩余的购物卡
]]--
function LegionGeneraltionModel:GetShopCardNum(  )
	if self.mShopCardNum == nil then
		self.mShopCardNum = 0
	end
	return self.mShopCardNum
end

function LegionGeneraltionModel:SetShopCardNum( _num )
	if self.mShopCardNum == nil then
		self.mShopCardNum = 0
	end
	self.mShopCardNum = self.mShopCardNum - _num

	if self.mShopCardNum <= 0 then
		self.mShopCardNum = 0
	end
end



return LegionGeneraltionModel
