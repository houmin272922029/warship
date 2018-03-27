--[[
--装备tip
--Author: H.X.Sun
--Date: 2015-07-18
]]

local PartTip1 = qy.class("PartTip1",  qy.tank.view.BaseDialog, "view/tip/PartTip1") 

local model = qy.tank.model.FittingsModel

function PartTip1:ctor(delegate)
    PartTip1.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self:InjectView("ScrollView")
    self.ScrollView:setScrollBarEnabled(false)
    self:InjectView("equipName")
    self:InjectView("levels")
    self:InjectView("itemicon")
    self:InjectView("itembg")
    self:InjectView("property")--主属性
    for i=1,14 do
        self:InjectView("shuxing"..i)
        self["shuxing"..i]:setVisible(false)
    end
    local id = delegate.id
    local Date = model.localfittingcfg[id..""]
    local typs = Date.fittings_type
    self.equipName:setString(Date.name)
    local color = qy.tank.utils.ColorMapUtil.qualityMapColor(Date.quality)
    self.equipName:setColor(color)
    self.levels:setString("0")
    self.itembg:loadTexture("Resources/common/item/item_bg_"..Date.quality..".png",1)
    self.itemicon:loadTexture("res/fittings/part" .. Date.fittings_type ..".png",0)
    local shuxingtype = Date.type
    if shuxingtype <= 5 then
        local num1 = math.round(Date.initial * (1 - model.mianrange)) 
        local num2 = math.round(Date.initial * (1 + model.mianrange)) 
        self.property:setString(model.TypeNameList[tostring(shuxingtype)].."("..num1.."-"..num2..")")
    else
        local num1 = math.round(Date.initial * (1 - model.mianrange)) / 10
        local num2 = math.round(Date.initial * (1 + model.mianrange)) / 10
        self.property:setString(model.TypeNameList[tostring(shuxingtype)].."("..num1.."%-"..num2.."%)")
    end
    
   
    local datas = model:getcfgByQuality(Date.quality)
    for i=1,#datas do
        self["shuxing"..i]:setVisible(true)
        local shuxingtype1 = datas[i].type
        local num11 = math.round(datas[i].initial * (1 - model.otherrange)) / 10 
        local num21 = math.round(datas[i].initial * (1 + model.otherrange)) / 10
        self["shuxing"..i]:setString(model.TypeNameList[tostring(shuxingtype1)].."("..num11.."%-"..num21.."%)")
    end
end

return PartTip1
