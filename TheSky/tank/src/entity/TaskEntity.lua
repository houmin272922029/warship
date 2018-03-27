--[[
    任务
    Author: H.X.Sun
    Date: 2015-05-11
]]

local TaskEntity = qy.class("TaskEntity", qy.tank.entity.BaseEntity)

function TaskEntity:ctor(data)
	self:setproperty("task_id", data.task_id)
	self:setproperty("complete_times", data.complete_times)
	--0未完成 1未领取 2已领取
	self:setproperty("status", data.status)
	self:setproperty("type", data.type)
	self:setproperty("task_id", data.task_id)
	self:setproperty("name", data.name)
	-- 日常任务：1； 一次性任务 ：2；随机任务：3
	self:setproperty("category", data.category) 
	--排序idx
	self:setproperty("sortIndex", data.sortIndex) 
	if data.round_type then
		self:setproperty("round_type", data.round_type)
	end 
end

--[[--
--获取任务内容
--]]
function TaskEntity:getContent()
	return  qy.Config[self.name][self.task_id .. ""].content
end

--[[--
--获取每周，每日任务
--]]
function TaskEntity:getRoundType()
	return  qy.Config.daily_task[self.task_id .. ""].round_type
end

--[[--
--获取奖励信息
--]]
function TaskEntity:getAward()
	local totolAward = {}
	local award = qy.Config[self.name][self.task_id .. ""].award
	if self:getExp() > 0  then
		local exp = {["num"] = self:getExp(), ["type"] = -1, ["id"] = 0}
		table.insert(totolAward, exp)
		for i = 1, #award do
			table.insert(totolAward, award[i])
		end
	else
		totolAward = award
	end
	return totolAward
end

--[[--
--获取指挥官经验
--]]
function TaskEntity:getExp()
	if qy.Config[self.name][self.task_id .. ""].exp == nil then
		return 0
	else
		return qy.Config[self.name][self.task_id .. ""].exp 
	end
end

--[[--
--获取任务icon
--]]
function TaskEntity:getIcon()
	-- print("task_id_==" .. self.task_id)
	-- print("name_==" .. self.name)
	-- print(qy.json.encode(qy.Config[self.name][self.task_id .. ""]))
	local iconId = qy.Config[self.name][self.task_id .. ""].img
	return "Resources/common/icon/task/" ..iconId .. ".jpg"
end

--[[--
--获取任务需要完成的次数
--]]
function TaskEntity:getNeedCompleteTimes()
	return qy.Config[self.name][self.task_id .. ""].arg
end

--[[--
--获取任务icon
--]]
function TaskEntity:getTaskName()
	if self.category == 2 then
		--一次性任务，到分组里面取名字
		local taskGroupId = qy.Config[self.name][self.task_id .. ""].task_group
		--print("taskGroupId==" .. taskGroupId)
		return qy.Config.one_times_task_group[taskGroupId .. ""].name
	else
		return qy.Config[self.name][self.task_id .. ""].name
		-- return self.task_id
	end
end

--[[--
--获取界面跳转ID
--]]
function TaskEntity:getViewId()
	return qy.Config[self.name][self.task_id .. ""].view_id
end

return TaskEntity