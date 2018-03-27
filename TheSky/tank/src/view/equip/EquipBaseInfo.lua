--[[--
    装备基础信息
    Author: H.X.Sun
--]]--
local EquipBaseInfo = qy.class("EquipBaseInfo", qy.tank.view.BaseView, "view/equip/EquipBaseInfo")

function EquipBaseInfo:ctor(delegate)
    EquipBaseInfo.super.ctor(self)
    self:InjectView("equipName")
    self:InjectView("equipBg")
    self:InjectView("equipIcon")
    self:InjectView("part")
    self:InjectView("level")
    self:InjectView("reformlevel")
    self:InjectView("property")
    self:InjectView("init_property")
    self:InjectView("cost")
    self:InjectView("silver")
    self:update(delegate.entity)
end

function EquipBaseInfo:update(entity)
    self.equipBg:setSpriteFrame(entity:getIconBg())
    self.equipIcon:setTexture(entity:getIcon())
    self.equipName:setString(entity:getName())
    self.equipName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity:getQuality()))
    self.part:setString(entity:getComponentName())
    self.level:setString(entity.level)
    self.reformlevel:setString(entity.reform_level or 1)
    self.cost:setString(entity:getUpgradeCost())
    self.property:setString(entity:getPropertyInfo())
    self.silver:setString(qy.tank.model.UserInfoModel.userInfoEntity:getSilverStr())
    self.init_property:setString(entity:getInitPropertyInfo())
    if not tolua.cast(self.desc,"cc.Node") then
        self.desc = cc.Label:createWithTTF(entity.desc,qy.res.FONT_NAME, 20.0,cc.size(350,0),0)
        self.desc:setAnchorPoint(0,1)
        self.desc:setPosition(126,-237)
        self.desc:enableOutline(cc.c4b(0,0,0,255),1)
        self:addChild(self.desc)
    else
        self.desc:setString(entity.desc)
    end
end

function EquipBaseInfo:getHeight()
    return 228 + self:getDescHeight()
end

function EquipBaseInfo:getDescHeight()
    return self.desc:getContentSize().height
end

function EquipBaseInfo:showStrengEffert()
    if self.currentEffert == nil then
        self.currentEffert = ccs.Armature:create("ui_fx_zhuangbeishengjiguang")
        self.equipBg:addChild(self.currentEffert,999)
        self.currentEffert:setPosition(56.5,56.5)
        self.currentEffert:setScale(1.16)
    end
    self.currentEffert:setVisible(true)

    self.currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            self.currentEffert:setVisible(false)
        end
    end)
    self.currentEffert:getAnimation():playWithIndex(0)
end

return EquipBaseInfo
