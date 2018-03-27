--[[--
--矿区view
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local MineView = qy.class("MineView", qy.tank.view.BaseView, "view/mine/MineView")

function MineView:ctor(delegate)
    MineView.super.ctor(self)
	self.delegate = delegate
	self.model = qy.tank.model.MineModel
	self.userInfoModel = qy.tank.model.UserInfoModel
	self.redDotModel = qy.tank.model.RedDotModel
	-- qy.tank.utils.cache.CachePoolUtil.addArmatureFile(qy.ResConfig.ORE_HEAP)

	--初始化ui
	self:__initView()
	--绑定点击事件
	self:__bindingClickEvent()
	self:updateViewData()
end

--[[--
--更新界面数据
--]]
function MineView:updateViewData()
	--更新进度条数据
	self:updateProgressData()
	--更新生产力
	self:updateProductivity()
	local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
	if self.model.mineEntity.owner.status == 1 then
		qy.alert:show(
		{qy.TextUtil:substitute(21010) ,{255,255,255} } ,
		{{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(21011),font=fontName,size=20} },
		cc.size(533 , 250) ,{ {qy.TextUtil:substitute(21012) , 5} } ,
		function(flag)
			self:returnToWork()
		end ,"")
	end
end

--[[--
--复工
--]]
function MineView:returnToWork()
	if self.isHarvestAnimShow then
		return
	end
	local service = qy.tank.service.MineService
    service:toWork(function(data)
		--进度条动画
		-- self:updateOreHeap()
		self.isHarvestAnimShow = true
		self:progressAnim()
		local _data = {}
		_data.tipTxt = qy.TextUtil:substitute(21013)
		_data.award = {["type"] = 3, ["num"] = self.model:getToWorkReward(),["icon"] = "Resources/common/icon/coin/3.png"}
		qy.hint:show(_data)
	end)
end

--[[--
--更新进度条数据
--]]
function MineView:updateProgressData()
	--进度条
	self.progressBar:setPercent(self.model.mineEntity:getProductPercent())
	--进度条内文字描述
	self.progressNum:setString(self.model.mineEntity:getProductNum())
end

--[[--
--更新生产力
--]]
function MineView:updateProductivity()
	--生产icon
	-- self.upgradeProduct:loadTexture(self.model.mineEntity:getProductIcon())
	--生产等级名称
	self.productLevel:setSpriteFrame(self.model.mineEntity:getProductIcon())
	-- self.productLevel:setTextColor(self.model.mineEntity:getProductivityColor())
	--生产力描述
	self.productDes:setString(self.model.mineEntity:getProductivityDes())
	self.productDes:setTextColor(self.model.mineEntity:getProductivityColor())
	--每小时产量
	self.curProductText:setString(self.model.mineEntity:getProductEveryHour())
	self.unit:setPosition(self.curProductText:getContentSize().width + self.curProductText:getPositionX() + 10, self.unit:getPositionY())
end

--[[--
--初始化ui
--]]
function MineView:__initView()
	self:InjectView("productLevel")
	self:InjectView("productDes")
	self.productDes:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("curProductTitle")
	self.curProductTitle:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("maxProductTitle")
	self.maxProductTitle:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("curProductText")
	self.curProductText:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("porductUnit")
	self.porductUnit:enableOutline(cc.c4b(0,0,0,255),1)

	self:InjectView("upgradeProduct")
	self:InjectView("progressBar")
	self:InjectView("progressNum")
	self.progressNum:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("unit")

	self:InjectView("silverTxt")
	self:InjectView("diamondTxt")
	self:InjectView("mineList")
	self:InjectView("redDot")
	self:InjectView("rareMineBtn")
end

--[[--
--绑定点击事件
--]]
function MineView:__bindingClickEvent()
	--关闭
	self:OnClick("exitBtn", function (sendr)
		if self.delegate and self.delegate.dismiss then
			self.delegate.dismiss()
		end
	end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

	--战报
	self:OnClick("grandBtn", function (sendr)
		-- qy.hint:show("战报开发中，敬请期待")
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PLUNDER_LOG)
	end)

	--帮助按钮
	self:OnClick("helpBtn", function (sendr)
		qy.tank.view.common.HelpDialog.new(4):show(true)
	end)

	--稀有矿
	self:OnClick("rareMineBtn", function (sendr)
		if self.delegate and self.delegate.enterRareMineView then
			self.delegate.enterRareMineView()
		end
    	end, {["isScale"] = false})

	--掠夺
	self:OnClick("plunderBtn", function (sendr)
		if self.delegate and self.delegate.enterPlunderView then
			self.delegate.enterPlunderView()
		end
	end)

	--升级生产力
	self:OnClick("upgradeProduct", function (sendr)
		local _vip = self.model.mineEntity:getVipLevelForUpgradeProductivity()
		local _nextLevel = self.model.mineEntity.productLevel + 1
		local _name = self.model.mineEntity:getProductivityName(_nextLevel)
		local _percentTxt  = self.model.mineEntity:getProductivityPercent(_nextLevel)
		if  qy.tank.model.UserInfoModel.userInfoEntity.vipLevel < _vip then
			qy.hint:show("VIP" .. _vip .. qy.TextUtil:substitute(21014).._name)
            return
		end

		if self.model.mineEntity.productLevel < 5 then
			self.content = qy.tank.view.mine.UpgradeMineTip.new({
				["type"] = 1,
				["entity"] = self.model.mineEntity,
				["percentTxt"] = _percentTxt,
			})

			local function callBack(flag)
				if qy.TextUtil:substitute(21012) == flag then
					self:upgradeProductivity()
				end
			end

			qy.alert:showWithNode(qy.TextUtil:substitute(21015),  self.content, cc.size(560,250), {{qy.TextUtil:substitute(21016) , 4},{qy.TextUtil:substitute(21012) , 5} }, callBack, {})

		else
			qy.hint:show(qy.TextUtil:substitute(21017))
		end
	end)

	--收获
	self:OnClick("harvestBtn", function (sendr)
		local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
		if self.model.mineEntity.owner.status == 1 then
			qy.alert:show(
				{qy.TextUtil:substitute(21010) ,{255,255,255} } ,
				{{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(21018),font=fontName,size=20} },
				cc.size(533 , 250) ,{ {qy.TextUtil:substitute(21012) , 5} } ,
				function(flag)
					self:returnToWork()
			end ,"")
			return
		end
		if self.model.mineEntity:canHarvest() then
			if self.isHarvestAnimShow then
				return
			end
			local service = qy.tank.service.MineService
        		service:harvest(function(data)
        			self.redDotModel:cancelMineDot()
					--进度条动画
					self.isHarvestAnimShow = true
					self:progressAnim()
			end)
        else
        	qy.hint:show(qy.TextUtil:substitute(21019))
        end
	end)
end

--[[--
--提升生产力
--]]
function MineView:upgradeProductivity()
	local service = qy.tank.service.MineService
    service:upgradeProduct(function(data)
        self:updateProductivity()
        self:updateProgressData()
        qy.hint:show(qy.TextUtil:substitute(21020))
	end)
end

--[[--
--进度条动画
--]]
function MineView:progressAnim()
	self.times = 1
	self.progressBar:stopAllActions()
	local callFun = cc.CallFunc:create(function()
		if self.progressBar and self.progressBar:getPercent() > 0 then
			local per = self.model:getProgressPercent()
			self.progressBar:setPercent(per)
			-- self:hideAllHeap(self.times)
			self.times = self.times + 1
			-- self:updateMineInfo()
		else
			self:updateMineData()
			self.progressBar:stopAllActions()
			self.isHarvestAnimShow = false
			self.__updateTime = -1
		end
	end)
	local delay = cc.DelayTime:create(0.01)
	local  seq = cc.Sequence:create(callFun,delay)
	self.progressBar:runAction(cc.RepeatForever:create(seq))
	self.model:setProgressPercent(self.model.mineEntity:getProductPercent())
end

--[[--
--更新矿区信息
--]]
function MineView:updateMineInfo()
	local productPercent = self.model.mineEntity:getProductPercent()
	print("+++++++++++++++++++:updateMineInfo()==" .. productPercent)
	if productPercent >= 80 then
		-- self:showOrHideOreHeap(3)
		self:__showEffert(0)
	elseif productPercent >= 50 and productPercent < 80 then
		self:__showEffert(1)
		-- self:showOrHideOreHeap(2)
	elseif productPercent >= 10 and productPercent < 50 then
		self:__showEffert(2)
		-- self:showOrHideOreHeap(1)
	elseif self.currentEffert then
		self.mineList:removeChild(self.currentEffert)
        self.currentEffert = nil
	end
end

function MineView:updateMineData()
	self.model.mineEntity:updateCurrentProduct()
	--进度条数据
	self:updateProgressData()
	self:updateMineInfo()
end

--[[--
--更新矿区时间
--]]
function MineView:updateMineTime()
	if self.__updateTime == nil or self.userInfoModel.serverTime - self.__updateTime > 60 then
		self:updateMineData()
		self.__updateTime = self.userInfoModel.serverTime
	end
end

--[[--
--更新油料
--]]
function MineView:updateOil()
end

function MineView:setRareMineRedDot()
	self.redDot:setVisible(self.redDotModel:isRareMineHasDot())
end

--[[--
--更新用户资源
--]]
function MineView:updateResource()
	self.silverTxt:setString(qy.tank.model.UserInfoModel.userInfoEntity:getSilverStr())
	self.diamondTxt:setString(qy.tank.model.UserInfoModel.userInfoEntity:getDiamondStr())
end

function MineView:__showEffert(index)
    if not tolua.cast(self.currentEffert,"cc.Node") then
        self.currentEffert = ccs.Armature:create("gold_1")
        self.mineList:addChild(self.currentEffert,-1)
        self.currentEffert:setPosition(33,100)
    end

    self.currentEffert:getAnimation():playWithIndex(index)
end

-- 稀有矿区流光
function MineView:showRareAction()
	 if qy.tank.model.UserInfoModel.userInfoEntity.level >= 24 and qy.tank.model.UserInfoModel.userInfoEntity.level <= 45 then
        local position = self.rareMineBtn:getParent():convertToWorldSpace(cc.p(self.rareMineBtn:getPositionX(),self.rareMineBtn:getPositionY()))
        if not self.sprite then
            self.sprite = cc.Sprite:createWithSpriteFrameName("Resources/mine/diggings_icon_0014.png")
            self.sprite:setPosition(position.x , position.y)
        end

        if not self.rareLine then
            self.rareLine = cc.Sprite:createWithSpriteFrameName("Resources/main_city/q2.png")
            self.sprite:addChild(self.rareLine)
            self.rareLine:setPositionY(0)
        end

        local func2 = cc.CallFunc:create(function()
            self.rareLine:setPositionX(110)
        end)
        local func1 = cc.MoveTo:create(1, cc.p(400, 0))
        local func4 = cc.DelayTime:create(5)
        local seq = cc.Sequence:create(func1, func2, func4)
        local func3 = cc.RepeatForever:create(seq)
        self.rareLine:runAction(func3)

        if not self.clip then
            local sprite = cc.Sprite:createWithSpriteFrameName("Resources/common/img/shade1.png")
            self.clip = cc.ClippingNode:create()
            self.clip:setInverted(false)
            self.clip:setAlphaThreshold(0)
            self:addChild(self.clip)
            self.clip:addChild(self.sprite)
            sprite:setPosition(self.sprite:getPositionX() + 15, self.sprite:getPositionY() - 37)

            self.clip:setStencil(sprite)
        end
    else
        if self.clip then
            self.clip:removeSelf()
            self.clip = nil
        end
    end
end

function MineView:onEnter()
	print("MineView:onEnter()=============>>>>>>>>>>>")
	self:setRareMineRedDot()

	qy.tank.utils.cache.CachePoolUtil.addArmatureFile(qy.ResConfig.ORE_HEAP)
	-- self:__showEffert()
	self:updateResource()
	--用户充值数据更新
    self.userRechargeDatalistener = qy.Event.add(qy.Event.USER_RECHARGE_DATA_UPDATE,function(event)
        self:updateResource()
    end)
    --用户资源数据更新
    self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
        self:updateResource()
    end)
	--更新矿堆
	-- self:updateOreHeap()
	self:updateMineTime()

	self:showRareAction()
end

function MineView:onExit()
	--移除控件的动画
	self:removeUiAmin()
	qy.Event.remove(self.userRechargeDatalistener)
	qy.Event.remove(self.userResourceDatalistener)
	qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.ORE_HEAP)
end

function MineView:removeUiAmin()
	self.progressBar:stopAllActions()
end

return MineView
