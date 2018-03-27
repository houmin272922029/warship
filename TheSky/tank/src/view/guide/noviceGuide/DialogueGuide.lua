--[[
--新手引导--对话引导
 --Author: H.X.Sun
 ---Date: 2015-04-24
]]

local DialogueGuide = qy.class("DialogueGuide", qy.tank.view.BaseView, "view/guide/noviceGuide/DialogueGuide")

function DialogueGuide:ctor(delegate)
    DialogueGuide.super.ctor(self)
	self:InjectView("panel")
	self.panel:setContentSize(qy.winSize.width, qy.winSize.height)
	self:__setDefaultValue()
	self:__initView()
	self.left:setVisible(false)
	self.right:setVisible(false)

	self:OnClick("panel", function (sendr)
		qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
		qy.GuideManager:next(25)
	end, {["isScale"] = false, ["hasAudio"] = false})
end

function DialogueGuide:setDelay(_t)
	self.delay = _t
end

function DialogueGuide:__updateData(_top, _bottom)
	self["_".._top .."Show"] = true
	self["_".._top .."WrodY"] = 100
	-- self["_".._top .."WrodX"] = 538
	self["_".._bottom .."WrodY"] = 300
	-- self["_".._bottom .."WrodX"] = 588
	self[_top .."Scale"] = 1
	self[_bottom .."Scale"] = 0.9
	self[_top .."Opacity"] = 255
	self[_bottom .."Opacity"] = 200
end

function DialogueGuide:update(data)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/guide/role/guide_role.plist")
	local _left = "left"
	local _right = "right"
	if data.role_res then
		print("人物资源：" .. data.role_res)
	end

	if data.role_pos == 1 then
		self:__updateData(_left, _right)
		self["_leftWrodX"] = 538
		self["_rightWrodX"] = -500
		self["leftWord"]:updateViewData(data)
		self.rightWord:hideTips()
		self.leftFigure:setSpriteFrame(qy.GuideModel:getGuideImg(data.role_res))
	elseif data.role_pos == 2 then
		self:__updateData(_right, _left)
		self["_rightWrodX"] = -538
		self["_leftWrodX"] = 500
		self["rightWord"]:updateViewData(data)
		self.leftWord:hideTips()
		self.rightFigure:setSpriteFrame(qy.GuideModel:getGuideImg(data.role_res))
	end
	-- if self.delay > 0 then
	-- 	local fun = cc.CallFunc:create(function ()
	-- 		self:__updateView()
	-- 	end)
	-- 	self.panel:runAction(cc.Sequence:create(cc.DelayTime:create(self.delay), fun))
	-- else
	self:__updateView()
	-- end
end

function DialogueGuide:__setDefaultValue()
	self._leftShow = false
	self._rightShow = false
	self.leftScale = 0.9
	self.rightScale = 0.9
	self.leftOpacity = 200
	self.rightOpacity = 200
end

function DialogueGuide:__initView()
	self:InjectView("left")
	self:InjectView("leftFigure")

	self:InjectView("right")
	self:InjectView("rightFigure")

	self.leftWord = qy.tank.view.guide.noviceGuide.DialogueCell.new()
	self.left:addChild(self.leftWord)
	self.leftWord:setPosition(538, -200)

	self.rightWord = qy.tank.view.guide.noviceGuide.DialogueCell.new()
	self.right:addChild(self.rightWord)
	self.rightWord:setPosition(-538, -200)
end

function DialogueGuide:__updateView()
	self.left:setScale(self.leftScale)
	self.left:setOpacity(self.leftOpacity)
	self.leftWord:setPosition(self._leftWrodX, self._leftWrodY)
	self.left:setVisible(self._leftShow)

	self.right:setScale(self.rightScale)
	self.right:setOpacity(self.rightOpacity)
	self.rightWord:setPosition(self._rightWrodX, self._rightWrodY)
	self.right:setVisible(self._rightShow)
end

function DialogueGuide:onEnter( )

end

return DialogueGuide
