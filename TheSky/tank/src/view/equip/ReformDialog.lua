--[[--

--Author: Fu.Qiang  
改代码的，苦了你了，需求最开始不明确，最后代码越写越乱我也懒得缕
--]]--


local ReformDialog = qy.class("ReformDialog", qy.tank.view.BaseDialog, "view/equip/ReformDialog")

local model = qy.tank.model.EquipModel
local service = qy.tank.service.EquipService
local userInfoModel =  qy.tank.model.UserInfoModel
function ReformDialog:ctor(delegate, cell, type, idx)
    ReformDialog.super.ctor(self)
    self.delegate = delegate
    self.type = type
    self.idx = idx

	self:InjectView("Text_title")
	self:InjectView("Text_level")
	self:InjectView("Text_next_level")
    self:InjectView("Text_info1")
    self:InjectView("Text_info2")    
    self:InjectView("Text_info1_num")
    self:InjectView("Text_info2_num")
    self:InjectView("Text_level_name")
    self:InjectView("Text_next_level_name")
    self:InjectView("Text_ps")
    self:InjectView("ps")
    self:InjectView("Text_ceramics_num")
    self:InjectView("Text_consume1")
    self:InjectView("Text_consume2")
    self:InjectView("Text_consume3")
    self:InjectView("Button_reform1")
    self:InjectView("Button_reform2")
    self:InjectView("icon1")
    self:InjectView("icon2")

    self:InjectView("equipBg")
    self:InjectView("equipIcon")

	self:OnClick("Button_close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self.action_flag = false
    self.before_level = -1


    self:OnClick(self.Button_reform2, function(sender)
        if self.Button_reform2:isBright() then
            local entity = self:updateEntity()
            service:reformEquip(entity.unique_id, entity:getComponentEnglishName(), 200,function(data)
                self.action_flag = true
                self:update()
                self:updateEquipInfo(delegate)            
                self:showUtil()
                cell:updateReformAndAdvanceRedDot()
            end)
        end
    end, {["isScale"] = false})


    self:OnClick(self.Button_reform1, function(sender)
        if self.Button_reform1:isBright() then
            local entity = self:updateEntity()
            service:reformEquip(entity.unique_id, entity:getComponentEnglishName(), 100,function(data)     
                self.action_flag = true       
                self:update()
                self:updateEquipInfo(delegate)            
                self:showUtil()
                cell:updateReformAndAdvanceRedDot()
            end)
        end
    end, {["isScale"] = false})
 
    self:update(true)
end


function ReformDialog:updateEntity()
    return model:getEquipEntity(self.type, self.idx)
end


function ReformDialog:update(flag)
    local entity = self:updateEntity()

    local before_level = entity.reform_level - 1 >= 0 and entity.reform_level - 1 or 0
    local level = entity.reform_level
    local next_level = model:getEquipReformByLevel(entity.reform_level + 1) and entity.reform_level + 1 or entity.reform_level

    local consume = model:getEquipReformByLevel(level)
    local consume_num = 0
    local current_exp = 0

    if level == 0 then
        consume_num = model:getEquipReformByLevel(0).sum_exp
    else
        consume_num = model:getEquipReformByLevel(level).sum_exp - model:getEquipReformByLevel(before_level).sum_exp

        if consume_num <= 0 then
            consume_num = 0
        end
    end

    if level == 0 then
        current_exp = entity.reform_essence
    else
        current_exp = entity.reform_essence - model:getEquipReformByLevel(before_level).sum_exp 

        if current_exp <= 0 then
            current_exp = 0
        end
    end

    local function callback()
        self.Text_title:setString(entity:getName())
        self.Text_level:setString(level)
        self.Text_next_level:setString(next_level)

        self.Text_info1:setString(entity:getPropertyReformName())
        self.Text_info2:setString(entity:getPropertyReformName())
        self.Text_info1_num:setString("+"..entity:getPropertyByLevel(level).."%")
        self.Text_info2_num:setString("+"..entity:getPropertyByLevel(next_level).."%")


        self.equipBg:setSpriteFrame(entity:getIconBg())
        self.equipIcon:setTexture(entity:getIcon())

        self.Text_level_name:setString(model:getReformLevelName(level))
        self.Text_next_level_name:setString(model:getReformLevelName(level + 10))

        self.Text_ceramics_num:setString("X "..userInfoModel.userInfoEntity.ceramics_armor)
    end
    
    if flag then
        callback()
    end

    local next_level_exp = model:getEquipReformByLevel(level).sum_exp - entity.reform_essence
    if next_level_exp < 0 then
        next_level_exp = 0
    end

    local current_consume_exp = userInfoModel.userInfoEntity.ceramics_armor > next_level_exp and next_level_exp or userInfoModel.userInfoEntity.ceramics_armor

    

    if userInfoModel.userInfoEntity.ceramics_armor == 0 then
        self.Button_reform1:setBright(false)
        self.Button_reform2:setBright(false)
        self.icon1:setVisible(false)
        self.icon2:setVisible(false)
        self.Text_consume3:setVisible(true)
        self.Text_consume3:setString(qy.TextUtil:substitute(90270))
        self.Text_consume1:setVisible(false)
        self.Text_consume2:setVisible(false)
    elseif next_level_exp == 0 and self:getConsume(entity) == 0 then
        self.Button_reform1:setBright(false)
        self.Button_reform2:setBright(false)
        self.Text_consume1:setVisible(false)
        self.Text_consume2:setVisible(false)
        self.icon1:setVisible(false)
        self.icon2:setVisible(false)
        self.Text_consume3:setVisible(true)
        self.Text_consume3:setString(qy.TextUtil:substitute(90272))
    else
        self.icon1:setVisible(true)
        self.icon2:setVisible(true)
        self.Text_consume1:setString(current_consume_exp * model:getEquipReformByLevel(level).silver)
        self.Text_consume2:setString(self:getConsume(entity))
        self.Text_consume3:setVisible(false)
        self.Text_consume3:setString(qy.TextUtil:substitute(90270))
    end

    if self.action_flag and self.before_level < level and self.before_level ~= -1 and self.before_exp ~= entity.reform_essence then
        self:loadingBarAnim(1, current_exp, consume_num, callback)
    elseif self.action_flag and self.before_level == level and self.before_level ~= -1 and self.before_exp ~= entity.reform_essence then
        self:loadingBarAnim(2, current_exp, consume_num, callback)
    elseif current_exp == 0 and consume_num == 0 then
        self.ps:setScale(1, 1)
        self.Text_ps:setString(model:getEquipReformByLevel(before_level).sum_exp.." / "..model:getEquipReformByLevel(before_level).sum_exp)
    else
        self.ps:setScale(current_exp / consume_num, 1)
        self.Text_ps:setString(current_exp.." / "..consume_num)
    end

    self.before_level = level
    self.before_exp = entity.reform_essence
end



--[[--
--更新装备详情
--]]
function ReformDialog:updateEquipInfo(delegate, _type)
    delegate:setSelectedEquip(model:getEquipEntity(delegate.delegate.type, delegate.selectEquipIdx + 1),_type)

    local _data = model:getAddAttribute()
    qy.tank.utils.HintUtil.showSomeImageToast(_data,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.7))
