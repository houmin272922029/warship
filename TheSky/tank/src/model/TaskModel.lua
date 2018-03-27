--[[
    任务
    Author: H.X.Sun
    Date: 2015-05-11
    在底层捕获有关任务的数据
]]

local TaskModel = qy.class("TaskModel", qy.tank.model.BaseModel)

local OTT_CATE = 2

--[[--
--创建实体
--@param #table data 一个任务的数据
--@param #string listName 所在数组的名字

--]]
function TaskModel:createEntity(data, listName)
	if listName == "daily_task_list" then
		--日常任务
		data.name = "daily_task"
		data.category = 1
		-- data.sortIndex = 2
	elseif listName == "one_times_list" then
		--一次性任务
		data.name = "one_times_task"
		data.category = 2
		-- data.sortIndex = 3
	elseif listName == "rand_list" then
		--随机任务
		data.name = "random_task"
		data.category = 3
		-- data.sortIndex = 1
	end

	return qy.tank.entity.TaskEntity.new(data)
end

--[[--
--获取任务列表
--@param #table 任务数据 入口后端所传的数据 data
--]]
function TaskModel:getList(data)
	print("data.daily_task_list",data.daily_task_list)
	self.taskList = {}
	self.taskList[1] = {}
	self.taskList[2] = {}
	self.taskList[3] = {}
	for k, v in pairs(data) do
		if type(v) == "table" then
			for i = 1, #data[k] do
				--审核屏蔽，去掉月卡任务
				if qy.product == "sina" and k == "one_times_list" and data[k][i]["task_id"] == 38 then
					--新浪包：月卡任务，跳过本次循环
				else
					local entity = self:createEntity(data[k][i], k)
					
					if entity.category == OTT_CATE then
						table.insert(self.taskList[3],entity)
					elseif entity.category == 1 then
						self.round_type = entity.round_type
						if entity.round_type == "day" then
							table.insert(self.taskList[1],entity)
						else
							table.insert(self.taskList[2],entity)
						end
					end
				end
			end
		end
	end
	for i = 1, #self.taskList do
		if #self.taskList[i] > 0 then
			self:sort(self.taskList[i])
		end
	end

end

--[[---
--排序：已完成 > 未完成 > 日常任务 > 一次性任务 > 随机任务
-]]
function TaskModel:sort(arr)
	table.sort(arr,function(a,b)
		if a.status == b.status then
			if a.category == b.category then
				return false
			else
				--随机任务 > 日常任务 > 一次性任务
				return a.category > b.category
			end
		else
			--状态(已完成 > 未完成)
			return a.status > b.status
		end
	end)
	return arr
end

--[[--
--删除一个任务
--@param 任务实体
--]]
-- function TaskModel:removeOneTask(idx)
-- 	table.remove(self.taskList, idx)
-- end

--[[--
--根据分类和id找idx
--]]
function TaskModel:getIdxByCategoryAndId(category, id,_listIdx)
	if self.taskList == nil or self.taskList[_listIdx] == nil then
		return -1
	end
	local data = self.taskList[_listIdx]
	for i = 1, #data do
		if data[i].category == category and data[i].task_id == id then
			return i
		end
	end

	return -1
end

--[[--
--领奖
--]]
function TaskModel:setReward(data)
	self.award = {}
	if data.award then
		self.award = data.award
		qy.tank.command.AwardCommand:add(self.award)
	end
	if data.user_exp then
		local expAward = {}
		expAward.num = data.user_exp.add_exp
		expAward.id = 0
		expAward.type = -1
		table.insert(self.award,expAward)
	end
end

--[[--
--获取领奖数据
--]]
function TaskModel:getReward()
	return self.award
end

--[[--
--获取分类
--]]
function TaskModel:getCategoryByListName(listName)
	if listName == "daily_task_list" then
		--日常任务
		return 1
	elseif listName == "one_times_list" then
		--一次性任务
		return 2
	elseif listName == "rand_list" then
		--随机任务
		return 3
	end
end

function TaskModel:get_round_type(_idx)
	local config = qy.Config.daily_task
	for k,v in pairs(config) do
		if v.id == _idx then
			return v.round_type
		end
	end
end
--[[--
--更新
--]]
function TaskModel:update(data)
	local _cate, _listIdx
	for k, v in pairs(data) do
		if type(v) == "table" then
			for i = 1, #data[k] do
				_cate = self:getCategoryByListName(k)
				local entity = self:createEntity(data[k][i], k)
				if _cate == OTT_CATE then
					_listIdx = 3
				elseif _cate == 1 then
					local entity = self:createEntity(data[k][i], k)
					local round_type = self:get_round_type(data[k][i].task_id)
					if round_type == "day" then
						_listIdx = 1
					elseif round_type == "week" then
						_listIdx = 2
					end
					
				end
				local idx = self:getIdxByCategoryAndId(_cate, data[k][i].task_id,_listIdx)
				if idx > 0 then
					self:updateOneTask(idx, data[k][i],_listIdx)
				end
			end
		end
	end
	if self.needSort then
		if #self.taskList[1] > 0 then
			self:sort(self.taskList[1])
		end
		if #self.taskList[2] > 0 then
			self:sort(self.taskList[2])
		end
		if #self.taskList[3] > 0 then
			self:sort(self.taskList[3])
		end
	end
