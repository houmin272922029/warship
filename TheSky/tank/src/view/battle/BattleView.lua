--[[
    战斗场景
    Author: Aaron Wei
    Date: 2015-01-14 18:01:32
]]

local BattleView = qy.class("BattleView", qy.tank.view.BaseView, "view/battle/BattleView")

function BattleView:ctor(delegate)
    BattleView.super.ctor(self)
	-- buff特效
    self.delegate = delegate
    self.infoBar = nil
    self.field1,self.field2 = nil,nil
    self.model = qy.tank.model.BattleModel
    self.manager = qy.tank.manager.BattleRoundManager
    self.guide = qy.tank.model.GuideModel
    self.userInfo = qy.tank.model.UserInfoModel

    self:InjectView("speedBtn")
	self.speedBtn:setVisible(true)

    -- 加速x1
    self:OnClick("speedBtn", function(sender)
    	if self.speed == 1 then
	    	if self.model:getLeftUserLevel() < 1 then
	    		qy.hint:show(qy.TextUtil:substitute(5002))
	    	else
				self:setSpeed(2)
	    	end
    	elseif self.speed == 2 then
    -- 		if self.model:getLeftUserLevel() < 20 then
	   --  		qy.hint:show("指挥官20级开启3倍速")
	   --  	else
				-- self:setSpeed(3)
	   --  	end
	   		self:setSpeed(1)
    	elseif self.speed == 3 then
    		self:setSpeed(1)
    	end
    end)

    -- 跳过
	self:InjectView("skipBtn")
	self.skipBtn:setPosition(qy.winSize.width-100,30)
    self:OnClick("skipBtn", function(sender)
        if delegate and delegate.onSkip then
        	if self.model.totalBattleData.fight_type == 1 then
        		if self.userInfo.userInfoEntity.vipLevel >= 3 or self.model.totalBattleData.ext.skip >= 1 or self.userInfo.userInfoEntity.level >= 60 then
        			self.skipBtn:setEnabled(false)
	            	delegate.onSkip()
        		else
        			qy.hint:show(qy.TextUtil:substitute(5003))
        		end
        	else
	        	self.skipBtn:setEnabled(false)
	            delegate.onSkip()
        	end
        end
	end,{["hasAudio"] = false})

	if qy.isNoviceGuide then 
		self.speedBtn:setPosition(qy.winSize.width-50,30)
    	self.skipBtn:setVisible(false)
	else
		self.speedBtn:setPosition(self.skipBtn:getPositionX()-self.skipBtn:getContentSize().width/2-self.speedBtn:getContentSize().width/2-30,30)
    	self.skipBtn:setVisible(true)
	end

	self:InjectView("roundLabel")
	self.roundLabel:setPosition(qy.winSize.width/2,qy.winSize.height-100)
	self.roundLabel:setVisible(false)
	self.roundLabel:setString("1/"..#self.model.actionList..qy.TextUtil:substitute(5004))

    -- 解决ClippingNode在手机上渲染bug的偏方儿
	-- local placeholder = cc.Sprite:create("Resources/bg/placeholder.png")
	-- self:addChild(placeholder)
end

function BattleView:onEnter()
	qy.tank.command.BattleCommand:addResources()
	qy.GuideCommand:addRegBatSpeedBtn(self.speedBtn)
end

function BattleView:onExit()
	qy.QYPlaySound.stopMusic(true)
	cc.Director:getInstance():getScheduler():setTimeScale(1)
	qy.GuideCommand:removeRegBatSpeedBtn()
end

function BattleView:onCleanup()
end

-- 初始化播放
function BattleView:init()
	qy.QYPlaySound.playMusic(qy.SoundType.BATTLE_BG_MS,true)
	cc.Director:getInstance():getScheduler():setTimeScale(1)

	self.speedBtn:setVisible(false)

	self.skipBtn:setVisible(false)
	self.skipBtn:setEnabled(true)

	self.roundLabel:setVisible(false)
	self:createField()
	-- qy.QYPlaySound.playEffect(qy.SoundType.T_MOVE)
	self:createWire()
	self:createMask()

	if qy.isNoviceGuide then
		self.playListener = qy.Event.add("battlePlay",function(event)
			self:createInfoBar()
		end)
	else
		qy.Timer.create(tostring(math.random()),function()
			self:createInfoBar()
		end,1,1)
	end

	self.listener1 = qy.Event.add("action_end",function(event)
		self.roundLabel:setString(self.manager.round.."/"..#self.model.actionList..qy.TextUtil:substitute(5004))
	end)

	self.listener2 = qy.Event.add("battle_end",function(event)
		-- qy.QYPlaySound.stopMusic(true)
        self.delegate.onEnded()
	end)

	self.shakeListener = qy.Event.add("shake",function(event)
		if event._usedata == 1 then
   			self.field1:shake()
		else
   			self.field2:shake()
		end
   	end)

	self.manager.running = false
	self.manager:init()
end

-- 非初始化播放
function BattleView:play()
	self.field2:clear()
	self.model:initNextBattle()
	self.manager:init()
	local timer = qy.tank.utils.Timer.new(1,1,function()
		self.field2:reset()
		self.manager:play()
	end)
	timer:start()
	self.skipBtn:setEnabled(true)
end

-- 结束
function BattleView:stop()
	for i=1,2 do
		if field then
			field:stop()
		end
	end
end

-- 销毁
function BattleView:destroy()
	qy.Event.remove(self.listener1)
	qy.Event.remove(self.listener2)
	qy.Event.remove(self.shakeListener)
	qy.Event.remove(self.playListener)
	self:removeInfoBar()
	self:removeField()
	self:removeMask()
	self:removeWire()
end

-- 跳转到最后一回合特写
function BattleView:skip()
	for i=1,2 do
		local field = self["field"..i]
		if field then
			field:skip()
		end
	end
end

-- 加速
function BattleView:setSpeed(scale)
	self.speed = scale
	local layout = ccui.LayoutComponent:bindLayoutComponent(self.speedBtn)
	if scale == 1 then
		cc.Director:getInstance():getScheduler():setTimeScale(1)
		self.speedBtn:loadTexture("Resources/battle/btn_speed1.png",1)
		layout:setSize(cc.size(64,45))
	elseif scale == 2 then
		cc.Director:getInstance():getScheduler():setTimeScale(1.5)
		self.speedBtn:loadTexture("Resources/battle/btn_speed2.png",1)
		layout:setSize(cc.size(64,45))
	elseif scale == 3 then
		cc.Director:getInstance():getScheduler():setTimeScale(2)
		self.speedBtn:loadTexture("Resources/battle/btn_speed3.png",1)
		layout:setSize(cc.size(70,50))
	end
	cc.UserDefault:getInstance():setIntegerForKey("tank_speed_"..self.userInfo.kid,scale)
end

-- 退出
function BattleView:exit()
	for i=1,2 do
		local field = self["field"..i]
		field:destroy()
	end
end

-- 创建战斗阵地
function BattleView:createField()
	for i=1,2 do
		local field = qy.tank.view.battle.BattleField.new(i)
		self["field"..i] = field
	    self:addChild(field,-1)
	end
end

-- 移除战斗阵地
function BattleView:removeField()
	for i=1,2 do
		local field = self["field"..i]
		if tolua.cast(field,"cc.Node") then
			field:destroy()
			self["field"..i] = nil
		end
	end
end

-- 创建信息条
function BattleView:createInfoBar()
    self.infoBar = qy.tank.view.battle.BattleHeader.new({
		["ended"] = function()
			-- self.manager:init()
			self.manager:play()

			self.speedBtn:setVisible(true)
			if qy.isNoviceGuide then
				self.skipBtn:setVisible(false)
			else
				self.skipBtn:setVisible(true)
			end

			if self.model:getLeftUserLevel() < 5 then
				self:setSpeed(1)
			else
				local key = "tank_speed_"..self.userInfo.kid
				if cc.UserDefault:getInstance():getIntegerForKey(key,1) == 1 then
					self:setSpeed(1)
				elseif cc.UserDefault:getInstance():getIntegerForKey(key,1) == 2 then
					self:setSpeed(2)
				elseif cc.UserDefault:getInstance():getIntegerForKey(key,1) == 3 then
					self:setSpeed(2)
				end
			end

			if qy.DEBUG then
				self.roundLabel:setVisible(true)
			end
			-- qy.QYPlaySound.playMusic(qy.SoundType.BATTLE_BG_MS,true)
		end
	})
    self:addChild(self.infoBar)
    self.infoBar:play()
end

-- 移除信息条
function BattleView:removeInfoBar()
	if self.infoBar and self.infoBar:getParent() then
		self.infoBar:destroy()
		self.infoBar:getParent():removeChild(self.infoBar)
		self.infoBar = nil
	end
end

-- 创建战斗场景内阴影
function BattleView:createMask()
	self.mask = ccui.ImageView:create("ui/bg/battle_mask.png",ccui.TextureResType.localType)
	local size = self.mask:getContentSize()
	self.mask:setScale9Enabled(true)
	self.mask:setCapInsets(cc.rect(80,80,size.width-160,size.height-160))
	self.mask:setContentSize(qy.winSize)
	self:addChild(self.mask,-1)
	self.mask:setPosition(qy.centrePoint)
end

-- 移除战斗场景内阴影
function BattleView:removeMask()
	if tolua.cast(self.mask,"cc.Node") and self.mask:getParent() then
		self.mask:getParent():removeChild(self.mask)
	end
end

function BattleView:createWire()
	self.wire = cc.Sprite:create("Resources/battle/wire.png")
	self.wire:setRotation(1)
	self:addChild(self.wire,-1)
	self.wire:setPosition(qy.centrePoint)
end

function BattleView:removeWire()
	if tolua.cast(self.wire,"cc.Node") and self.wire:getParent() then
		self.wire:getParent():removeChild(self.wire)
	end
end

function BattleView:playCompatSkill(skillID,direction)
	local skill = qy.tank.view.battle.CompatSkillView.new(skillID,direction)
	self:addChild(skill)
	skill:play()
end

return BattleView
