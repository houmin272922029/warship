--[[--
	合金嵌入
	Author: H.X.Sun
--]]--

local EmbeddedView = qy.class("EmbeddedView", qy.tank.view.BaseView, "alloy/ui/EmbeddedView")

function EmbeddedView:ctor(delegate)
	EmbeddedView.super.ctor(self)

	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "alloy/res/alloy_embedded_title.png",
        showHome = true,
        ["onExit"] = function()
            self.model:clearUpSelectStatus()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style, 13)
    self.model = qy.tank.model.AlloyModel
	--一键和金开启等级
	local batchUpAlloyVipLevel = qy.tank.model.VipModel:getBatchUpAlloyVipLevel()
	local UserInfoModel = qy.tank.model.UserInfoModel
    local service =require("alloy.src.AlloyService")
    self.entity = self.model:getSelectAlloyByIndex(delegate.alloyId,delegate.equipEntity.unique_id)

    self:InjectView("bg")
    self:InjectView("icon")
    self:InjectView("name")
    self:InjectView("level")
    self:InjectView("current_txt")
    self:InjectView("next_txt")
    self:InjectView("bar_bg")
    self:InjectView("pre_bar")
    self.level:setVisible(qy.language == "cn")
    self.iconX = self.icon:getPositionX()
    self.iconY = self.icon:getPositionY()

    self.bar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("alloy/res/exp.png"))
    self.bar:setScaleX(1.08)
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar:setMidpoint(cc.p(0,0))
    self.bar:setBarChangeRate(cc.p(1, 0))
    self.bar:setPosition(140,21.5)
    self.bar_bg:addChild(self.bar)

    for i = 1, 5 do
        self:InjectView("a_bg_"..i)
        self:InjectView("alloy_"..i)
        self:OnClick("a_bg_"..i,function()
            delegate.showEmbeddedList()
        end,{["isScale"] = false})
    end

    self:OnClick("auto_btn",function()
        if self.entity.level == self.model.MAX_Level then
            qy.hint:show(qy.TextUtil:substitute(41017))
			return
        end
		self.model:clearUpSelectStatus()
		if self.model:getUnSelectNumByIndex(self.entity.alloy_id) == 0 or self.model:isAllSelect(self.entity.alloy_id) then
            qy.hint:show(qy.TextUtil:substitute(41018))
        else
            self.model:autoSelect(self.entity)
            self:updateSelectView()
            self:updatePerBar()
        end
    end,{["isScale"] = false})

    local function __upgradeLogic()
        local start = self.entity:getUpExpPercent()
        local level = self.entity.level
        service:upgrade(self.entity,function ()
            self:showEffect(function ()
                self.model:clearUpSelectStatus()
                self:updateSelectView()
                self:showBar({
                    ["start"] = start,
                    ["end"] = self.entity:getUpExpPercent(),
                    ["hasNext"] = self.entity.level - level > 0,
					["hasHint"] = true,
                },function ()
                    qy.QYPlaySound.playEffect(qy.SoundType.TANK_UPGRADE)
                    qy.hint:showImageToast(cc.Sprite:createWithSpriteFrameName("alloy/res/upgrade_success.png"),3,2,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.6))
                    qy.tank.utils.HintUtil.showSomeImageToast(self.model:getAddAttribute(self.entity.alloy_id),cc.p(qy.winSize.width / 2, qy.winSize.height * 0.7))
                    self:updateAlloyView(false)
					self:updatePerBar()
                end)
            end)
        end)
    end

    self:OnClick("upgrade_btn",function()
        if self.isShowAnima then
            return
        end
        if self.entity.level == self.model.MAX_Level then
            qy.hint:show(qy.TextUtil:substitute(41017))
        elseif #self.model:getUpSelectStatus() == 0 then
            qy.hint:show(qy.TextUtil:substitute(41019))
        else
            local diffExp = self.model:expExpectMoreMax(self.entity, self.model:getSelectUpExp(self.entity.alloy_id))
            if diffExp < 0 then
                 delegate.showTips(diffExp,function ()
                    __upgradeLogic()
                 end)
            else
                __upgradeLogic()
            end
        end
    end,{["isScale"] = false})

	local function callBack(flag)
		if flag == qy.TextUtil:substitute(70054) then
			local start = self.entity:getUpExpPercent()
	        local level = self.entity.level
			service:batchUpgrade(self.entity,function ()
				self.model:clearUpSelectStatus()
				self:updatePerBar()
				self:showBar({
                    ["start"] = start,
                    ["end"] = self.entity:getUpExpPercent(),
                    ["hasNext"] = self.entity.level - level > 0,
					["hasHint"] = false,
                },function ()
					self:updatePerBar()
					self:updateAlloyView(false)
                end)
				require("alloy.src.UpSuccessDialog").new(self.batchData):show(true)
			end)
		end
	end

	local alertMesg = {
		{id=1,color={255,255,255},alpha=255,text="\n             您确定要一键升级吗？",font=qy.res.FONT_NAME_2,size=24},
		{id=2,color={47,235,42},alpha=255,text="\n          (一键升级只消耗4级以下的合金)",font=qy.res.FONT_NAME_2,size=24},
	}

	self:OnClick("all_btn",function()
		if batchUpAlloyVipLevel > UserInfoModel.userInfoEntity.vipLevel then
			qy.hint:show("vip"..batchUpAlloyVipLevel.."开启此功能")
			return
		end
		self.model:clearUpSelectStatus()
		self.batchData = self.model:getBatchDataByIndex(self.entity.alloy_id)
		if #self.batchData == 0 then
            qy.hint:show("没有闲置的4级以下的合金")
			self.model:restoreSelectIdx()
		else
			self:updateSelectView(true)
	        qy.alert:show({qy.TextUtil:substitute(41010) ,{255,255,255} }  ,  alertMesg , cc.size(530 , 280),{{qy.TextUtil:substitute(70057) , 4}   , {qy.TextUtil:substitute(70054) , 5}} ,callBack,"")
		end
	end)

    self:updateAlloyView(true)
