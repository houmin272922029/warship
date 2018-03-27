--[[--
--主界面上的活动
--Author: lianyi
--]]--

local ActivitiesIcons = qy.class("ActivitiesIcons", qy.tank.view.BaseView)

local redModel = qy.tank.model.RedDotModel

function ActivitiesIcons:ctor(delegate)
    ActivitiesIcons.super.ctor(self)

	self.model = qy.tank.model.ActivityIconsModel
	local aType = qy.tank.view.type.ModuleType

	self:update()

end

function ActivitiesIcons:update()
	-- self.firstPay = false  --是否已点击
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/operatingActivities/icon/activityIcon.plist")
	if self.btnList~=nil and #self.btnList>=1 then
		for i = 1, #self.btnList do
			self.btnList[i]:setTouchEnabled(true)
		end
		self:removeAllChildren()
		self.first_pay = nil
		self.label = nil
	end
	self.btnList = {}
    self.btnArr = {}
	local actIndexArr = self.model:getIconList()
	if actIndexArr == nil then return end
	for i = 1, #actIndexArr do
        local url = "Resources/operatingActivities/icon/"..actIndexArr[i]..".png"
        print("url +++++++++++>>>",url)
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(url) then
		    self.btnList[i] = ccui.ImageView:create(url,ccui.TextureResType.plistType)
        else
            self.btnList[i] = ccui.ImageView:create(url)
        end
        --红点需要
        self.btnArr[actIndexArr[i]] = self.btnList[i]

		self:addChild(self.btnList[i])

		if actIndexArr[i] == "first_pay" then
		    self.first_pay = self.btnList[i]
		    self.btnList[i].isFirstPay = 1
		elseif actIndexArr[i] == "heroic_racing" then
			self.label = cc.LabelTTF:create("", qy.res.FONT_NAME_2, 22)
			self.label:setPosition(45, - 3)
			self.label:enableShadow(cc.size(1, -1), 0.8, 0.8, true)
			self.label:setColor(cc.c3b(255, 0, 0))
			self.btnList[i]:addChild(self.label)
			self:showRacingTime()
		end
	end
	qy.tank.utils.TileUtil.arrange(self.btnList, 5, 105 ,130,cc.p(40,100))

	local actIndexArr = self.model:getIconList()
	for i = 1, #actIndexArr do
		self:OnClick(self.btnList[i],function(sender)
			if self.btnList[i].isFirstPay and self.btnList[i].isFirstPay == 1 then
				-- self.firstPay = true
				self.btnList[i]:setRotation(0)
				self.btnList[i]:stopAllActions()
			end
		--	qy.tank.command.ActivitiesCommand:showActivity(actIndexArr[i])
		end)
	end
end

function ActivitiesIcons:onExit()
    qy.RedDotCommand:removeSignal({
        qy.RedDotType.HER_RAC,
        qy.RedDotType.TORCH,
        qy.RedDotType.SINGLE_RECHARGE,
    })
end

function ActivitiesIcons:onEnter()
    qy.RedDotCommand:addSignal({
       [qy.RedDotType.HER_RAC] = self.btnArr[qy.RedDotType.HER_RAC],
       [qy.RedDotType.TORCH] = self.btnArr[qy.RedDotType.TORCH],
       [qy.RedDotType.SINGLE_RECHARGE] = self.btnArr[qy.RedDotType.SINGLE_RECHARGE],
   })
   qy.RedDotCommand:emitSignal(qy.RedDotType.HER_RAC, redModel:isHeroicRacingHasDot())
   qy.RedDotCommand:emitSignal(qy.RedDotType.TORCH, redModel:isTorchHasDot())
   qy.RedDotCommand:emitSignal(qy.RedDotType.SINGLE_RECHARGE, redModel:isSingleRechargeHasDot()) 
end

-- 显示首冲的动画
function ActivitiesIcons:showFirstPayAction()
	-- if self.first_pay and self.firstPay == false then
	if self.first_pay then
		self.first_pay:stopAllActions()
	    local func1 = cc.RotateTo:create(0.1, -8)
	    local func2 = cc.RotateTo:create(0.1, 8)
	    local func3 = cc.RotateTo:create(0.1, -8)
	    local func4 = cc.RotateTo:create(0.1, 8)
	    local func5 = cc.RotateTo:create(0.1, -8)
	    local func6 = cc.RotateTo:create(0.1, 8)
	    local func7 = cc.RotateTo:create(0.05, 0)
	    local func10 = cc.ScaleTo:create(0.1, 1.1)
		local func11 = cc.ScaleTo:create(0.1, 1)
	    local delay = cc.DelayTime:create(4)

	    local seq = cc.Sequence:create(func10, func1, func2, func3, func4, func5, func6, func7, func11, delay)
	    local func9 = cc.RepeatForever:create(seq)
	    self.first_pay:runAction(func9)
	end
end

function ActivitiesIcons:showRacingTime()
	if self.label and self.label:isVisible() then
		local model = qy.tank.model.OperatingActivitiesModel
		local time = model:getHeroicRacingLeftTime()
		if not time then
			self.label:setString("")
		else
			self.label:setString(qy.tank.utils.DateFormatUtil:toDateString(time, 4))
		end
	end
end

return ActivitiesIcons
