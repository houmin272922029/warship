--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local FanFanLeModel = qy.class("FanFanLeModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function FanFanLeModel:init(data)
	self.award_list = {}


	self.gold_award_list = {}
	self.silver_award_list = {}

	local staticData = qy.Config.fanfanle_gold_award
	for i, v in pairs(staticData) do
		v.is_obtain = false
		table.insert(self.gold_award_list, v)
	end

	local staticData2 = qy.Config.fanfanle_silver_award
	for i, v in pairs(staticData2) do
		table.insert(self.silver_award_list, v)
	end

	-- table.sort(self.gold_award_list,function(a,b)
	-- 	return tonumber(a.id) < tonumber(b.id)
	-- end)
	
	-- table.sort(self.silver_award_list,function(a,b)
	-- 	return tonumber(a.id) < tonumber(b.id)
	-- end)
	local staticData = qy.Config.fanfanle_shop
	self.shoplist1 = {}
	self.shoplist2 = {}
	for k,v in pairs(staticData) do
		if v.shop_type == 1 then
			table.insert(self.shoplist1, v)
		else
			table.insert(self.shoplist2, v)
		end
	end
	table.sort(self.shoplist1,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
	table.sort(self.shoplist2,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
	self:update(data)
end



function FanFanLeModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	--金/银开了几次
	self.gold_use = data.gold_use or self.gold_use
	self.silver_use = data.silver_use or self.silver_use

	--其他玩家获得奖励列表
	self.get_award_user_list = data.get_award_user_list or self.get_award_user_list
	--金/银全部开启一定会获得的
	self.gold_must_award = data.gold_must_award or self.gold_must_award
	self.silver_must_award = data.silver_must_award or self.silver_must_award
	--花了多少钱
	self.cash = data.cash or self.cash
	-- --金/银已经开启并获得的奖励
	-- self.gold_award = data.gold_award or self.gold_award
	-- self.silver_award = data.silver_award or self.silver_award

	-- table.sort(self.gold_award,function(a,b)
	-- 	return tonumber(a.post) < tonumber(b.post)
	-- end)

	-- table.sort(self.silver_award,function(a,b)
	-- 	return tonumber(a.post) < tonumber(b.post)
	-- end)
	
	--金/银一共获得的开启次数
	self.gold_sum = data.gold_sum or self.gold_sum
	self.silver_sum = data.silver_sum or self.silver_sum
	--金/银剩余的次数
	self.gold_remain = data.gold_remain or self.gold_remain 
	self.silver_remain = data.silver_remain or self.silver_remain
	
	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time
end



function FanFanLeModel:getSilverAwardList()
	for i = 1, 10 do
		local data = self.silver_award_list[i]
		local num = math.random(10)
		self.silver_award_list[i] = self.silver_award_list[num]
		self.silver_award_list[num] = data
	end
	return self.silver_award_list
end


function FanFanLeModel:getGoldAwardList()
	for i = 1, 10 do
		local data = self.gold_award_list[i]
		local num = math.random(10)
		self.gold_award_list[i] = self.gold_award_list[num]
		self.gold_award_list[num] = data
	end
	return self.gold_award_list
end



return FanFanLeModel