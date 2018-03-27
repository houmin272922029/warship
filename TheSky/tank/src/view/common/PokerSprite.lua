--[[
扑克牌
fq
2016年10月22日14:40:47
--]]
local PokerSprite = qy.class("PokerSprite", qy.tank.view.BaseView)

function PokerSprite:ctor(front, back, callback)
	self.front = nil
	self.back = nil
	self.btn = nil
	self.open_status = false
	self.callback = callback
	self.touch_status = true

	PokerSprite.super.ctor(self)
	self:initWithSprite(front,back)
end


function PokerSprite:initWithSprite(pFornt, pback)
	self.btn = ccui.Button:create()
	self.btn:setLayoutComponentEnabled(true)
	self.btn:setScale9Enabled(true)
	layout = ccui.LayoutComponent:bindLayoutComponent(self.btn)
	layout:setPositionPercentXEnabled(false)
	layout:setPositionPercentYEnabled(false)	
	self:addChild(self.btn)

	self:OnClick(self.btn, function(sender)
		if self.touch_status then
	        self.callback()
	    end
    end,{["isScale"] = false})

	
	if pFornt and pback then
		self.front = pFornt
		self.back = pback		

		layout:setSize(self.back:getContentSize())

		--扑克牌正面
		self.front:setVisible(false)
		self.front:setPosition(self.btn:getContentSize().width/2, self.btn:getContentSize().height/2)
		self.btn:addChild(self.front)
		self.front:setName("front")
		--扑克牌背面
		self.back:setPosition(self.btn:getContentSize().width/2, self.btn:getContentSize().height/2)
		self.btn:addChild(self.back)
		self.back:setName("back")

		return true
	end

	return false
end

function PokerSprite:open(duration, callback)
	if self.front and self.back then
		self.front:stopAllActions()
		self.back:stopAllActions()

		--正面z轴起始角度为90度（向左旋转90度），然后向右旋转90度
		local orbitfront = cc.OrbitCamera:create(duration*0.5,1,0,90,-90,0,0)
		-- 正面z轴起始角度为0度，然后向右旋转90度
		local orbitback = cc.OrbitCamera:create(duration*0.5,1,0,0,-90,0,0)

		if not self:getOpenStatus() then
			self.front:setVisible(false)
			-- 背面向右旋转90度->正面向左旋转90度
			self.back:runAction(cc.Sequence:create(cc.Show:create(),orbitback,cc.Hide:create(),
			cc.TargetedAction:create(self.front,cc.Sequence:create(cc.Show:create(),orbitfront, cc.CallFunc:create(function()
				self:setOpenStatus(true)
				if callback ~= nil then
					callback()
				end				
			end), NULL)),NULL))
		else
			self.back:setVisible(false)
			-- 背面向右旋转90度->正面向左旋转90度
			self.front:runAction(cc.Sequence:create(cc.Show:create(),orbitback,cc.Hide:create(),
			cc.TargetedAction:create(self.back,cc.Sequence:create(cc.Show:create(),orbitfront, cc.CallFunc:create(function()
				self:setOpenStatus(false)
				if callback ~= nil then
					callback()
				end				
			end), NULL)),NULL))
		end
	end
end


function PokerSprite:setOpenStatus(flag)
	if flag ~= nil then
		self.open_status = flag

		if flag then
			self.front:setVisible(true)
			self.back:setVisible(false)
		else
			self.front:setVisible(false)
			self.back:setVisible(true)
		end
	end
end


function PokerSprite:setTouchStatus(flag)
	if flag ~= nil then
		self.touch_status = flag
	end
end

function PokerSprite:getTouchStatus()
	return self.touch_status
end



function PokerSprite:getOpenStatus()
	return self.open_status
end


function PokerSprite:stopAction()
	self.btn:stopAllActions()
	self.back:stopAllActions()
	self.front:stopAllActions()
	self:stopAllActions()
end


return PokerSprite