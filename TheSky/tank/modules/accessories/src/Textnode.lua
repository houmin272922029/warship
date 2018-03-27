--[[
	配件系统
	Author: 
]]

local Textnode = qy.class("Textnode", qy.tank.view.BaseView, "accessories/ui/Textnode")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.FittingsService
local model = qy.tank.model.FittingsModel
local garageModel = qy.tank.model.GarageModel
local StorageModel = qy.tank.model.StorageModel
local PassengerService = qy.tank.service.PassengerService
local UserInfoModel = qy.tank.model.UserInfoModel

function Textnode:ctor(delegate)
    Textnode.super.ctor(self)
    
    self:InjectView("name")
    self:InjectView("nums")
    local data = delegate.data
    local ztype = data.type
    self.name:setString(model.TypeNameList[tostring(ztype)]..":")
    -- 初始属性 *（1+选中强化次数*0.5）（四舍五入）
    local num = (math.round(data.val * (1 + data.level * 0.5)))/ 10
    self.nums:setString("+"..num.."%")
  
    
end

return Textnode
