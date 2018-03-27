--[[
--装备tip
--Author: H.X.Sun
--Date: 2015-07-18
]]

local PartTip = qy.class("PartTip",  qy.tank.view.BaseDialog, "view/tip/PartTip")

local model = qy.tank.model.FittingsModel

function PartTip:ctor(entity)
    PartTip.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self:InjectView("ScrollView")
    self.ScrollView:setScrollBarEnabled(false)
    self:InjectView("equipName")
    self:InjectView("levels")
    self:InjectView("itemicon")
    self:InjectView("itembg")
    self:InjectView("property")--主属性
    for i=1,6 do
        self:InjectView("shuxing"..i)
        self["shuxing"..i]:setVisible(false)
    end
    self.data = entity
    local id = self.data.fittings_id
    local Date = model.localfittingcfg[id..""]
    local typs = Date.fittings_type
    self.equipName:setString(Date.name)
    local color = qy.tank.utils.ColorMapUtil.qualityMapColor(Date.quality)
    self.equipName:setColor(color)
    self.levels:setString(self.data.level)
    self.itembg:loadTexture("Resources/common/item/item_bg_"..Date.quality..".png",1)
    self.itemicon:loadTexture("res/fittings/part" .. Date.fittings_type ..".png",0)
    local shuxingtype = Date.type
    if tonumber(shuxingtype) <= 5 then
        self.property:setString(model.TypeNameList[tostring(shuxingtype)].."+"..(self.data.mval)* ( 1 + self.data.level * 0.1))
    else
        local xx = math.round((self.data.mval)* ( 1 + self.data.level * 0.1)) / 10
        self.property:setString(model.TypeNameList[tostring(shuxingtype)].."+"..xx.."%")
    end
    
    local datas = self.data.sub_attr
    for i=1,#datas do
        self["shuxing"..i]:setVisible(true)
        local shuxingtype1 = datas[i].type
        local num21 = (math.round(datas[i].val * (1 + datas[i].level * 0.5)))/ 10
        self["shuxing"..i]:setString(model.TypeNameList[tostring(shuxingtype1)]..":+"..num21.."%")
    end
end

return PartTip
