--[[
    说明: 用户信息实体
]]

local UserInfoEntity = qy.class("UserInfoEntity", qy.tank.entity.BaseEntity)

function UserInfoEntity:ctor(userinfo)
    self.model = qy.tank.model.UserInfoModel
    self:updateBaseInfo(userinfo.baseinfo)
    self:updateRecharge(userinfo.recharge)
    self:updateResource(userinfo.resource)
    self:updateLegionInfo(userinfo.legion)

    -- 战队升级需要的经验
    self:setproperty("needExp",0)
end

--更新用户基本信息
function UserInfoEntity:updateBaseInfo(baseInfo)
    -- 等级
    self:bindProperty("level", baseInfo.level, function(level)
        if self.userLevelChange then
            self.userLevelChange = false
            qy.RedDotCommand:initMainViewRedDot()
        end
    end, function(silver, oldValue, newValue)
        if oldValue ~= newValue then
            self.userLevelChange = true
            -- qy.RedDotCommand:initMainViewRedDot()
        end
    end)
    -- 昵称
    self:setproperty("name", baseInfo.nickname)
    -- kid
    self:setproperty("kid", baseInfo.kid)
    -- uid
    self:setproperty("uid", baseInfo.uid)
    -- 经验
    self:setproperty("exp", baseInfo.exp)
    -- 原本战斗力
    self.oldfight_power = self.fightPower or baseInfo.fight_power

    --战斗力
    self:setproperty("fightPower", baseInfo.fight_power)
    --头像
    self:setproperty("headicon", baseInfo.headicon)
end

