--[[
--新手引导--点击引导
 --Author: H.X.Sun
 ---Date: 5015-04-24
]]

local ClickGuide = qy.class("ClickGuide", qy.tank.view.BaseView, "view/guide/noviceGuide/ClickGuide")

function ClickGuide:ctor(delegate)
    ClickGuide.super.ctor(self)
	self:InjectView("mark")
	self:InjectView("tip")
	self:InjectView("arrow")
	self:InjectView("mark_icon")

	self:InjectView("left")
	self:InjectView("leftFigure")
	self.left:setVisible(false)
	self:InjectView("right")
	self:InjectView("rightFigure")
	self.right:setVisible(false)
	self._showMarkIocn = false
	self.mark_icon:setVisible(false)

	self.arrow:setVisible(false)
	self.rect = {x=-500,y=-500,width=0,height=0}
	self:__touchLogic()
end

function ClickGuide:_stopAnim()
	self.arrow:stopAllActions()
	self.arrow:setVisible(false)
	self.mark:stopAllActions()
	-- self.mark:setVisible(false)
end

function ClickGuide:__playAnim(_arrowDirec)
	self.arrow:setRotation(135 + _arrowDirec * 45)
	local _upPos = nil
	local _downPoa = nil
	local M_DIS = 12 --移动距离
	if _arrowDirec == 1 then
		--指向：上
		print("新手引导箭头指向：上")
		self.arrow:setPosition(self.rect.x, self.rect.y - self.rect.height/2- 90)
		_upPos = cc.p(0, M_DIS)
		_moveDown = cc.p(0, -M_DIS)
	elseif _arrowDirec == 2 then
		--指向：右上
		print("新手引导箭头指向：右上")
		self.arrow:setPosition(self.rect.x - self.rect.width/2 - 50, self.rect.y - self.rect.height/2 - 50)
		_upPos = cc.p(M_DIS, M_DIS)
		_moveDown = cc.p(-M_DIS, -M_DIS)
	elseif _arrowDirec == 3 then
		--指向：右
		print("新手引导箭头指向：右")
		self.arrow:setPosition(self.rect.x - self.rect.width/2 - 90, self.rect.y)
		_upPos = cc.p(M_DIS, 0)
		_moveDown = cc.p(-M_DIS, 0)
	elseif _arrowDirec == 4 then
		--指向：右下
		print("新手引导箭头指向：右下")
		self.arrow:setPosition(self.rect.x - self.rect.width/2 - 50, self.rect.y + self.rect.height /2+ 50)
		_upPos = cc.p(M_DIS, -M_DIS)
		_moveDown = cc.p(-M_DIS, M_DIS)
	elseif _arrowDirec == 5 then
		--指向：下
		print("新手引导箭头指向：下")
		self.arrow:setPosition(self.rect.x , self.rect.y + self.rect.height/2 + 90)
		_upPos = cc.p(0, -M_DIS)
		_moveDown = cc.p(0, M_DIS)
	elseif _arrowDirec == 6 then
		--指向：左下
		print("新手引导箭头指向：左下")
		self.arrow:setPosition(self.rect.x+ self.rect.width/2 +50, self.rect.y + self.rect.height/2 + 50)
		_upPos = cc.p(-M_DIS, -M_DIS)
		_moveDown = cc.p(M_DIS, M_DIS)
	elseif _arrowDirec == 7 then
		--指向：左
		print("新手引导箭头指向：左")
		self.arrow:setPosition(self.rect.x + self.rect.width/2 +90, self.rect.y)
		_upPos = cc.p(-M_DIS, 0)
		_moveDown = cc.p(M_DIS, 0)
	elseif _arrowDirec == 8 then
		--指向：左上
		print("新手引导箭头指向：左上")
		self.arrow:setPosition(self.rect.x + self.rect.width/2+50, self.rect.y - self.rect.height /2- 50)
		_upPos = cc.p(-M_DIS, M_DIS)
		_moveDown = cc.p(M_DIS, -M_DIS)
	end

	local callFunc = cc.CallFunc:create(function ()
		self.arrow:setVisible(true)
	end)
	local moveUp = cc.MoveBy:create(0.2, _upPos)
	local moveDown = cc.MoveBy:create(0.2, _moveDown)
	local seq = cc.Sequence:create(callFunc, moveUp, moveDown)
	-- self:__startMarkAnim()
	self:__touchTips()
	self.arrow:runAction(cc.RepeatForever:create(seq))
