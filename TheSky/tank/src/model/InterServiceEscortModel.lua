--[[--
	押运 model
	Author: mingming
--]]

local InterServiceEscortModel = qy.class("InterServiceEscortModel", qy.tank.model.BaseModel)

InterServiceEscortModel._rescource = {
	["1"] = qy.TextUtil:substitute(44001),
	["2"] = qy.TextUtil:substitute(44002),
	["3"] = qy.TextUtil:substitute(44003),
	["4"] = qy.TextUtil:substitute(44004),
	["5"] = qy.TextUtil:substitute(44005),
}
function InterServiceEscortModel:init(data)
	self.list = data.escort_list.list
	self.left_escort_times = data.escort.left_escort_times
	self.left_rob_times = data.escort.left_rob_times

	self.status = data.escort.status
	self.award = data.award
	--self.count = math.ceil(data.escort_list.count / 20)
	self.count = 100

	--self.appointQuality = data.escort.appoint.quality
	--self.appointTimes = data.escort.appoint_times
	self.appointQuality = (data.escort.current_goods_id - 1) % 5 + 1
	self.appointTimes = 3 - data.escort.refresh_times > 0 and 3 - data.escort.refresh_times or 0
	self.current_goods_id = data.escort.current_goods_id
	self.log_new = data.log_new or 0

	self.page = 1

	self.teamPage = 1
	self.teamCount = 1


	--self.remind_list = data.remind_list or {}
	-- self.award = data.award
	self.endTime = data.escort.end_time
	self.appoint_time = data.appoint_time
end

function InterServiceEscortModel:update(data)    
	if data.escort_list then
		self.list = data.escort_list.list

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
		self.appointQuality = (data.escort.current_goods_id - 1) % 5 + 1
		self.current_goods_id = data.escort.current_goods_id
		self.appointTimes = 3 - data.escort.refresh_times > 0 and 3 - data.escort.refresh_times or 0
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

	self.log_new = data.log_new or 0
	-- if data.remind_list then
	-- 	self.remind_list = data.remind_list
	-- end
end

function InterServiceEscortModel:getNextPage()
	if self.page + 1 > self.count then
		self.page = self.page
	else
		self.page = self.page + 1
	end
	return self.page
end

function InterServiceEscortModel:getPrePage()
	if self.page - 1 < 1 then
		self.page = self.page
	else
		self.page = self.page - 1
	end
	return self.page
end

function InterServiceEscortModel:atRescoursById(idx)
	local staticData2 = qy.Config.interservice_escort
	local goods = {}
	for i, v in pairs(staticData2) do
		table.insert(goods, v)
	end

	table.sort(goods,function(a,b)
		return tonumber(a.goods_id) < tonumber(b.goods_id)
	end)

	return goods[idx]
end


function InterServiceEscortModel:atRescours(idx, level)
	local staticData = qy.Config.interservice_escort_level
	local staticData2 = qy.Config.interservice_escort
	if level == nil then
		level = qy.tank.model.UserInfoModel.userInfoEntity.level
	end

	local lv = 1

	for i, v in pairs(staticData) do
		if v.min <= level and v.max >= level then
			lv = v.id
		end
	end


	local goods = {}
	for i, v in pairs(staticData2) do
		if v.level_id == lv then
			table.insert(goods, v)
		end
	end

	table.sort(goods,function(a,b)
		return tonumber(a.goods_id) < tonumber(b.goods_id)
	end)


	return goods[idx]
end

function InterServiceEscortModel:setList(data)
	self.teamList = data.team_list
	self.teamCount = math.ceil(table.nums(self.teamList) / 20)
end

function InterServiceEscortModel:testStatus()
	return self.status == 0 or self.status == 1
end

function InterServiceEscortModel:setLog(data)
	self.log = data.log
end

-- 下一页组队
function InterServiceEscortModel:nextTeamPage()
	if self.teamPage + 1 <= 5 then
		self.teamPage = self.teamPage + 1
	else
		self.teamPage = 5
	end
end

-- 上一页组队
function InterServiceEscortModel:preTeamPage()
	if self.teamPage - 1 < 1 then
		self.teamPage = 1
	else
		self.teamPage = self.teamPage - 1
	end
end

return InterServiceEscortModel
