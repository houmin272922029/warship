--[[
	商店model
	Author: Aaron Wei
	Date: 2016-01-05 14:58:36
]]

local TorchModel = qy.class("TorchModel", qy.tank.model.BaseModel)

function TorchModel:init(data)
	self.end_time = data.torch.end_time
	self.award_end_time = data.torch.award_end_time

	self.config = qy.Config.torch_operation_task
	self.day = #data.list

	self.my_buy = data.my_buy

	self.list = {}
	self.tabRedList = {}
	self.dayRedList = {}

	for i=1,#data.list do
		local list = data.list[i]
		local redList = {}

		local daily_welfare = {}
		redList[1] = false
		for k,v in pairs(list.daily_welfare) do
			local item = self.config[tostring(v.task_id)]
			item.is_draw = v.is_draw
			item.day = i
			item.idx = tonumber(k)
			if v.award then
				item.award = v.award
			end

			if item.is_draw == 2 then
				redList[1] = true
			end
			table.insert(daily_welfare,item)
		end
		self:sort(daily_welfare)

		task1 = {}
		redList[2] = false
		for k,v in pairs(list.task1) do
			local item = self.config[tostring(v.task_id)]
			item.is_draw = v.is_draw
			item.day = i
			item.idx = tonumber(k)

			if item.is_draw == 2 then
				redList[2] = true
			end
			table.insert(task1,item)
		end
		self:sort(task1)

		local task2 = {}
		redList[3] = false
		for k,v in pairs(list.task2) do
			local item = self.config[tostring(v.task_id)]
			item.is_draw = v.is_draw
			item.day = i
			item.idx = tonumber(k)

			if item.is_draw == 2 then
				redList[3] = true
			end
			table.insert(task2,item)
		end
		self:sort(task2)

		local buyItem = qy.Config.torch_operation[tostring(i)]
		-- buyItem.buy = data.server_buy[tostring(i)]
		if self.my_buy[tostring(i)] == 1 then
			redList[4] = false
		else
			redList[4] = true
		end
		--print("loggingsddddd======>>>>",qy.json.encode(self.my_buy))

		self.dayRedList[i] = false
		for j = 1,4 do
			if redList[j] == true then
				self.dayRedList[i] = true
				break
			end
		end

		table.insert(self.tabRedList,redList)
		table.insert(self.list,{["daily_welfare"]=daily_welfare,["task1"]=task1,["task2"]=task2,["buy"]=buyItem})
	end
end

function TorchModel:updateRedot()
	for i=1,7 do
		local list = self.list[i]
		self.tabRedList[i] = {}

		self.tabRedList[i][1] = false
		self.tabRedList[i][2] = false
		self.tabRedList[i][3] = false
		self.tabRedList[i][4] = false
		if list then
			for k,v in pairs(list.daily_welfare) do
				if v.is_draw == 2 then
					self.tabRedList[i][1] = true
					break
				end
			end

			for k,v in pairs(list.task1) do
				if v.is_draw == 2 then
					self.tabRedList[i][2] = true
					break
				end
			end

			for k,v in pairs(list.task2) do
				if v.is_draw == 2 then
					self.tabRedList[i][3] = true
					break
				end
			end

			if self.my_buy[tostring(i)] == 1 then
				self.tabRedList[i][4] = false
			else
				self.tabRedList[i][4] = true
			end
		end

		self.dayRedList[i] = false
		for j = 1,4 do
			if self.tabRedList[i][j] == true then
				self.dayRedList[i] = true
				break
			end
		end
	end
end

function TorchModel:getRedByDay(d)
	-- self:updateRedot()
	return self.dayRedList[d]
end

function TorchModel:getRedByTab(d,t)
	-- self:updateRedot()
	return self.tabRedList[d][t]
end

function TorchModel:sort(arr)
	table.sort(arr,function(a,b)
		return tonumber(a.idx) < tonumber(b.idx)
	end)
	return arr
end

return TorchModel
