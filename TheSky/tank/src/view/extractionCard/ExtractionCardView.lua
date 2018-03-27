-- 抽卡入口

local ExtractionCardView = qy.class("ExtractionCardView", qy.tank.view.BaseView, "view/extractionCard/ExtractionCardView")

function ExtractionCardView:ctor(delegate)
    ExtractionCardView.super.ctor(self)

    self.delegate = delegate
    self.userModel = qy.tank.model.UserInfoModel
    self.model = qy.tank.model.ExtractionCardModel
    self.storeModel = qy.tank.model.StorageModel
    self.serverTime = self.userModel.serverTime
    self.service = qy.tank.service.ExtractionCardService

    self:InjectView("icon_hd_2")
    self:InjectView("timeTxt1")
    self:InjectView("timeTxt2")
    self:InjectView("needItemTxt")
    self:InjectView("silverTxt")
    self:InjectView("diamondTxt")
    self:InjectView("leftBtn0")
    self:InjectView("leftBtn1")
    self:InjectView("leftBtn2")
    self:InjectView("rightBtn0")
    self:InjectView("rightBtn1")
    self:InjectView("rightBtn2")
    self:InjectView("closeBtn")
    self:InjectView("Image_1_0")
    self:InjectView("awardBtn")
    self:InjectView("CK_11_3")
    self:InjectView("Sprite_14")

    self.Sprite_14:setVisible(self.model.diamond_times == 0)
    if qy.language == "cn" then
        self.icon_hd_2:setVisible(self.model.redpoint == 1)
    end
    self:init()
end

function ExtractionCardView:initBtns()
    self:OnClick("closeBtn", function(sender)
        self.delegate:dismiss()
        qy.GuideManager:next(956)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    self:OnClick("shopBtn", function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SHOP)
    end)

    self:OnClick("leftBtn0", function(sender)
        self:getCards(1 , 0 )
    end)

    self:OnClick("leftBtn1", function(sender)
        self:getCards(1 , 1 )
    end)

    self:OnClick("leftBtn2", function(sender)
        self:getCards(1 , 2 )
    end)

    self:OnClick("rightBtn0", function(sender)
        self:getCards(2 , 0 )
    end)

    self:OnClick("rightBtn1", function(sender)
        self:getCards(2 , 1 )
    end)

    self:OnClick("rightBtn2", function(sender)
        self:getCards(2 , 2 )
    end)

    self:OnClick("awardBtn", function(sender)
        self.delegate.showAwardView()
    end)
end

-- 调取接口
function ExtractionCardView:getCards(side , type)
    self:disableButton(side)
    local param = {}
    local isTen = false
    param["type"] = type
    if type == 2 then
        isTen = true
    end
    if side == 1 then
        local num = type == 2 and 10 or 1
        if self.storeModel:enough(10, num) or type == 0 then
            if #qy.tank.model.GarageModel.totalTanks >= 500 then
                qy.hint:show(qy.TextUtil:substitute(90308))
                for i = 0, 2 do
                    self["leftBtn" .. i]:setEnabled(true)
                    self["rightBtn" .. i]:setEnabled(true)
                end
            else
                self.service:getCardsType1(param,function(data)
                    if data.is_max_num and data.is_max_num >= 1 then
                        for i = 0, 2 do
                            self["leftBtn" .. i]:setEnabled(true)
                            self["rightBtn" .. i]:setEnabled(true)
                        end
                        qy.hint:show(qy.TextUtil:substitute(90308))
                        return
                    end


                    if type == 1 then
                        self.storeModel:remove(10 , 1)
                    end
                    if type == 2 then
                        self.storeModel:remove(10 , 10)
                    end
                    self:resetTime()
                    self:dealResult(data , isTen , side)

                    
                end)
            end
        else
            qy.hint:show(qy.TextUtil:substitute(12001))

            for i = 0, 2 do
                self["leftBtn" .. i]:setEnabled(true)
                self["rightBtn" .. i]:setEnabled(true)
            end

            local entity = qy.tank.model.PropShopModel:getShopPropsEntityById(7)
            local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                local service = qy.tank.service.ShopService
                service:buyProp(entity.id,num,function(data)
                    -- service = nil
                    -- -- self:updateResource()
                    if data and data.consume then
                        qy.hint:show(qy.TextUtil:substitute(12002).."x"..data.consume.num)
                    end

                    

                    -- qy.tank.command.AwardCommand:add(data.award)
                    -- self:showDetailInfo(self.model.list[self.selectIdx])
                    self:updateProps()
                end)
            end)
            buyDialog:show(true)
        end
    else
        if self.model:testDiamond(isTen) or param.type == 0 then
            if #qy.tank.model.GarageModel.totalTanks >= 500 then
                qy.hint:show(qy.TextUtil:substitute(90308))
                for i = 0, 2 do
                    self["leftBtn" .. i]:setEnabled(true)
                    self["rightBtn" .. i]:setEnabled(true)
                end
            else
                self.service:getCardsType2(param,function(data)
                    if data.is_max_num and data.is_max_num >= 1 then
                        for i = 0, 2 do
                            self["leftBtn" .. i]:setEnabled(true)
                            self["rightBtn" .. i]:setEnabled(true)
                        end
                        qy.hint:show(qy.TextUtil:substitute(90308))
                        return
                    end

                    self:showActions()
                    local func1 = cc.CallFunc:create(function()
                        self:dealResult(data , isTen , side)
                        qy.GuideManager:next(980)
                    end)

                    local func2 = cc.DelayTime:create(1.5)
                    local seq = cc.Sequence:create(func2, func1)
                    self:resetTime()
                    self:runAction(seq)

                end)
            end
        else
            -- qy.hint:show("钻石不足")
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.DIAMOND_NOT_ENOUGH)
            for i = 0, 2 do
                self["leftBtn" .. i]:setEnabled(true)
                self["rightBtn" .. i]:setEnabled(true)
            end
        end
    end
