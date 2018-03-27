--[[
--对话框
 --Author: H.X.Sun 
 ---Date: 2015-04-24
]]

local DialogueCell = qy.class("DialogueCell", qy.tank.view.BaseView, "view/guide/noviceGuide/DialogueCell")

function DialogueCell:ctor(delegate)
    DialogueCell.super.ctor(self)
	self:InjectView("wordLayout")
	self:InjectView("nameTxt")
	self:InjectView("wordBg")
	self:InjectView("nameBg")
	self:InjectView("tips")
	-- self.content:setTextAreaSize(cc.size(430,70))
	self.content = cc.Label:createWithTTF("",qy.res.FONT_NAME, 24.0,cc.size(430,0),0)
	self.content:setAnchorPoint(0,1)
	self.content:setTextColor(cc.c4b(255,255,255,255))
	-- self.content:setPosition(41,50)
	self.wordLayout:addChild(self.content)

	-- self:OnClick("wordBg", function (sendr)
	-- 	self.tips:setVisible(false)
	-- 	qy.GuideManager:next()
 --    	end, {["isScale"] = false})
end

function DialogueCell:hideTips()
	self.tips:setVisible(false)
end

function DialogueCell:setName(_name)
	if qy.tank.model.GuideModel:getCurrentBigStep() > 5 and qy.TextUtil:substitute(15008) == _name then
		_name = qy.tank.model.UserInfoModel.userInfoEntity.name
	end
	self.nameTxt:setString(_name)
end

function DialogueCell:updateViewData(data)
	if data.tipVisible == false then
		self.tips:setVisible(false)
	else
		self.tips:setVisible(true)
	end
	self:setName(data.role_name)
	self.content:setString(data.context)
	--计算高度
	self:_calculateHeight(data)
end

function DialogueCell:_calculateHeight(data)
	local height = self.content:getContentSize().height
	local defaultH = 100
	if data.tipVisible == false then
		defaultH = 87
	end
	self.wordBg:setContentSize(490, defaultH + height)
	self.tips:setPosition(438, 89 - height)

	if data.role_pos == 1 then
		self.nameBg:setPosition(108,133)
		self.content:setPosition(41,110)
		self.wordBg:setFlippedX(true)
	elseif data.role_pos == 2 then
		self.nameBg:setPosition(370,133)
		self.content:setPosition(30,110)
	end
end

function DialogueCell:onEnter( )
	if self.tips then
		local moveUp = cc.MoveBy:create(0.2, cc.p(0, 5))
		local moveDown = cc.MoveBy:create(0.2, cc.p(0, -5))
		local seq = cc.Sequence:create(moveUp, moveDown)
		self.tips:runAction(cc.RepeatForever:create(seq))
	end
end

function DialogueCell:onExit()
	self.tips:stopAllActions()
end

return DialogueCell