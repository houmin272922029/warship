--[[--

--Author: Fu.Qiang 
--]]--


local EquipAdvanceView = qy.class("EquipAdvanceView", qy.tank.view.BaseView, "view/equip/EquipAdvancedView")

local model = qy.tank.model.EquipModel
local service = qy.tank.service.EquipService
local userInfoModel =  qy.tank.model.UserInfoModel
function EquipAdvanceView:ctor(delegate)
    EquipAdvanceView.super.ctor(self)


    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/equipAdvance.png", 
        showHome = false,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)


    self.equip_type = delegate.type    
    self.parent = delegate.parent.delegate

    self.select_equip_unique_id = delegate.unique_id
    self.use_equip_unique_id = 0


	self:InjectView("Button_advance")
	self:InjectView("Text_title")
	self:InjectView("Text_current_level")
    self:InjectView("Text_current_property")
    self:InjectView("Text_next_property")    
    self:InjectView("Text_next_level")
    self:InjectView("Text_2")
    self:InjectView("equipBg")
    self:InjectView("equipBg2")
    self:InjectView("Image_add")
    self:InjectView("equipIcon")
    self:InjectView("equipIcon2")
    self:InjectView("Text_current_level")
    self:InjectView("Text_current_property")
    self:InjectView("Text_next_level")
    self:InjectView("Text_next_property")
    self:InjectView("Text_purple_iron_num")
    self:InjectView("Text_silver_num")
    self:InjectView("advanced_bg")
    self:InjectView("purpleIronTxt")
    self:InjectView("silverTxt")
    self:InjectView("Text_equip_num")

    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_zhuangbeijinjie",function()
        local effect = ccs.Armature:create("ui_fx_zhuangbeijinjie")
        self.advanced_bg:addChild(effect)
        effect:setPosition(233, 125)
        effect:getAnimation():playWithIndex(0)
    end)


    self:OnClick(self.equipBg2, function(sender)
        local entity = self:getEntity()
        if #model:getNoUseEquipEntity(entity) > 0 then
            self.parent.showSelectEquipForAdvance(entity, function(unique_id)
                self.use_equip_unique_id = unique_id
                self:update()
            end, self.use_equip_unique_id)
        else
            qy.hint:show(qy.TextUtil:substitute(90278))
        end
    end, {["isScale"] = false})


    self:OnClick(self.Button_advance, function(sender)
        local entity = self:getEntity()
        if self.use_equip_unique_id > 0 then
            local num = model:testCanAdvance(entity) 
            if num == 1 then
                qy.hint:show(qy.TextUtil:substitute(90283))
            elseif num == 2 then
                local data = model:atAdvanceConsume(entity.advanced_level)
                qy.hint:show(qy.TextUtil:substitute(90285, data.level))
            elseif num == 3 or num == 4 then
                local data = model:atAdvanceConsume(entity.advanced_level)
                service:advanceEquip(entity.unique_id, entity:getComponentEnglishName(), self.use_equip_unique_id,function(data)
                    if data.equip then
                        qy.hint:show(qy.TextUtil:substitute(90279))
                        self.use_equip_unique_id = 0
                        self:showUtil()

                        if data.award then
                            qy.tank.command.AwardCommand:add(data.award)
                            qy.tank.command.AwardCommand:show(data.award)
                        end

                        self:updateEquipInfo(delegate.parent)       
                    end
                    self:update()
                end)
            end            
        else
            qy.hint:show(qy.TextUtil:substitute(90283))
        end
    end, {["isScale"] = false})


    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(34):show(true)
    end, {["isScale"] = false})
 
    self:update()
end


function EquipAdvanceView:getEntity()
    return model:getEquipEntityByUniqueId(self.select_equip_unique_id, self.equip_type)
end




