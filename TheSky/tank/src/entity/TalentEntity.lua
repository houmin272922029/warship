--[[
    坦克天赋
    Author: Aaron Wei
    Date: 2015-04-18 15:09:59
]]

local TalentEntity = qy.class("TalentEntity", qy.tank.entity.BaseEntity)

function TalentEntity:ctor(id)
    local config = qy.Config.talent[tostring(id)]

    self:setproperty("id",id)
    self:setproperty("name",config.name)
    self:setproperty("desc",config.desc)
    -- 攻击加成
    self:setproperty("attack_plus",config.attack_plus)
    -- 防御加成
    self:setproperty("defense_plus",config.defense_plus)
    -- 血量加成
    self:setproperty("blood_plus",config.blood_plus)
    -- 闪避加成千分比
    self:setproperty("dodge_rate",config.dodge_rate)
    -- 暴击加成千分比
    self:setproperty("crit_rate",config.crit_rate)
    -- 命中加成千分比
    self:setproperty("hit_plus",config.hit_plus)
    -- 缴械加成千分比
    self:setproperty("disarm_anti",config.disarm_anti)



end

return TalentEntity