end

--[[--
--更新一个任务状态
--]]
function TaskModel:updateOneTask(idx, data,_listIdx)
	if self.taskList[_listIdx] and self.taskList[_listIdx][idx] and idx > 0 then
		if data.status == 2 then
			table.remove(self.taskList[_listIdx], idx)
			-- qy.Event.dispatch(qy.Event.TASK_REWARD_UPDATE)
		else
			self.taskList[_listIdx][idx].status = data.status
			self.taskList[_listIdx][idx].complete_times_:set(data.complete_times)
			self.needSort = true
		end
	end
end

--[[--
--获取任务列表
--]]
function TaskModel:getTaskListByIdx(_idx)
	return self.taskList[_idx]
end

function TaskModel:getTaskNum()
	local number = 0
	if self.taskList then
		if self.taskList[1] then
			number = number + #self.taskList[1]
		end
		if self.taskList[2] then
			number = number + #self.taskList[2]
		end
		if self.taskList[3] then
			number = number + #self.taskList[3]
		end
	end
	return number
end

--[[--
--更新任务
--]]
function TaskModel:updateTask(data)
	-- local _status = 1
	-- if self.taskList == nil  or #self.taskList == 0 then
	-- 	_status = 0
	-- end

	if data.action == "getlist" then
		self:getList(data)
	else
		self.needSort = false
		self:update(data)
		qy.Event.dispatch(qy.Event.TASK_REWARD_UPDATE)
	end

	-- local _curStatus = 1
	-- if self.taskList == nil  or #self.taskList == 0 then
	-- 	_curStatus = 0
	-- end
	-- if _status ~= _curStatus then
	-- 	qy.Event.dispatch(qy.Event.TASK_REWARD_UPDATE)
	-- end
	--qy.RedDotCommand:emitSignal(qy.RedDotType.M_TASK, qy.tank.model.RedDotModel:isTaskHasRedDot())
end


function TaskModel:getNextTips(_index)
	if _index then
		self.nextTaskIdx = _index
	end
	if self.nextTaskIdx == nil then
		self.nextTaskIdx = 0
	end

	if self.nextTaskIdx >= self:getTaskNum() then
		self.nextTaskIdx = 1
	else
		self.nextTaskIdx = self.nextTaskIdx + 1
	end

	local _listIdx = 1
	local _cellIdx = self.nextTaskIdx
	if #self.taskList[1] < self.nextTaskIdx then
		_listIdx = 2
		_cellIdx = self.nextTaskIdx - #self.taskList[1]
	end

	if #self.taskList[_listIdx] == 0 or self.taskList[_listIdx][_cellIdx] == nil then
		return ""
	else
		if self.taskList[_listIdx][_cellIdx].status == 1 then
			return self.taskList[_listIdx][_cellIdx]:getTaskName() .. qy.TextUtil:substitute(34003)
		else
			return self.taskList[_listIdx][_cellIdx]:getTaskName()
		end
	end
end

--[[--
--获取下一条领奖提示语
--@param #number curIdx 当前显示的提示语下标
--@return 下一条提示语和下标 为nil时没有领取的奖励
--]]
-- function TaskModel:getNextRewardTip(curIdx)
-- 	local rewardTips = {}
-- 	if #self.taskList > curIdx then
-- 		for i = curIdx + 1 , #self.taskList do
-- 			if self.taskList[i].status == 1 then
-- 				rewardTips.idx = i
-- 				if self.taskList[i]:getTaskName() then
-- 					rewardTips.txt = self.taskList[i]:getTaskName() .. "【完成】"
-- 					return rewardTips
-- 				else
-- 					return nil
-- 				end
-- 			end
-- 		end
-- 	end

-- 	if #self.taskList > curIdx then
-- 		for i = 1 , curIdx do
-- 			if self.taskList[i].status == 1 then
-- 				rewardTips.idx = i
-- 				if self.taskList[i]:getTaskName() then
-- 					rewardTips.txt = self.taskList[i]:getTaskName() .. "【完成】"
-- 					return rewardTips
-- 				else
-- 					return nil
-- 				end
-- 			end
-- 		end
-- 	end

-- 	rewardTips.idx = -1
-- 	rewardTips.txt = ""
-- 	return rewardTips
-- end

return TaskModel