end

function ClickGuide:__showDialogue(data)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/guide/role/guide_role.plist")
	local _rolePos = data.role_pos
	local _roleRes = ""
	if qy.isNoviceGuide then
		_roleRes = data.role_res
	else
		_roleRes = data.res
	end

	if _roleRes then
		print("人物资源：" .. _roleRes)
	end
	data.tipVisible = false
	if _rolePos == 1 then
		self.left:setVisible(true)
		self.right:setVisible(false)
		self.leftFigure:setSpriteFrame(qy.GuideModel:getGuideImg(_roleRes))
		if self.leftWord == nil then
			print("==============leftWord=============")
			self.leftWord = qy.tank.view.guide.noviceGuide.DialogueCell.new()
			self.left:addChild(self.leftWord)
			self.leftWord:setPosition(self.leftFigure:getContentSize().width * 3 / 2, 260)
		end
		self.leftWord:updateViewData(data)
	elseif _rolePos == 2 then
		self.left:setVisible(false)
		self.right:setVisible(true)
		self.rightFigure:setSpriteFrame(qy.GuideModel:getGuideImg(_roleRes))
		if self.rightWord == nil then
			self.rightWord = qy.tank.view.guide.noviceGuide.DialogueCell.new()
			self.right:addChild(self.rightWord)
			self.rightWord:setPosition(self.rightFigure:getPositionX()-self.rightFigure:getContentSize().width - 180, 260)
		end
		self.rightWord:updateViewData(data)
	else
		self.left:setVisible(false)
		self.right:setVisible(false)
	end
end

function ClickGuide:updateRect(data)
	self:_stopAnim()
	self:__showDialogue(data.guideData)

	local target = data.ui
	self.targetUi = target
	self.type = data.type
	local size = nil
	local anchor = nil
	local position = nil
	if target then
		print("target ============================================has")
		size = target:getContentSize()
		anchor = target:getAnchorPoint()
		position = target:getParent():convertToWorldSpace(cc.p(target:getPositionX(), target:getPositionY()))
	else
		--新手引导：2015.11.14 增加（在新手引导的战斗期间，可以战斗加速）
		target = qy.GuideCommand:getRegBatSpeedBtn()
		if target and tolua.cast(target,"cc.Node") then
			print("target =====新手引导 speed btn")
			size = target:getContentSize()
			anchor = target:getAnchorPoint()
			position = target:getParent():convertToWorldSpace(cc.p(target:getPositionX(), target:getPositionY()))
		else
			print("target ============================================nil")
			size = cc.size(0, 0)
			anchor = cc.p(0.5,0.5)
			position = cc.p(-500, -500)
		end
	end
	self.rect = {x=position.x- (anchor.x-0.5)*size.width,y=position.y - (anchor.y-0.5)*size.height,width=size.width,height=size.height}

	if self.type == 3 then
		--战斗
		local delay = qy.tank.utils.Timer.new(0.1,1,function()
			print("新手引导 qy.tank.manager.BattleRoundManager:play()")
			-- qy.tank.manager.BattleRoundManager:play()
			qy.Event.dispatch("battlePlay")
		end)
		delay:start()
		return
	elseif self.type == 5 then
		--弹出结算面板
		local delay = qy.tank.utils.Timer.new(1,1,function()
			qy.Event.dispatch(qy.Event.BATTLE_RESULT)
			qy.GuideManager:next(23)
		end)
		delay:start()
		return
	elseif self.type == 4 then
		--继续游戏
		qy.tank.manager.BattleRoundManager:continue()
		return
	end

	self.mark:setPosition(self.rect.x, self.rect.y)
	self.tip:setPosition(self.rect.x, self.rect.y)
	-- self.markScale = self.rect.height/self.mark:getContentSize().width
	self.markScale = 0.3
	-- self.mark:setScale(self.markScale)
	if data.step > 0 and data.subStep > 0 then
		local arrowDirec = 0
		local stepData = {}

		if qy.isNoviceGuide then
			stepData = qy.tank.model.GuideModel:getGuideDataArr()
			if stepData[data.step] and stepData[data.step][data.subStep] then
				arrowDirec = stepData[data.step][data.subStep].arrow_direc
			end
		else
			stepData = qy.tank.model.GuideModel:getTriggerGuideData()
			arrowDirec = stepData[data.subStep].arrow_direc
		end

		if arrowDirec > 0 then
			self:__playAnim(arrowDirec)
		end
	end

