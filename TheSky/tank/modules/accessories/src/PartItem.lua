--[[
	配件系统
	Author: 
]]

local PartItem = qy.class("PartItem", qy.tank.view.BaseView, "accessories/ui/PartItem")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.FittingsService
local model = qy.tank.model.FittingsModel
local garageModel = qy.tank.model.GarageModel
local StorageModel = qy.tank.model.StorageModel
local PassengerService = qy.tank.service.PassengerService
local UserInfoModel = qy.tank.model.UserInfoModel

function PartItem:ctor(delegate)
    PartItem.super.ctor(self)
    
    self:InjectView("partbg")
    self:InjectView("part")
    self:InjectView("slectlight")
    self.slectlight:setVisible(false)
  	self:OnClickForBuilding("part",function ()
		if not delegate.isMoved() then
			-- self.model:setPropSelect(self.index)
			print("点击了啊",self.index)
			delegate.callback(self.index)

		end
	end)
    self.data = delegate.data
end

function PartItem:update( index ,selectid ,datas)
	local data = self.data
	self.index = index
	self.slectlight:setVisible(index == selectid)
	local fitting_id = data[index].fittings_id
    local list = model.localfittingcfg
    local quality = list[tostring(fitting_id)].quality
    local types = list[tostring(fitting_id)].fittings_type
    self.partbg:setSpriteFrame("Resources/common/item/item_bg_"..quality..".png")
    local png = "accessories/res/part"..types..".png"
    self.part:loadTexture(png,1)
  
  
end


function PartItem:onEnter()
   
end

function PartItem:onExit()
end

return PartItem
