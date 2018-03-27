--[[
关卡机制  关卡
]]

local AchievementEntity = qy.class("AchievementEntity", qy.tank.entity.BaseEntity)

function AchievementEntity:ctor(data)
    self:setproperty("id", data.id)
    self:setproperty("name", data.name)
    self:setproperty("order", data.order)
    self:setproperty("tank1", data.tank1)
    self:setproperty("tank2", data.tank2)
    self:setproperty("tank3", data.tank3)
    self:setproperty("tank4", data.tank4)
    self:setproperty("tank5", data.tank5)
    self:setproperty("tank6", data.tank6)
    self:setproperty("level", 0)
    self:setproperty("attack", 0)
    self:setproperty("defense", 0)
    self:setproperty("blood", 0)
    self:setproperty("attribute", {})
end

function AchievementEntity:upData(data)
	-- if data.times then
	-- 	self.times_:set(data.times)
	-- end

	-- if data.status then
	-- 	self.status = data.status
	-- end

	-- if data.times_uptime then
	-- 	self.timesUptime_:set(data.times_uptime)
	-- end

    if data.level then
        self.level = data.level
    end                                        
end

-- 此成就对应的属性列表
function AchievementEntity:addAttribute(data)
    table.insert(self.attribute, data)
end

function AchievementEntity:getAttributelist()
    table.sort(self.attribute, function(a, b)
        return a.star < b.star
    end)

    return self.attribute
end


return AchievementEntity