end

-- 禁止按钮点击
function ExtractionCardView:disableButton(side)
    -- local time = side == 1 and 0.5 or 2
    for i = 0, 2 do
        self["leftBtn" .. i]:setEnabled(false)
        self["rightBtn" .. i]:setEnabled(false)
    end

    -- local delay = cc.DelayTime:create(time)
    -- local func2 = cc.CallFunc:create(function()

    -- end)
    -- local seq = cc.Sequence:create(delay, func2)
    -- self:runAction(seq)
end

-- 重置倒计时
function ExtractionCardView:resetTime()
    if self.timer1 ~=nil then
        self.timer1:stop()
    end

    if self.timer2 ~=nil then
        self.timer2:stop()
    end
    self.timer1 = nil
    self.timer2 = nil
    self:createTimer1()
    self:createTimer2()
end

--处理抽卡结果逻辑
function ExtractionCardView:dealResult(data , isTen , side)
    qy.tank.command.AwardCommand:add(data.award)
    self.delegate.showResult(
        data.award ,
        isTen,
        side ,
        function()
            self:updateUserInfo()
            self:updateProps()
        end
    )
end

-- 处理成就奖励入口按钮
function ExtractionCardView:updateAchevement()
    if #self.model.cfg == #self.model.achievement_award_list then
        self.awardBtn:setVisible(false)
        self.CK_11_3:removeAllChildren()
        self.icon_hd_2:setVisible(false)
    end
end

-- 初始化
function ExtractionCardView:init()
    self:initBtns()
    self:createTimer1()
    self:createTimer2()
    self:updateUserInfo()
    self.isInit = true
end

--创建定时器1
function ExtractionCardView:createTimer1()
    self.remainTime1 = self.model.cdTime1 - self.model.serviceTime

    if self.remainTime1 <=0 then
        self.timer1 = nil
        self:updateCardInfo1(0)
        return
    end
    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,self.remainTime1,function(leftTime)
            self:updateCardInfo1(leftTime)
        end)
        self.timer1:start()
    end
    self:updateCardInfo1(self.remainTime1)
end

--更新左侧抽卡相关数据  leftTime 是剩余时间哈
function ExtractionCardView:updateCardInfo1(leftTime)
    self.leftBtn0:setVisible(false)
    self.leftBtn1:setVisible(false)
    if leftTime > 0 and self.model.leftTimes1>0 then
        local timeStr = qy.TextUtil:substitute(12004, qy.tank.utils.DateFormatUtil:toDateString(leftTime))
        self.timeTxt1:setString(timeStr)
    else
        self.timeTxt1:setString(qy.TextUtil:substitute(12005)..self.model.leftTimes1..qy.TextUtil:substitute(12006))
    end

    self:updateProps()

    if self.model.leftTimes1>0 and leftTime ==0 then
        self.leftBtn0:setVisible(true)
    else
        self.leftBtn1:setVisible(true)
    end
