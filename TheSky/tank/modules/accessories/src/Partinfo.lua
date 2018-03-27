--[[
	配件系统
	Author: 
]]

local Partinfo = qy.class("Partinfo", qy.tank.view.BaseView, "accessories/ui/Partinfo")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.FittingsService
local model = qy.tank.model.FittingsModel
local garageModel = qy.tank.model.GarageModel
local StorageModel = qy.tank.model.StorageModel
local PassengerService = qy.tank.service.PassengerService
local UserInfoModel = qy.tank.model.UserInfoModel

function Partinfo:ctor(delegate)
    Partinfo.super.ctor(self)
    
    self:InjectView("bg")
    self:InjectView("partlevel")
    self:InjectView("name")
    self:InjectView("zhushuxing")
    self:InjectView("shuxing")--主属性值
    self.data = delegate.data
    self:createContent()
    
end

function Partinfo:createContent()
    self.partlevel:setString(self.data.level)
    local fitting_id = self.data.fittings_id
    local list = model.localfittingcfg
    self.name:setString(list[tostring(fitting_id)].name)
    local quality = list[tostring(fitting_id)].quality
     local color = qy.tank.utils.ColorMapUtil.qualityMapColor(quality)
    self.name:setColor(color) 
    local ztype = list[tostring(fitting_id)].type
    self.zhushuxing:setString(model.TypeNameList[tostring(ztype)]..":")
    if ztype <= 5 then
        local yy = math.round((self.data.mval)* ( 1 + self.data.level * 0.1))
        self.shuxing:setString("+"..yy)
    else
        local xx = math.round((self.data.mval)* ( 1 + self.data.level * 0.1)) / 10
        self.shuxing:setString("+"..xx.."%")
    end
    
    for i=1,#self.data.sub_attr do
        local node = require("accessories.src.Textnode").new({
            ["data"] = self.data.sub_attr[i]
            })
        node:setPosition(cc.p(18,210 - i * 35))
        self.bg:addChild(node)
    end
end



function Partinfo:onEnter()
   
end

function Partinfo:onExit()
end

return Partinfo
