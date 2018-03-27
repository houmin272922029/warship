--[[
	Author: lj
	Date: 2016年08月05日15:02:46
]]

local MergeCarnialModel = qy.class("MergeCarnialModel", qy.tank.model.BaseModel)


function MergeCarnialModel:init(datas )
	self.DayRedPoint = {
		["1"] = 0,
		["2"] = 0,
		["3"] = 0,
		["4"] = 0,
		["5"] = 0,
		["6"] = 0,
		["7"] = 0
	}
	self.TaskRedPoint = {
		["1"] = 0,
		["2"] = 0,
		["3"] = 0,
		["4"] = 0,
	}
	
	local data = datas.activity_info
	self.daycfg = qy.Config.merge_carnival_task--本地表每天都有什么任务
	self.taskcfg = qy.Config.merge_carnival--具体任务表
	self.day =  data.current_day --当前第几天
	self.endtime = data.end_time
	self.tasklist = data.list
	table.sort(self.tasklist, function(a, b)
           return a.id < b.id
    end)
	self:updateDayRedPoint()
	self:updateTaskRedPoint(self.day)

end
function MergeCarnialModel:update( taskid )
	self.tasklist[taskid..""].status = -1
end
function MergeCarnialModel:updateDayRedPoint(  )
	local tempnum = self.day > 7 and 7 or self.day
	for i=1,tempnum do
		local list  = {}
		for k,v in pairs(self.taskcfg) do
			if v.day_num == i and v.type ~= 18 then
				table.insert(list,v)
			end
		end
		local num = 0
		for j=1,#list do
			if self.tasklist[tostring(list[j].task_id)].status == 1 then
				num = num + 1
			end
		end
		if num > 0 then
			self.DayRedPoint[tostring(i)] = 1
		else
			self.DayRedPoint[tostring(i)] = 0
		end
	end
end
function MergeCarnialModel:updateTaskRedPoint( day )
	for i=1,4 do
		local list  = {}
		for k,v in pairs(self.taskcfg) do
		  	local x = v.group_id
            if v.group_id%4 == 0 then
                x = 4
            else
                x = v.group_id%4
            end
			if v.day_num == day and x == i then
				table.insert(list,v)
			end
		end
		local num = 0
		for j=1,#list do
			if self.tasklist[tostring(list[j].task_id)].status == 1 then
				num = num + 1
			end
		end
		if num > 0 then
			self.TaskRedPoint[tostring(i)] = 1
		else
			self.TaskRedPoint[tostring(i)] = 0
		end
	end
end
function MergeCarnialModel:getDaydate( taskid )
	local list  = {}
	for i,v in pairs(self.taskcfg) do
		if v.group_id == taskid then
			table.insert(list,v)
		end
	end
	table.sort(list, function(a, b)
		return a.task_id < b.task_id
	end)
	 return list
end




return MergeCarnialModel