end

function ExtractionCardView:updateProps()
    local item = self.storeModel:getEntityByID(10)
    local num = item == nil and 0 or item.num
    self.needItemTxt:setString(qy.TextUtil:substitute(12003)..num)
    self.Sprite_14:setVisible(self.model.diamond_times == 0)
end

--创建定时器2
function ExtractionCardView:createTimer2()
    self.remainTime2 = self.model.cdTime2 - self.model.serviceTime
    if self.remainTime2 <=0 then
        self.timer2= nil
        self:updateCardInfo2(0)
        return
    end
    if self.timer2 == nil then
        self.timer2 = qy.tank.utils.Timer.new(1,self.remainTime2,function(leftTime)
            self:updateCardInfo2(leftTime)
        end)
        self.timer2:start()
    end
    self:updateCardInfo2(self.remainTime2)
end

--更新右侧抽卡相关数据
function ExtractionCardView:updateCardInfo2(leftTime)
    self.rightBtn0:setVisible(false)
    self.rightBtn1:setVisible(false)
    if leftTime > 0 then
        local timeStr = qy.TextUtil:substitute(12004, qy.tank.utils.DateFormatUtil:toDateString(leftTime))
        self.timeTxt2:setString(timeStr)
        self.rightBtn1:setVisible(true)
    else
        self.timeTxt2:setString(qy.TextUtil:substitute(12009))
        self.rightBtn0:setVisible(true)
    end
end

-- 显示抽卡动画
function ExtractionCardView:showActions()
    if not self.effect then
        self.effect = ccs.Armature:create("ui_fx_chouka")
        self.Image_1_0:addChild(self.effect)
        self.effect:setPosition(180, 70)
    end
    self.effect:setVisible(true)
    self.effect:getAnimation():playWithIndex(0)
    self.effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then

            if self.layer and tolua.cast(self.layer,"cc.Node") then
                self.layer:removeFromParent()
                self.layer = nil
            end

            self.layer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))

            qy.App.runningScene.controllerStack:addChild(self.layer)
            self.layer:setOpacity(225)

            local seq = cc.Sequence:create(cc.DelayTime:create(0.3), cc.FadeOut:create(0.5))
            self.layer:runAction(seq)
            self.effect:setVisible(false)
        end
    end)
end

--更新用户数据
function ExtractionCardView:updateUserInfo()
--    self.energyTxt:setString(self.userModel.userInfoEntity.energy.."/"..self.model.userInfoEntity.energyLimit)
    self.silverTxt:setString(self.userModel.userInfoEntity:getSilverStr())
    self.diamondTxt:setString(self.userModel.userInfoEntity:getDiamondStr())
end

function ExtractionCardView:__showEffert()
    if self.currentEffert == nil then
        self.currentEffert = ccs.Armature:create("ui_fx_tishi")
        self.CK_11_3:addChild(self.currentEffert)
        self.currentEffert:setPosition(40  ,411)
    end
    self.currentEffert:getAnimation():playWithIndex(0)
    self:updateAchevement()
end

function ExtractionCardView:onEnter()
    --新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.rightBtn0, ["step"] = {"SG_53"}},
        {["ui"] = self.closeBtn, ["step"] = {"SG_56"}},
    })

    self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
        self:updateUserInfo()
    end)

    for i = 0, 2 do
        self["leftBtn" .. i]:setEnabled(true)
        self["rightBtn" .. i]:setEnabled(true)
    end

    if qy.language == "cn" then
        self.icon_hd_2:setVisible(self.model.redpoint == 1)
    end -- 领奖入口推送图标状态

    -- 成就奖励

    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.RECRUIT_ACHIEVEMENT,function()
        if qy.language == "cn" then
            self:__showEffert()
        end
    end)
end

function ExtractionCardView:onExit()
    --新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_53","SG_56"})

    qy.Event.remove(self.userResourceDatalistener)

    -- 成就奖励

    self.CK_11_3:removeAllChildren()
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.RECRUIT_ACHIEVEMENT)
    self.currentEffert = nil
end
return ExtractionCardView