end

function EmbeddedView:updatePerBar()
    -- print("self.model:getSelectExpPercent(self.entity)==>>>",self.model:getSelectExpPercent(self.entity))
    -- print("self.entity==>>>",self.entity:getUpExpPercent())
    self.pre_bar:setPercent(tostring(self.model:getSelectExpPercent(self.entity)))
end

function EmbeddedView:showEffect(callback)
    self.isShowAnima = true
    local function __showEffert2()
        if self.effertArr[6] == nil then
            self.effertArr[6] = ccs.Armature:create("ui_fx_hejin02")
            self.effertArr[6]:setPosition(self.icon:getPosition())
            self.bg:addChild(self.effertArr[6],999)
        end

        self.effertArr[6]:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                callback()
                self.isShowAnima = false
            end
        end)
        self.effertArr[6]:getAnimation():playWithIndex(0)
    end

    local function __move(i)
        self.lightArr[i]:runAction(cc.Sequence:create(
            cc.MoveTo:create(0.5,cc.p(self.iconX,self.iconY)),
            cc.CallFunc:create(function ()
                self.lightArr[i]:setVisible(false)
                if i == 1 then
                    __showEffert2()
                end
            end)
        ))
    end

    local function __showEffert(i)
        if self.effertArr == nil then
            self.effertArr = {}
        end
        if self.effertArr[i] == nil then
            self.effertArr[i] = ccs.Armature:create("ui_fx_hejin01")
            self.effertArr[i]:setPosition(51,49)
            self["a_bg_"..i]:addChild(self.effertArr[i],999)
        end
		qy.QYPlaySound.playEffect(qy.SoundType.ROLE_UP)
        self.effertArr[i]:getAnimation():playWithIndex(0)

        local seq = cc.Sequence:create(cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function ()
            if self.lightArr == nil then
                self.lightArr = {}
            end
            if self.lightArr[i] == nil then
                self.lightArr[i] = cc.Sprite:create("alloy/fx/light.png")
                self.bg:addChild(self.lightArr[i])
            else
                self.lightArr[i]:setVisible(true)
            end
            self.lightArr[i]:setPosition(self["a_bg_"..i]:getPosition())
            __move(i)
        end))
        self["alloy_"..i]:runAction(seq)
    end

    local num = #self.model:getUpSelectStatus()
    for i = 1, num do
        __showEffert(i)
    end