end


function ReformDialog:getConsume(entity)
    local sum = 0
    local ceramics = userInfoModel.userInfoEntity.ceramics_armor
    local level = entity.reform_level

    if model:getEquipReformByLevel(level).sum_exp == 0 then
        return 0
    elseif model:getEquipReformByLevel(level).sum_exp > ceramics + entity.reform_essence then
        return ceramics * model:getEquipReformByLevel(level).silver 
    end


    while model:getEquipReformByLevel(level + 1) and model:getEquipReformByLevel(level + 1).sum_exp > 0 and model:getEquipReformByLevel(level + 1).sum_exp <= ceramics + entity.reform_essence do
        level = level + 1 
    end

    if model:getEquipReformByLevel(level + 1) and model:getEquipReformByLevel(level + 1).sum_exp > 0 then
        return model:getEquipReformByLevel(level).sum_silver - entity.reform_silver + (ceramics + entity.reform_essence - model:getEquipReformByLevel(level).sum_exp) * model:getEquipReformByLevel(level + 1).silver
    else
        return model:getEquipReformByLevel(level).sum_silver - entity.reform_silver
    end
end



-- 战斗力飘字
function ReformDialog:showUtil()
    local _aData = {}
    local fightPower = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power
    if fightPower and fightPower ~= 0 then
        local numType = 0
        if fightPower > 0 then
            numType = 15
        else
            numType = 14
        end
        _data = {
            ["value"] = fightPower,
            ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
            ["type"] = numType,
            ["picType"] = 2,
         }
        table.insert(_aData, _data)
        qy.tank.utils.HintUtil.showSomeImageToast(_aData,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.6))
    end
end






function ReformDialog:loadingBarAnim(nType, current_exp, consume_num, callback)
    local flag = self.Button_reform1:isBright()
    self.Button_reform1:setBright(false)
    self.Button_reform2:setBright(false)
    self.ps:stopAllActions()
    local num = consume_num > 0 and current_exp / consume_num or 0
    if current_exp == 0 and consume_num == 0 then
        num = 1
    end

    if nType == 1 then
        self.ps:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5, 1, 1), cc.DelayTime:create(0.1), cc.CallFunc:create(function()
            self.ps:setScale(0, 1)
            self.ps:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5, num, 1), cc.CallFunc:create(function()
                self.Button_reform1:setBright(flag)
                self.Button_reform2:setBright(flag)
                self.Text_ps:setString(current_exp.." / "..consume_num)
                callback()
            end)))
        end)))
    else
        self.ps:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5, num, 1),  cc.DelayTime:create(0.1),cc.CallFunc:create(function()
            self.Button_reform1:setBright(flag)
            self.Button_reform2:setBright(flag)
            self.Text_ps:setString(current_exp.." / "..consume_num)
            callback()
        end)))
    end
end



return ReformDialog