end

function ClickGuide:__startMarkAnim()
	self.mark_icon:setVisible(true)
	local scaleSmall = cc.ScaleTo:create(1,1)
	local scaleBig = cc.ScaleTo:create(1,1.2)

	local delay = cc.DelayTime:create(1)
	local seq = cc.Sequence:create(scaleBig, scaleSmall )
	local seq2 = cc.Sequence:create(delay, spawn2)
    self.mark_icon:runAction(cc.RepeatForever:create(seq))
    -- self.mark_icon_1:runAction(cc.RepeatForever:create(seq2))
end

function ClickGuide:__stopMarkAnim()
	self.mark:stopAllActions()
end

function ClickGuide:__createCircle()
	local circle = ccui.ImageView:create()
	circle:loadTexture("Resources/guide/lead_24.png",1)
	self.tip:addChild(circle)
	circle:setScale(6)
	circle:setOpacity(0)
	local callFunc = cc.CallFunc:create(function ()
		if circle:getScale() > 0.3 then
			circle:setScale(circle:getScale() - 0.18)
			circle:setRotation(circle:getRotation() + 7)
			local op = circle:getOpacity() + 20
			if op > 255 then
				circle:setOpacity(255)
			else
				circle:setOpacity(op)
			end
		else
			circle:stopAllActions()
			self.tip:removeChild(circle)
			-- if not self._showMarkIocn then
			-- 	self._showMarkIocn = true
			-- 	self:__startMarkAnim()
			-- end
		end
	end)
	if not self._showMarkIocn then
		self._showMarkIocn = true
		self:__startMarkAnim()
	end
	circle:runAction(cc.RepeatForever:create(cc.Sequence:create(callFunc)))
end

function ClickGuide:__touchTips()
	self.tip:stopAllActions()
	local callFunc = cc.CallFunc:create(function ()
		self:__createCircle()
	end)
	local delay = cc.DelayTime:create(0.1)
	self.tip:runAction(cc.Sequence:create(callFunc, delay,callFunc))
end

function ClickGuide:__removeAllCircle()
	self.tip:stopAllActions()
	self.tip:removeAllChildren(true)
end

function ClickGuide:__touchLogic()
	if self._touchListener and tolua.cast(self._touchListener, "cc.Node") then
		return
	end
	print("创建 one by one listener")
	self._touchListener = cc.EventListenerTouchOneByOne:create()
	local function onTouchBegan(touch, event)
		local p = cc.Director:getInstance():convertToGL(touch:getLocationInView())
		if self:__contains(p,self.rect) then
			self:__removeAllCircle()
			self._touchListener:setSwallowTouches(false)
		else
			self._touchListener:setSwallowTouches(true)
			if self.type == 2 then
				self:__touchTips()
			end
			if self.targetUi == nil then
				qy.GuideManager:nextTiggerGuide()
			end
		end

		self.time2 = self.time1
		-- self.listener:setSwallowTouches(false)

		return true
	end

	local function onTouchEnded(touch, event)
		return true
	end

	self._touchListener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
	self._touchListener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(self._touchListener,self)
end

function ClickGuide:__contains(p,rect)
	if p.x >= rect.x-rect.width/2 and p.x <= rect.x+rect.width/2 and p.y >= rect.y-rect.height/2 and p.y <= rect.y+rect.height/2 then
		return true
	else
		return false
	end
end

function ClickGuide:hideMark()
	self._showMarkIocn = false
	self.mark_icon:setVisible(false)
end

function ClickGuide:onEnter( )
	self._showMarkIocn = false
end

function ClickGuide:onExit()
	self:_stopAnim()
end

function ClickGuide:onCleanup()
	self:getEventDispatcher():removeEventListener(self._touchListener)
	self._touchListener = nil
end

return ClickGuide
