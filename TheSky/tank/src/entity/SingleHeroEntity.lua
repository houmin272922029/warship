--[[
    孤胆英雄
    Author: H.X.Sun
    Date: 2015-05-11
]]

local SingleHeroEntity = qy.class("SingleHeroEntity", qy.tank.entity.BaseEntity)

function SingleHeroEntity:ctor(data)
	self:setproperty("checkpoint_id", data.checkpoint_id)
	self:setproperty("icon", data.icon)
	self:setproperty("level", data.level)
	self:setproperty("first_num", data.first_num)
	self:setproperty("name", data.name)
	self:setproperty("num", data.num)
end

return SingleHeroEntity