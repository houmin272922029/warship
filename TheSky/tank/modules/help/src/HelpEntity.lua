--[[
	-- 
    Date: 2015-12 - 9
]]

local HelpEntity = qy.class("HelpEntity", qy.tank.entity.BaseEntity)

function HelpEntity:ctor(data)
	self:setproperty("id", data.id)
	self:setproperty("title1", data.title1)
	self:setproperty("title2", data.title2)
	self:setproperty("title3", data.title3)
	self:setproperty("icon", data.icon)
end

return HelpEntity