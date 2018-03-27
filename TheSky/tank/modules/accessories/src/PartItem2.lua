--[[
	配件系统
	Author: 
]]

local PartItem2 = qy.class("PartItem2", qy.tank.view.BaseView, "accessories/ui/Partitem2")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.FittingsService
local model = qy.tank.model.FittingsModel
local garageModel = qy.tank.model.GarageModel
local StorageModel = qy.tank.model.StorageModel
local PassengerService = qy.tank.service.PassengerService
local UserInfoModel = qy.tank.model.UserInfoModel

function PartItem2:ctor(delegate)
    PartItem2.super.ctor(self)
    
    self:InjectView("partbg")
    self:InjectView("part")
    self:InjectView("bt")
    self:InjectView("btbg")
    self:InjectView("bg")
    self.btbg:setVisible(false)
    self.delegate = delegate
    self:OnClickForBuilding("bt",function ()
        if not delegate.isMoved() then
            if self.data[self.index].ischoose == 0 then
                self.data[self.index].ischoose = 1
            else
                self.data[self.index].ischoose = 0
            end
            delegate.callback(self.data[self.index].ischoose,self.index)
            self.btbg:setVisible(self.data[self.index].ischoose == 1)
        end
    end)
  	self.data = delegate.data
    self.touchtype = 0
end
function PartItem2:update( index  )
	self.index = index
    local data = self.data[index]
    self.btbg:setVisible(data.ischoose == 1)
    -- self.partbg:removeAllChildren(true)
    local fitting_id = data.fittings_id
    local list = model.localfittingcfg
    local quality = list[tostring(fitting_id)].quality
    local types = list[tostring(fitting_id)].fittings_type
    self.partbg:setSpriteFrame("Resources/common/item/item_bg_"..quality..".png")
    local png = "accessories/res/part"..types..".png"
    self.part:loadTexture(png,1)
    local datas = {}
    datas["type"] = 49
    datas["num"] =1
    datas["fittings"] = data
    self:OnClickForBuilding("part",function ()
        if not self.delegate.isMoved() then
            local itemData = qy.tank.view.common.AwardItem.getItemData(datas,true, 1,{})
            qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(itemData))
        end
    end)
end

return PartItem2