function EquipAdvanceView:update()
    local entity = self:getEntity()

    local level = entity.advanced_level
    local next_level = level + 1 > model:getMaxLevel(entity) and model:getMaxLevel(entity) or level + 1

    self.Text_title:setString(entity:getName())
    self.Text_current_level:setString(level)

    if next_level > level then
        self.Text_next_level:setString(next_level)
        self.Text_next_level:setVisible(true)
    else
        self.Text_2:setString(qy.TextUtil:substitute(90274))
        self.Text_next_level:setVisible(false)
    end

    if not level or level <= 0 then
        self.Text_current_property:setString(qy.TextUtil:substitute(90276))
    else
        local current_data = model:atSpecailAttr(entity, level)        
        local value = model:getAdvanceData(current_data)
        self.Text_current_property:setString(model.attrTypes[tostring(current_data.type)].."+"..value)
    end

    local next_data = model:atSpecailAttr(entity)
    value = model:getAdvanceData(next_data)
    self.Text_next_property:setString(model.attrTypes[tostring(next_data.type)].."+"..value)

    self.equipBg:setSpriteFrame(entity:getIconBg())
    self.equipIcon:setTexture(entity:getIcon())

    self:playMessageAnimation(true)

    if self.use_equip_unique_id and self.use_equip_unique_id > 0 then
        self.equipBg2:loadTexture(entity:getIconBg(), 1)
        self.equipIcon2:setTexture(entity:getIcon())
        self.Image_add:setVisible(false)
        self.equipIcon2:setVisible(true)
        self.Text_equip_num:setVisible(true)
    else
        self.equipBg2:loadTexture("Resources/common/item/item_bg_1.png", 1)
        self.Image_add:setVisible(true)
        self.equipIcon2:setVisible(false)
        self.Text_equip_num:setVisible(false)
    end


    local purple_iron_num, silver_num = self:getConsume(entity)

    if purple_iron_num and silver_num then
        self.Text_purple_iron_num:setString(purple_iron_num)
        self.Text_silver_num:setString(silver_num)

        if userInfoModel.userInfoEntity.purpleIron < purple_iron_num then
            self.Text_purple_iron_num:setColor(cc.c3b(255, 0, 0))
        else
            self.Text_purple_iron_num:setColor(cc.c3b(255, 255, 255))
        end

        if userInfoModel.userInfoEntity.silver < silver_num then
            self.Text_silver_num:setColor(cc.c3b(255, 0, 0))
        else
            self.Text_silver_num:setColor(cc.c3b(255, 255, 255))
        end
    end

    self.purpleIronTxt:setString(userInfoModel.userInfoEntity.purpleIron)
    self.silverTxt:setString(userInfoModel.userInfoEntity.silver > 100000000 and math.floor(userInfoModel.userInfoEntity.silver / 10000).."W" or userInfoModel.userInfoEntity.silver)
end



--[[--
--更新装备详情
--]]
function EquipAdvanceView:updateEquipInfo(delegate, _type)
    delegate:setSelectedEquip(model:getEquipEntity(delegate.delegate.type, delegate.selectEquipIdx + 1),_type)

    local _data = model:getAddAttribute()
    qy.tank.utils.HintUtil.showSomeImageToast(_data,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.7))
end


function EquipAdvanceView:getConsume(entity)
    local level = entity.advanced_level >= model:getMaxLevel(entity) and model:getMaxLevel(entity) - 1 or entity.advanced_level

    local data = model:atAdvanceConsume(level)
    return data.purple_iron, data.silver
end


function EquipAdvanceView:playMessageAnimation(boolean)
    if boolean then 
        local time = 1
        local scaleSmall = cc.ScaleTo:create(time,0.9)
        local scaleBig = cc.ScaleTo:create(time,1)
        local FadeIn = cc.FadeTo:create(time, 255)
        local FadeOut = cc.FadeTo:create(time, 0)
        local spawn1 = cc.Spawn:create(scaleSmall,FadeOut)
        local spawn2 = cc.Spawn:create(scaleBig,FadeIn)
        local seq = cc.Sequence:create(spawn1, spawn2)

        self.Image_add:runAction(cc.RepeatForever:create(seq))
    else
        self.Image_add:stopAllActions()
    end
end



-- 战斗力飘字
function EquipAdvanceView:showUtil()
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







return EquipAdvanceView