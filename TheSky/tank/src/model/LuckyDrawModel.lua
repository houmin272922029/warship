--[[
	VIP数据模型
	Author: Your Name
	Date: 2015-06-13 15:04:55
]]

local LuckyDrawModel = qy.class("LuckyDrawModel", qy.tank.model.BaseModel)


local StringUtil = qy.tank.utils.String
local ColorMapUtil = qy.tank.utils.ColorMapUtil

function LuckyDrawModel:init(date)
	self.awardList = {}--奖励表
	for k,v in pairs(qy.Config.tiger_machine) do
		table.insert(self.awardList,v)
	end
	table.sort( self.awardList, function ( a,b )
		return a.id < b.id
	end )
	self.ranklist = {}
		for k,v in pairs(qy.Config.tiger_machine_rank) do
		table.insert(self.ranklist,v)
	end
	table.sort( self.ranklist, function ( a,b )
		return a.id < b.id
	end )
	self.start_time = date.activity_info.start_time
	self.end_time = date.activity_info.end_time
	self.last_free_times  = date.activity_info.last_free_times 
	
end
function LuckyDrawModel:initRanklist( date )
	self.endranklist = date.rank_list
	self.my_rank = date.my_rank
	self.my_score = date.score
	self.get_award = date.get_rank_award--奖励领取状态

end
function LuckyDrawModel:initawarddata( date )
	self.machine_result = date.machine_result
	self.cool_info = date.cool_info
end


return LuckyDrawModel
