--[[
	布阵坦克img
	Author: Aaron Wei
	Date: 2015-03-28 19:26:48
]]

-- local EmbattleTankImg = class("EmbattleTankImg",function()
-- 	-- return cc.Node:create()
-- 	return qy.tank.view.garage.TankImg.new()
-- end)

local EmbattleTankImg = qy.class("EmbattleTankImg", qy.tank.view.garage.TankImg)

function EmbattleTankImg:ctor(delegate)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/txt/common_txt.plist")

	self.delegate = delegate
	EmbattleTankImg.super.ctor(self,delegate[1],delegate[2],delegate[3])
end

-- 创建
function EmbattleTankImg:create(entity)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/icon/common_icon.plist")
	EmbattleTankImg.super.create(self,entity)
	
	self.bottom:setPosition(entity:getOffset())
	self.middle:setPosition(entity:getOffset())
	self.top:setPosition(entity:getOffset())
	
	self.icon = cc.Sprite:createWithSpriteFrameName(entity:getSealIcon())
	-- self.icon:setPosition(-50,self.body:getContentSize().height/2-30)
	self.icon:setPosition(-60,30)
	self:addChild(self.icon,999)

	self.changeBtn = ccui.Button:create()
	self.changeBtn:loadTextures("Resources/common/button/deploy_0002.png","Resources/common/button/deploy_0009.png",nil,1)
	-- self.changeBtn:setSwallowTouches(false)
	-- self.changeBtn:setTitleColor(cc.c4b(255,255,255,255))
	-- self.changeBtn:setTitleFontSize(26)
 	self.changeBtn:setPosition(50+entity:getOffsetX(),-50+entity:getOffsetY())
 	self:addChild(self.changeBtn,999)

 	self.changeLabel = cc.Sprite:createWithSpriteFrameName("Resources/common/txt/genghuan.png")
 	self.changeLabel:setPosition(50,20)
    self.changeBtn:addChild(self.changeLabel)

 	self.changeBtn:addTouchEventListener(function(sender,eventType)
	    if eventType == ccui.TouchEventType.ended then
	    	self.delegate.onChange(self.idx)
		end
	end)
end

-- 销毁
function EmbattleTankImg:destroy()
	if tolua.cast(self.barrel,"cc.Node") then
		self.barrel:remove()
	end
   
	if self:getParent() then
		self:getParent():removeChild(self)
	end
	self = nil
end

function EmbattleTankImg:startDrag()
	self.changeBtn:setVisible(false)
end

function EmbattleTankImg:endDrag()
	self.changeBtn:setVisible(true)
end

return EmbattleTankImg

