--[[
	军奥会
	Author: Aaron Wei
	Date: 2016-09-12 15:18:23
]]

local OlympicModel = class("OlympicModel", qy.tank.model.BaseModel)

OlympicModel.key = nil
OlympicModel.times = nil
OlympicModel.source = 0
OlympicModel.sourceLabel = nil

function OlympicModel:init(data)
	self.free1 = data.activity_info.activity_info.game["100"].num
	self.free2 = data.activity_info.activity_info.game["200"].num

	self.pay1 = data.activity_info.activity_info.game["100"].pay_num
	self.pay2 = data.activity_info.activity_info.game["200"].pay_num
	
	self.join1 = data.activity_info.activity_info.game["100"].join_num
	self.join2 = data.activity_info.activity_info.game["200"].join_num

	self.diamond1 = data.activity_info.activity_info.game["100"].diamond
	self.diamond2 = data.activity_info.activity_info.game["200"].diamond

	self.start_time = data.activity_info.activity_info.start_time
	self.end_time = data.activity_info.activity_info.end_time
	self.award_start_time = data.activity_info.activity_info.award_start_time
	self.award_end_time = data.activity_info.activity_info.award_end_time

	self.source = data.activity_info.activity_info.source
end


function OlympicModel:updateJoin(data)
	self.free1 = data.game["100"].num
	self.free2 = data.game["200"].num

	self.pay1 = data.game["100"].pay_num
	self.pay2 = data.game["200"].pay_num
	
	self.join1 = data.game["100"].join_num
	self.join2 = data.game["200"].join_num

	self.diamond1 = data.game["100"].diamond
	self.diamond2 = data.game["200"].diamond
end


function OlympicModel:initRankList(data)
	self.rank_list = data.list
	self.my_rank = data.rank
	self.total_score = data.source
end

function OlympicModel:getScore(_type,num)
	self.type = _type
	self.num = num
	if _type == 200 then
		if num >= 3 then
			self.score = 20
			return 20
		else
			self.score = 10
			return 10
		end
	elseif _type == 100 then
		if num >= 35 then
			self.score = 30
			return 30
		else
			self.score = 20
			return 20
		end
	end
end


function OlympicModel:isWin()
	if self.type == 100 then
		if self.num >= 35 then
			return true
		else
			return false
		end
	elseif self.type == 200 then
		if self.num >= 3 then
			return true
		else
			return false
		end
	end 
end


function OlympicModel:getRankAwardList()
	local config = qy.Config.junaohui_rank
	local arr = {}
	for k,v in pairs(config) do
		table.insert(arr,v)
	end

	table.sort(arr,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	self.rankAwardList = arr
	return arr
end


function OlympicModel:updateGoods(data)
	self.goodList = data.goodlist
	self.awards = data.award
	self.source = data.source
	self.sourceLabel:setString(self.source.." 积分")
end	

return OlympicModel
