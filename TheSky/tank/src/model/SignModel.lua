--[[
	签到
	Author: fq
	Date: 2016年08月05日15:02:46
]]

local SignModel = qy.class("SignModel", qy.tank.model.BaseModel)

function SignModel:init(_data)

	self.award_list = {}
	self.total_award_list = {}
	self.total_award_list_size = 0
	self.sign_num_award_list = {}
	self:update(_data)

	local month_day_num = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

	local staticData = qy.Config.sign_award
	for i, v in pairs(staticData) do
		if tonumber(i) <= month_day_num[self.month] then

			table.insert(self.award_list, v)

			if self.total_award_list[tostring(math.floor((i - 1) / 5) + 1)] == nil then
				self.total_award_list[tostring(math.floor((i - 1) / 5) + 1)] = {}
				self.total_award_list_size = self.total_award_list_size + 1
			end

			table.insert(self.total_award_list[tostring(math.floor((i - 1) / 5) + 1)], v)
		end
	end

	table.sort(self.award_list,function(a,b)
		return tonumber(a.count) < tonumber(b.count)
	end)

	for i = 1, math.floor((#self.award_list - 1) / 5) + 1 do
		table.sort(self.total_award_list[tostring(i)],function(a,b)
			return tonumber(a.count) < tonumber(b.count)
		end)
	end





	local staticData2 = qy.Config.sign_num_award
	for i, v in pairs(staticData2) do
		table.insert(self.sign_num_award_list, v)
	end
		
end

function SignModel:update(_data)

	--{"activity_info":{"month":8,"sign":{"sign_8":{"num":0},"sign_num":0}}}
	local data = _data

	if _data.activity_info then 
		data = _data.activity_info
	end

	self.month = data.month
	self.current_num = data.sign["sign_"..self.month].num
	self.status = data.status
	self.sign_status = data.sign_status
	self.total_num = data.sign.sign_num
end


function SignModel:getTotalAwardByIndex(_idx) 
	return self.total_award_list[tostring(_idx)]
end

function SignModel:getTotalAwardSize()
	return self.total_award_list_size
end

function SignModel:getAwardByIndex(_idx) 
	return self.award_list[_idx]
end

function SignModel:isSingle() 
	return self.month % 2 == 1
end

function SignModel:getCurrentNum() 
	return self.current_num
end

function SignModel:getTotalNum() 
	return self.total_num
end


function SignModel:getSignNumAward()
	if self:isSingle() then
		return self.sign_num_award_list[1].single_award
	else
		return self.sign_num_award_list[1].double_award
	end
end


return SignModel