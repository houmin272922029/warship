--[[
	配件系统
	Author: 
]]

local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "accessories/ui/ShopCell")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.FittingsService
local model = qy.tank.model.FittingsModel
local garageModel = qy.tank.model.GarageModel
local StorageModel = qy.tank.model.StorageModel
local PassengerService = qy.tank.service.PassengerService
local UserInfoModel = qy.tank.model.UserInfoModel

function ShopCell:ctor(delegate)
    ShopCell.super.ctor(self)
    
    self:InjectView("awardbg")
    self:InjectView("icon")--精灵
    self:InjectView("exchange")--花费
    self:InjectView("BuyBt")
    self:InjectView("yigoumai")
    self:OnClick("BuyBt",function()
        local shopid = model.ShopList[self.idx]
        service:buyshopById(shopid,function (  )
            -- self.yigoumai:setVisible(true)
            -- self.BuyBt:setVisible(false)
            delegate.callback()
        end)
    end)
    self.idx = delegate._idx
    self:update(self.idx)
    
end
function ShopCell:update( _idx )
    local shopid = model.ShopList[_idx]
    local data = model.fittings_shop[tostring(shopid)]
    local status = 0
    for i=1,#model.buylog do
        if shopid == model.buylog[i] then
            status = -1
            break
        end
    end
    self.awardbg:removeAllChildren(true)
	self.BuyBt:setVisible(status == 0)
    self.yigoumai:setVisible(status == -1)
    if data.type == 1 then
        self.icon:setSpriteFrame("accessories/res/1.png")
    else
        self.icon:setSpriteFrame("accessories/res/jifen.png")
    end
    self.exchange:setString(data.price)
    local item = qy.tank.view.common.AwardItem.createAwardView(data.award[1] ,1)
    self.awardbg:addChild(item)
    item:setPosition(62, 55)
    item:setScale(0.95)
    item.name:setVisible(false)
    item.num:setVisible(false)
end

return ShopCell
