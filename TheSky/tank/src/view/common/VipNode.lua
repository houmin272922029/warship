--[[
    VIP
    Author: H.X.Sun 
    Date: 2015-09-23
]]

local VipNode = qy.class("VipNode", qy.tank.view.BaseView, "view/common/VipNode")

local model = qy.tank.model.UserInfoModel

function VipNode:ctor(delegate)
    VipNode.super.ctor(self)
    self:InjectView("vip_icon")
    self.level = qy.tank.widget.Attribute.new({
        ["numType"] = 18,
        ["hasMark"] = 0, 
        ["value"] = 0,
    })
    local posX = self.vip_icon:getPositionX()
    local posY = self.vip_icon:getPositionY()
    self.level:setPosition(cc.p(posX,posY))
    self:addChild(self.level)
end

function VipNode:updateVip()
    self.level:update(model.userInfoEntity.vipLevel)
end

function VipNode:onEnter()
  	self:updateVip()
		self.updateVipListener = qy.Event.add(qy.Event.USER_RECHARGE_DATA_UPDATE,function(event)
     		self:updateVip()
    end)
end

function VipNode:onExit()
    qy.Event.remove(self.updateVipListener)
end

return VipNode 