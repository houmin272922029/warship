--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local EndlessWarModel = qy.class("EndlessWarModel", qy.tank.model.BaseModel)


function EndlessWarModel:init(data)


	self.totallist = {}

	local staticData = qy.Config.endless_war_checkpoint--关卡表
	self.mosterdata = qy.Config.endless_war_monster

	for i, v in pairs(staticData) do
		table.insert(self.totallist, v)
	end
	table.sort(self.totallist, function(a, b)
    	return a.checkpoint_id < b.checkpoint_id
  	end)
	self.checkpoint_id = data.boss_id
	self.buytimes = data.speed_times
	self.score = data.spoils


end
function EndlessWarModel:update( data )
	self.checkpoint_id = data.boss_id
	self.buytimes =data.speed_times
	self.score = data.spoils
end
function EndlessWarModel:getdataByid(  )
	return self.totallist[self.checkpoint_id]
end
function EndlessWarModel:initRankList( data )
	self.myrank = data.my_rank
	self.ranklist = data.rank_list
end
function EndlessWarModel:getnumByvip(  )
	local data = qy.tank.model.VipModel:getEndlessBuyTimes()
	local viplevel = qy.tank.model.UserInfoModel.userInfoEntity.vipLevel
	local num = data[viplevel] + 3
	return num
end



return EndlessWarModel