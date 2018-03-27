--[[
    补给 model
    Author: H.X.Sun
    Date: 2015-05-04
]]

local SupplyModel = qy.class("SupplyModel", qy.tank.model.BaseModel)

function SupplyModel:init(data)
    self.supplyData = {}
    self.supplyData.supply_num = data.supply_num
    self.supplyData.supply_uplimit = data.supply_uplimit
end

--[[--
--获取补给信息
--]]
function  SupplyModel:getSupplyInfo(data)
    self.supplyData = data
end

--[[--
--补给操作
--]]
function SupplyModel:supplyOperation(data)
    self.award = data.award
    self.supplyData.supply_num = data.supply_num
    self.supplyData.strong_supply = data.strong_supply
    self.eventId = data.id
    self.exp = data.user_exp
    self.earnings = data.earnings

    self.tankEntity = qy.tank.entity.TankEntity.new(qy.Config.supply[self.eventId .. ""].event_img)

    qy.RedDotCommand:emitSignal(qy.RedDotType.M_SUPPLY, qy.tank.model.RedDotModel:isSupplyHasRedDot())
    qy.tank.command.AwardCommand:add(self.award)
    qy.Event.dispatch(qy.Event.SUPPLY_NUM_UPDATE)
end

--[[--
--获取奖励
--]]
function SupplyModel:getSupplyAward()
    return self.award
end

--[[--
--获取补给次数的显示和强补消耗
--]]
function SupplyModel:getSupplyTxt()
    if self.supplyData.supply_num and self.supplyData.supply_num > 0 then
        --补给次数大于0, 返回剩余补给次数
        return self.supplyData.supply_num .. "/" .. self.supplyData.supply_uplimit
    else
        --补给次数小于0, 返回强补消耗(最高消耗25)
        return  " x " .. self:getStrongSupplyConsume()
    end
end

--[[--
--主界面补给次数
--]]
function SupplyModel:getMainViewSupplyTxt()
    if self.supplyData.supply_num and self.supplyData.supply_num > 0 then
        --补给次数大于0, 返回剩余补给次数
        return self.supplyData.supply_num .. "/" .. self.supplyData.supply_uplimit
    else
        return  qy.TextUtil:substitute(33011)
    end
end

--[[--
--获取剩余补给次数
--]]
function SupplyModel:getRemainSupplyNum()
    if self.supplyData.supply_num then
        return self.supplyData.supply_num
    else
        return 0
    end
end

--[[--
--获取强补消耗钻石数
--]]
function SupplyModel:getStrongSupplyConsume()
    if not self.supplyData.strong_supply then
        return 1
    elseif self.supplyData.strong_supply + 1 < 25 then
        return  self.supplyData.strong_supply + 1
    else
        return 25
    end
end

--[[--
--获取增加银币
--]]
function SupplyModel:getAddSliver()
    if self.award and #self.award > 0 then
        return "+ " .. self.award[1].num
    else
        return "+ 0"
    end
end

function SupplyModel:getEarnings()
    if self.earnings then
        return self.earnings
    else
        return ""
    end
end

--[[--
--获取增加经验
--]]
function SupplyModel:getAddExp()
    if self.exp and self.exp.add_exp then
        return "+ " .. self.exp.add_exp
    else
        return "+ 0"
    end
end

--[[--
--获取事件描述
--]]
function SupplyModel:getDescribe()
    return qy.Config.supply[self.eventId .. ""].describe
end

function SupplyModel:getSupplyIcon()
    -- return  qy.tank.model.GarageModel:getTankIconByTankId(19)
    -- return  qy.tank.model.GarageModel:getTankIconByTankId(qy.Config.supply[self.eventId .. ""].event_img) 
    return self.tankEntity:getIcon()
end

function SupplyModel:getTankName()
    -- return  qy.tank.model.GarageModel:getTankNameByTankId(qy.Config.supply[self.eventId .. ""].event_img)
    return self.tankEntity.name
end

--[[--
--是否是特殊事件
--]]
function SupplyModel:isSpecialEvent()
    if qy.Config.supply[self.eventId .. ""].event_type == 2 then
        return true
    else
        return false
    end
end

return SupplyModel