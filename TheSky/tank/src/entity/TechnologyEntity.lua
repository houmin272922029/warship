--[[
    科技实体
]]
local TechnologyEntity = qy.class("TechnologyEntity", qy.tank.entity.BaseEntity)

function TechnologyEntity:ctor(techData , config)
    self:setproperty("config", config)
    self:update(techData)
end

function TechnologyEntity:update(data)
    self:setproperty("id", data.id)
    self:setproperty("level", data.level)
    self:setproperty("currentExp", data.current_level_exp)
end

--[[--
--是否有红点
--]]
function TechnologyEntity:hasRedDot()
    if self.level < qy.tank.model.UserInfoModel:getMaxTechnologyLevelByUserLevel() then
    	return true
    else
    	return false
    end
end

return TechnologyEntity