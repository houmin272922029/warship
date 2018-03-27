--[[
	配件系统
	Author: 
]]

local Textnode1 = qy.class("Textnode1", qy.tank.view.BaseView, "accessories/ui/Textnode")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.FittingsService
local model = qy.tank.model.FittingsModel
local garageModel = qy.tank.model.GarageModel
local StorageModel = qy.tank.model.StorageModel
local PassengerService = qy.tank.service.PassengerService
local UserInfoModel = qy.tank.model.UserInfoModel

function Textnode1:ctor(delegate)
    Textnode1.super.ctor(self)
    
    self:InjectView("name")
    self:InjectView("nums")
    local data = delegate.data
    local ztype = delegate.id
    self.name:setString(model.TypeNameList[tostring(ztype)]..":")
    -- 初始属性 *（1+选中强化次数*0.5）（四舍五入）
    local num = (delegate.num)/ 10
    if tonumber(ztype) <= 5 then
         self.nums:setString("+"..delegate.num)
    else
        self.nums:setString("+"..num.."%")
    end

  
    
end

return Textnode1
