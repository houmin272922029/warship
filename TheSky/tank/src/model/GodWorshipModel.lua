--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local GodWorshipModel = qy.class("GodWorshipModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel

function GodWorshipModel:init(data)
	self.data_data = data
	self.award_list = {}
	self:update(data)
end

function GodWorshipModel:initGame( data )
	self.game = data
end

function GodWorshipModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	if _data.activity_info.activity_info then
		data = _data.activity_info.activity_info
	end


	self.times = data.times or self.times
	self.awarded = data.awarded or self.awarded
	self.worship = data.worship or self.worship
	self.click = data.click
	self.extends_data = data.extends_data or self.extends_data

	if _data.activity_info.strongest_champion then
		self.userinfo = _data.activity_info.strongest_champion
	end

end



return GodWorshipModel