--更新资源信息
function UserInfoEntity:updateResource(resource)
    --银币
    self:bindProperty("silver", resource.silver,function(silver, oldValue, newValue)
        if oldValue ~= newValue then
            if oldValue > newValue then
                --减少了
                table.insert(self.model:getSubtractResourceType(), qy.tank.view.type.ResourceType.SILVER)
            elseif oldValue < newValue then
                --增加了
                table.insert(self.model:getAddResourceType(), qy.tank.view.type.ResourceType.SILVER)
            end
        end
    end)

    -- 上一次体力更新时间
    self:bindProperty("energy_uptime", resource.energy_uptime,function(energy, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)

    self:setproperty("energy_server", resource.energy)
    -- 体力
    local energyNum = 0
    if resource.energy > self.model:getEnergyLimitByVipLevel(self.vipLevel_:get()) then
        energyNum = resource.energy
    elseif (resource.energy + math.floor((self.model.serverTime - resource.energy_uptime) / 240)) < self.model:getEnergyLimitByVipLevel(self.vipLevel_:get()) then
        energyNum = resource.energy + math.floor((self.model.serverTime - resource.energy_uptime) / 240)
    else
        energyNum = self.model:getEnergyLimitByVipLevel(self.vipLevel_:get())
    end

    self:bindProperty("energy", energyNum,function(energy, oldValue, newValue)
        if oldValue ~= newValue then
            qy.Event.dispatch(qy.Event.CLIENT_ENERGY_UPDATE)
            if oldValue > newValue then
                --减少了
                table.insert(self.model:getSubtractResourceType(), qy.tank.view.type.ResourceType.ENERGY)
            elseif oldValue < newValue then
                --增加了
                table.insert(self.model:getAddResourceType(), qy.tank.view.type.ResourceType.ENERGY)
            end
        end
    end)

      -- 经验卡
    self:bindProperty("expCard", resource.exp_card,function(expCard, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.EXP_CARD)
        end
    end)

    -- 科技书
    self:bindProperty("technologyHammer", resource.technology_hammer,function(technologyHammer, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.TECHNOLOGY_HAMMER)
        end
    end)

    -- 蓝铁
    self:bindProperty("blueIron", resource.blue_iron,function(blueIron, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.BLUE_IRON)
        end
    end)

    -- 紫铁
    self:bindProperty("purpleIron", resource.purple_iron,function(purpleIron, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.PURPLE_IRON)
        end
    end)

    -- 橙铁
    self:bindProperty("orangeIron", resource.orange_iron,function(orangeIron, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.ORANGE_IRON)
        end
    end)

    -- 远征币
    self:bindProperty("expeditionCoins", resource.expedition_coins,function(expeditionCoins, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.EXPEDITION_COINS)
        end
    end)

    -- 威士忌（军械箱）
    self:bindProperty("whisky", resource.whisky,function(whisky, oldValue, newValue)
        -- if oldValue ~= newValue then
        --     table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.WHISKY)
        -- end
    end)

    -- 橙铁
    self:bindProperty("advanceMaterial", resource.advance_material,function(advanceMaterial, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.ORANGE_IRON)
        end
    end)

    -- 威望
    self:bindProperty("prestige", resource.prestige,function(prestige, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.EXPEDITION_COINS)
        end
    end)

    -- 军魂碎片
    self:bindProperty("soul_fragment", resource.soul_fragment,function(soul_fragment, oldValue, newValue)
        if oldValue ~= newValue then
            -- table.insert(self.updateResourceType, qy.tank.view.type.ResourceType.EXPEDITION_COINS)
        end
    end)

    -- 兑奖券
    self:bindProperty("ticket", resource.ticket,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)

    -- 声望
    self:bindProperty("reputation", resource.reputation,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
      -- 军功
    self:bindProperty("military_exploit", resource.military_exploit,function(military_exploit, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
    -- 角斗币
    self:bindProperty("arena_coin", resource.arena_coin or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)

    -- 陶瓷装甲
    self:bindProperty("ceramics_armor", resource.reform_essence or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
    -- 聚变水晶
    self:bindProperty("ucrystal", resource.ucrystal or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
    -- 裂变水晶
    self:bindProperty("icrystal", resource.icrystal or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
      -- 重铸液
    self:bindProperty("afliquid", resource.afliquid or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
    -- 精铸液
    self:bindProperty("exliquid", resource.exliquid or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
      -- 日耀
    self:bindProperty("gcert", resource.gcert or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
      -- 月华
    self:bindProperty("scert", resource.scert or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
       -- 进修手册
    self:bindProperty("study_handbook", resource.study_handbook or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
       -- 精铁
    self:bindProperty("fine_iron", resource.fine_iron or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
       -- 熔炼积分
    self:bindProperty("smelting_integral", resource.smelting_integral or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
        -- 洗练石
    self:bindProperty("polish_stone", resource.polish_stone or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
        -- 萃取器
    self:bindProperty("extractor", resource.extractor or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
        -- 突破石
    self:bindProperty("break_stone", resource.break_stone or 0,function(ticket, oldValue, newValue)
        if oldValue ~= newValue then
        end
    end)
end

--更新recharge相关
function UserInfoEntity:updateRecharge(recharge)
    -- 钻石
    self:bindProperty("diamond", recharge.diamond,function(diamond, oldValue, newValue)
        if oldValue ~= newValue then
            if oldValue > newValue then
                --减少了
                table.insert(self.model:getSubtractResourceType(), qy.tank.view.type.ResourceType.DIAMOND)
            elseif oldValue < newValue then
                --增加了
                table.insert(self.model:getAddResourceType(), qy.tank.view.type.ResourceType.DIAMOND)
            end
        end
    end)

    -- VIP
    self:setproperty("vipLevel", recharge.vip_level)
    self:setproperty("isDrawDaily", recharge.is_draw_daily)

    -- 充值
    self:setproperty("amount", recharge.amount)

    -- 充值奖励
    self:setproperty("gift", recharge.gift or {})
    --充值的钻石数
    self:setproperty("payment_diamond_added", recharge.payment_diamond_added + (recharge.amount_diamond_extra or 0))
end

--获取格式化银币字符串
function UserInfoEntity:getSilverStr()
    return qy.InternationalUtil:getResNumString(self.silver)
end

--获取格式化后的钻石字符串
function UserInfoEntity:getDiamondStr()
   return qy.InternationalUtil:getResNumString(self.diamond)
end

--获取格式化后体力
function UserInfoEntity:getEnergyStr()
   return qy.InternationalUtil:getResNumString(self.energy)
end

--蓝铁
function UserInfoEntity:getBlueIronStr()
   return qy.InternationalUtil:getResNumString(self.blueIron)
end

--紫铁
function UserInfoEntity:getPurpleIronStr()
   return qy.InternationalUtil:getResNumString(self.purpleIron)
end

--橙铁
function UserInfoEntity:getOrangeIronStr()
   return qy.InternationalUtil:getResNumString(self.orangeIron)
end

-- 兑奖券
function UserInfoEntity:getTicketStr()
   return qy.InternationalUtil:getResNumString(self.ticket)
end

-- 陶瓷装甲
function UserInfoEntity:getCeramicsArmorStr()
   return qy.InternationalUtil:getResNumString(self.ceramics_armor)
end


-- 设置军团信息
function UserInfoEntity:updateLegionInfo(legionInfo)
    -- 昵称
    self:setproperty("legionName", legionInfo and legionInfo.legion_name or qy.TextUtil:substitute(90019))
    self:setproperty("legionId", legionInfo and legionInfo.legion_id or 0)
end

-- 获取军团名
function UserInfoEntity:getLegionName()
    return self.legionName
end

-- 军团名制空
function UserInfoEntity:clearLegionName()
    self:setproperty("legionName", qy.TextUtil:substitute(90019))
end
return UserInfoEntity