end

function EmbeddedView:showBar(data,func)
    local durt = 0.5
    self.bar:setPercentage(data["start"])
    local callback = cc.CallFunc:create(function()
        self.bar:setPercentage(data["end"])
        -- func()
    end)

    local seq = nil
    if data.hasNext then
        local to = cc.ProgressTo:create(durt,100)
        local to2 = cc.ProgressTo:create(durt,data["end"])
        seq = cc.Sequence:create(to, cc.CallFunc:create(function()
            func()
            self.bar:setPercentage(0)
        end),to2,tocallback)
    else
        local to = cc.ProgressTo:create(durt,data["end"])
        seq = cc.Sequence:create(to,cc.CallFunc:create(function()
            -- func()
			if data.hasHint then
            	qy.hint:show(qy.TextUtil:substitute(41020)..self.model:getAddExp())
			end
        end),callback)
    end
    self.bar:runAction(seq)
end

function EmbeddedView:updateAlloyView(isUpdateBar)
    self.icon:setTexture(self.entity:getIcon())
    self.name:setString(self.entity:getName())
    local color = self.entity:getColor()
    self.name:setTextColor(color)
    self.level:setString("Lv."..self.entity.level)
    self.level:setTextColor(color)
    self.current_txt:setString(qy.TextUtil:substitute(41021) .. "  " ..self.entity:getAttributeDesc())
    self.next_txt:setString(qy.TextUtil:substitute(41022) .. "  " ..self.entity:getNextLevelAttriDesc())
    if isUpdateBar then
        self.bar:setPercentage(self.entity:getUpExpPercent())
    end
    -- self.pre_bar:setPercent(self.entity:getUpExpPercent())
end

--param _isClear:true 表示清空列表，false：是现在选中的合金，默认是 false
function EmbeddedView:updateSelectView(_isClear)
    local arr = {}
	if not _isClear then
		arr = self.model:getUpSelectStatus()
	end
    for i = 1, 5 do
        -- print("i===========>>>",i)
        self["alloy_"..i]:setOpacity(255)
        if i > #arr then
            --未选中
            local time = 1
            self["alloy_"..i]:setSpriteFrame("alloy/res/hjqr_0019.png")
            local scaleSmall = cc.ScaleTo:create(time,0.9)
            local scaleBig = cc.ScaleTo:create(time,1)
            local FadeIn = cc.FadeTo:create(time, 255)
            local FadeOut = cc.FadeTo:create(time, 0)
            local spawn1 = cc.Spawn:create(scaleSmall,FadeOut)
            local spawn2 = cc.Spawn:create(scaleBig,FadeIn)
            local seq = cc.Sequence:create(spawn1, spawn2)
            self["alloy_"..i]:runAction(cc.RepeatForever:create(seq))
        else
            --选中
            self["alloy_"..i]:stopAllActions()
            self["alloy_"..i]:setScale(1)
            self["alloy_"..i]:setOpacity(255)
            self["alloy_"..i]:setTexture(self.model:getUnSelectEntityByIndex(self.entity.alloy_id,arr[i]):getIcon())
        end
    end
end

function EmbeddedView:onEnter()
    self:updateSelectView()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileByModules("alloy/fx/ui_fx_hejin01")
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileByModules("alloy/fx/ui_fx_hejin02")
    self:updatePerBar()
end

function EmbeddedView:onExit()
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("alloy/fx/ui_fx_hejin01")
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("alloy/fx/ui_fx_hejin02")
end

return EmbeddedView
