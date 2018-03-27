--[[
    军团动员 entity
    Author: H.X.Sun
]]
local LeMobilizeEntity = qy.class("LeMobilizeEntity", qy.tank.entity.BaseEntity)

local model = qy.tank.model.LeMobilizeModel

function LeMobilizeEntity:ctor(data)
    --uid
    self:setproperty("unique_id",data.unique_id)
    --id
    self:setproperty("id",data.id)
    --用户ID
    self:setproperty("user_id",data.user_id)
    --发起者
    self:setproperty("name",data.name)
    --数量
    self:setproperty("num",data.num or 0)
    --状态 0:可参加 1:进行中 2:可领奖
    self:setproperty("status",data.status)
    --头像
    self:setproperty("headicon", data.headicon)
    --品质
    self:setproperty("quality",model:getConfigById(self.id).quality)
end

function LeMobilizeEntity:isJoin()
    if self.status == 1 then
        return true
    else
        return false
    end
end

function LeMobilizeEntity:isComplete()
    if model:getConfigById(self.id).params > self.num then
        return false
    else
        return true
    end
end

return LeMobilizeEntity
