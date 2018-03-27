--[[
    军团 entity
    Author: H.X.Sun
]]
local LegionEntity = qy.class("LegionEntity", qy.tank.entity.BaseEntity)

local model = qy.tank.model.LegionModel

function LegionEntity:ctor(data)
    --等级
    self:setproperty("level",data.level or 0)
    --id
    self:setproperty("id",data.id)
    --司令名
    self:setproperty("boss_name",data.boss_name or "")
    --司令id
    self:setproperty("boss_kid",data.boss_kid or "")
    --是否申请 true
    self:setproperty("is_apply",data.is_apply or false)
    --用户数
    self:setproperty("user_count",data.user_count or 0)
    --经验
    self:setproperty("exp",data.exp or 0)
    --排名
    self:setproperty("rank",data.rank or 0)
    --名字
    self:setproperty("name",data.name or "")
    --创建时间
    self:setproperty("create_t",data.create_t or 0)
    --最大人数
    self:setproperty("user_max",data.user_max or 50)
    --公告
    if data.notice == nil or data.notice == "" then
        self.notice = qy.TextUtil:substitute(53022)
    else
        self.notice = data.notice
    end
end

function LegionEntity:update(data)
    if data.level then
        self.level = data.level
    end
    if data.id then
        self.id = data.id
    end
    if data.boss_name then
        self.boss_name = data.boss_name
    end
    if data.boss_kid then
        self.boss_kid = data.boss_kid
    end
    if data.is_apply then
        self.is_apply = data.is_apply
    end
    if data.user_count then
        self.user_count = data.user_count
    end
    if data.exp then
        self.exp = data.exp
    end
    if data.rank  then
        self.rank = data.rank
    end
    if data.name then
        self.name = data.name
    end
    if data.create_t then
        self.create_t = data.create_t
    end
    if data.user_max then
        self.user_max = data.user_max
    end
    if data.notice then
        self.notice = data.notice
    end
end

function LegionEntity:updateCount(_num)
    self.user_count = _num
end

function LegionEntity:updateApply(_flag)
    self.is_apply = _flag
end

function LegionEntity:getExpPerNum()
    local data = qy.Config.legion_level[tostring(self.level)]
    if data then
        return self.exp / data.exp * 100
    else
        return 100
    end
end

function LegionEntity:getExpPerDesc()
    local data = qy.Config.legion_level[tostring(self.level)]
    if data then
        return self.exp .. "/" .. data.exp
    else
        return ""
    end
end

function LegionEntity:getCountDesc()
    return self.user_count .. "/" .. self.user_max
end

function LegionEntity:getCountColor()
    if self:isFull() then
        return cc.c4b(248, 19, 2, 255)
    else
        return cc.c4b(2, 250, 4, 255)
    end
end

function LegionEntity:isFull()
    if self.user_count < self.user_max then
        return false
    else
        return true
    end
end

function LegionEntity:getRankIcon()
    local str = "legion/res/basic/"
    if self.rank == 1 then
        return str .. "q1.png"
    elseif self.rank == 2 then
        return str .. "q2.png"
    elseif self.rank == 3 then
        return str .."q3.png"
    else
        return str .. "q4.png"
    end
end

function LegionEntity:getRankDesc()
    if self.rank == 1 or self.rank == 2 or self.rank == 3 then
        return ""
    else
        return qy.TextUtil:substitute(53023, self.rank)
    end
end

return LegionEntity
