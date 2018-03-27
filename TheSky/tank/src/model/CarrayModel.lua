--[[--
	押运 model
	Author: mingming
--]]

local CarrayModel = qy.class("CarrayModel", qy.tank.model.BaseModel)

CarrayModel._rescource = {
	["1"] = qy.TextUtil:substitute(44001),
	["2"] = qy.TextUtil:substitute(44002),
	["3"] = qy.TextUtil:substitute(44003),
	["4"] = qy.TextUtil:substitute(44004),
	["5"] = qy.TextUtil:substitute(44005),
}
function CarrayModel:init(data)
	self.list = data.escort_list.list
	self.left_escort_times = data.escort.left_escort_times
	self.left_rob_times = data.escort.left_rob_times

	self.status = data.escort.status
	self.award = data.award
	self.count = math.ceil(data.escort_list.count / 4)

	self.appointQuality = data.escort.appoint.quality
	self.appointTimes = data.escort.appoint_times
	self.page = 1

	self.legion = data.legion

	self.page = 1
	self.teamPage = 1
	self.teamCount = 1

	self.remind_list = data.remind_list
	self.award = data.award
	self.endTime = data.escort.end_time
end

function CarrayModel:update(data)
	if data.escort_list then
		self.list = data.escort_list.list
		self.count = math.ceil(data.escort_list.count / 4)

		self.page = self.page >= self.count and self.count or self.page
		if self.page < 1 then
			self.page = 1
		end
	end
	if data.escort then
		self.left_escort_times = data.escort.left_escort_times
		self.left_rob_times = data.escort.left_rob_times
		self.status = data.escort.status
		self.oldQuality = self.appointQuality
		self.appointQuality = data.escort.appoint.quality
		self.appointTimes = data.escort.appoint_times
		self.endTime = data.escort.end_time
	end
	if data.team_list then
		self:setList(data)
	end

	if data.log then
		self:setLog(data)
	end

	if data.legion then
		self.legion = data.legion
	end

	if data.remind_list then
		self.remind_list = data.remind_list
	end
end

function CarrayModel:getNextPage()
	if self.page + 1 > self.count then
		self.page = self.page
	else
		self.page = self.page + 1
	end
	return self.page
end

function CarrayModel:getPrePage()
	if self.page - 1 < 1 then
		self.page = self.page
	else
		self.page = self.page - 1
	end
	return self.page
end

function CarrayModel:atRescours(idx)
	local staticData = qy.Config.legion_escort_goods
	return staticData[tostring(idx)]
end

function CarrayModel:setList(data)
	self.teamList = data.team_list
	self.teamCount = math.ceil(table.nums(self.teamList) / 4)
end

function CarrayModel:testStatus()
	return self.status == 0 or self.status == 1
end

function CarrayModel:setLog(data)
	self.log = data.log
end

-- 下一页组队
function CarrayModel:nextTeamPage()
	if self.teamPage + 1 <= 5 then
		self.teamPage = self.teamPage + 1
	else
		self.teamPage = 5
	end
end

-- 上一页组队
function CarrayModel:preTeamPage()
	if self.teamPage - 1 < 1 then
		self.teamPage = 1
	else
		self.teamPage = self.teamPage - 1
	end
end

return CarrayModel
