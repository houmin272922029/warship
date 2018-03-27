local BattleResultView = qy.class("BattleResultView", qy.tank.view.BaseDialog,"view/battle/BattleResultView")

-- BattleResultView.__create = function(theme)
--     return BattleResultView.super.__create(, "view/battle/" .. theme)
-- end

function BattleResultView:ctor(delegate)
    BattleResultView.super.ctor(self)
    self:setCanceledOnTouchOutside(false)
    self.isPopup = false
    self.channel = qy.tank.utils.SDK:channel()

    -- 通用
    self:InjectView("panel")
    self:InjectView("figure")
    self:InjectView("title")
    self:InjectView("shareBtn")
    self:InjectView("replayBtn")
    self:InjectView("click_tip")
    self.click_tip:setVisible(false)

    if qy.language == "en" then
        self:InjectView("titleBg")
    end
    -- 胜利
    self:InjectView("winNode")
    self:InjectView("winBg")

    -- 失败
    self:InjectView("failNode")
    self:InjectView("tipTitle")
    for i=1,3 do
        self:InjectView("item"..i)
        self["item"..i]:setVisible(false)
    end

    -- 经典战役
    self:InjectView("additionNode")
    self:InjectView("getBtn")
    self:InjectView("getBtn3")
    self:InjectView("consume3")
    self:InjectView("remain3")
    self.consume3:setString("60")

    self.panel:setSwallowTouches(false)
    self.userInfo = qy.tank.model.UserInfoModel
    self.model = qy.tank.model.BattleModel
    self.classicModel = qy.tank.model.ClassicBattleModel

    self:OnClick("shareBtn", function()
        -- delegate.share()
        if channel == "google" and qy.language == "en" then
            qy.tank.view.battle.BattleShareDialog.new():show()
        else
            qy.tank.service.BattleService:share(function()
                qy.hint:show(qy.TextUtil:substitute(5001))
            end)
        end
    end)

    self:OnClick("replayBtn", function()
        delegate.replay()
    end)

    self.delegate = delegate
    self:OnClick(self.mask, function()
        if self.isCanceledOnTouchOutside then
            print("++++++++++++++caonima",self.model.totalBattleData.ext.is_history)
            if self.model.totalBattleData.ext.is_history and self.model.totalBattleData.ext.is_history == 1 then -- 傻逼战报
                self:dismiss()
                delegate.confirm()
            else
                if self.model.fight_type == 2 and self.model.isWin == 1 then
                    -- 经典战役胜利界面屏蔽点击其他区域退出
                else
                    self:dismiss()
                    delegate.confirm()
                end
            end
        end
    end,{["isScale"] = false, ["hasAudio"] = false})

    -- self:OnClick("cover", function()
    --     if self.model.fight_type == 2 and self.model.isWin == 1 then
    --         -- 经典战役胜利界面屏蔽点击其他区域退出
    --     else
    --         self:dismiss()
    --         delegate.confirm()
    --     end
    -- end,{["isScale"]=false})

    self:OnClick("getBtn", function()
        local service = qy.tank.service.ClassicBattleService
        service:getrewards(1,self.model.classic_id,function(data)
            self:dismiss()
            delegate.confirm(data)
            self.classic_award = data.award
            self.awardDelay = qy.tank.utils.Timer.new(0.2,1,function()
                qy.Event.dispatch(qy.Event.BATTLE_AWARDS_SHOW,data)
            end)
            self.awardDelay:start()
        end)
    end)

    self:OnClick("getBtn3", function()
        -- 经典战役3倍领取花费 60 钻石，
        --不引导直接充值，是因为跳转到充值界面再回来时战斗会重播
        if self.userInfo.userInfoEntity.diamond >= 60 then
            local service = qy.tank.service.ClassicBattleService
            service:getrewards(3,self.model.classic_id,function(data)
                self:dismiss()
                delegate.confirm(data)
                self.awardDelay = qy.tank.utils.Timer.new(0.2,1,function()
                    qy.Event.dispatch(qy.Event.BATTLE_AWARDS_SHOW,data)
                end)
                self.awardDelay:start()
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(70042))
        end
    end)
end

function BattleResultView:onEnter()
    self.shareBtn:setVisible(false)
    self.replayBtn:setVisible(false)
    self.winBg:setVisible(false)

    -- figure
    local x,y = self.figure:getPosition()
    local size = self.figure:getContentSize()
    self.figure:setPosition(x-400,y)
    self.figure:setOpacity(0)

    local act1 = cc.FadeIn:create(0.5)
    -- local act2 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.5,cc.p(x,y)))
    local act2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(x,y)))
    local spawn1 = cc.Spawn:create(act1,act2)
    self.figure:runAction(cc.Sequence:create(spawn1,cc.CallFunc:create(function()
        if not qy.isNoviceGuide then
            if self.model.totalBattleData.ext.is_history and self.model.totalBattleData.ext.is_history == 1 then
                self.shareBtn:setVisible(false)
            elseif self.model.battleData.fight_type == 17 or self.model.battleData.fight_type == 18 or self.model.battleData.fight_type == 22 then
                --战斗类型 17(跨服战) :屏蔽分享按钮
                self.shareBtn:setVisible(false)
            else
                self.shareBtn:setVisible(true)
            end
            self.replayBtn:setVisible(true)
        end
        -- AppStore 审核
        if qy.isAudit and qy.product == "sina" then
            self.shareBtn:setVisible(false)
        end
    end)))

    if self.model.isWin == 0 then
        self:renderFail()
    elseif self.model.isWin == 1 then
        self:renderWin()
        qy.QYPlaySound.playMusic(qy.SoundType.BATTLE_W_BG_MS,false)
    elseif self.model.isWin == 2 then
        self:renderFail()
    end



    --新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.mask,["step"] = {"SG_19","SG_46","SG_77","SG_94","SG_117"}}
    })
end

function BattleResultView:onEnterFinish()
    BattleResultView.super.onEnterFinish(self)
end

function BattleResultView:onExit()
    --新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_19","SG_46","SG_77","SG_94","SG_117"})
    qy.QYPlaySound.stopMusic(true)
    self.timer = qy.tank.utils.Timer.new(0.5,1,function()
        qy.Event.dispatch(qy.Event.BATTLE_EXIT)
        qy.QYPlaySound.resumeMsAfterBattle()
    end)
    self.timer:start()
    self:__hideAward()
end

function BattleResultView:onCleanup()
    if self.expBar and tolua.cast(self.expBar,"cc.Node") then
        self.expBar:destroy()
    end

    if self.timer1 then
        self.timer1:stop()
    end

    if self.timer2 then
        self.timer2:stop()
    end
end

function BattleResultView:renderWin()
    -- self.failNode:setVisible(false)
    self.panel:removeChild(self.failNode)

    self.winNode:setVisible(true)

    self.title:initWithSpriteFrameName("Resources/battle/fight_0005.png")
    -- 是否显示遮罩
    qy.InternationalUtil:isShowView(self.titleBg, 1)
    self:showTitle(function()
        -- self.winBg:setOpacity(0)
        self.winBg:setVisible(true)
        -- local act = cc.FadeIn:create(0.5)
        -- self.winBg:runAction(act)
        self:__showExpBar()

        if self.model.fight_type == 2 then -- 经典战役结算
            if self.model.totalBattleData.ext.is_history and self.model.totalBattleData.ext.is_history == 1 then
                self:setCanceledOnTouchOutside(true)
                self:__hideAddition()
            else
                self:setCanceledOnTouchOutside(false)
                self:__showAddition()
            end
        else
            self:__hideAddition()
            local delay = qy.tank.utils.Timer.new(1,1,function()
                self.click_tip:setVisible(true)
                self:setCanceledOnTouchOutside(true)
            end)
            delay:start()
        end
        self:__showAward()
    end)
end

function BattleResultView:showTitle(callback)
    local x,y = self.title:getPosition()
    self.title:setPosition(x+400,y)
    self.title:setOpacity(0)

    local act1 = cc.FadeIn:create(0.5)
    local act2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(x,y)))
    local spawn1 = cc.Spawn:create(act1,act2)
    self.title:runAction(cc.Sequence:create(spawn1,cc.CallFunc:create(callback)))
end

-- 经验条
function BattleResultView:__showExpBar()
    local data = {}
    local start,ended,max,exp,level
    if self.model.upgrade_level == nil then
        self.model.upgrade_level = 0
    end

    if self.model.add_exp == nil then
        self.model.add_exp = 0
    end

    if self.model.add_coin == nil then
        self.model.add_coin = 0
    end

    if self.model.upgrade_level == nil or self.model.upgrade_level < 1 then
        ended = self.userInfo.userInfoEntity.exp
        start = ended - self.model.add_exp
        max = self.userInfo:toNextLevelNeedExp()
        table.insert(data,{start,ended,max})
    else
        exp = self.userInfo.userInfoEntity.exp
        level = self.userInfo.userInfoEntity.level
        start = 0
        ended = self.userInfo.userInfoEntity.exp
        max = self.userInfo:toNextLevelNeedExp()
        table.insert(data,{start,ended,max})

        -- for i=1,self.model.upgrade_level do
        --     level = self.userInfo.userInfoEntity.level - 1
        --     start = 0
        --     ended = self.userInfo:toNextLevelNeedExp(level)
        --     max = self.userInfo:toNextLevelNeedExp(level)
        --     exp = exp + max
        --     table.insert(data,1,{start,ended,max})
        -- end

        start = exp + self.userInfo:toNextLevelNeedExp(level-1) - self.model.add_exp
        ended = self.userInfo:toNextLevelNeedExp(level-1)
        max = self.userInfo:toNextLevelNeedExp(level-1)
        table.insert(data,1,{start,ended,max})
    end
    self.expBar = qy.tank.widget.progress.BattleExpBar.new()
    self.expBar:setPosition(qy.InternationalUtil:getBattleResultViewExpBarWidth(),250)
    self.winBg:addChild(self.expBar)
    if self.model.fight_type == 1 then
        self.expBar:setPercent(self.userInfo.userInfoEntity.level,data)
    else
        self.expBar:setPercentDirectly(self.userInfo.userInfoEntity.exp,max)
    end
end

function BattleResultView:__showAward()
    if self.model.awardList then
        self.awardList = qy.AwardList.new({
            ["award"] =  self.model.awardList,
            ["hasName"] = true,
            ["type"] = 2,
            ["cellSize"] = cc.size(150,100),
            ["itemSize"] = 1,
        })
        self.awardList:setPosition(qy.InternationalUtil:getBattleResultViewAwardListWidth(),210)
        self.winBg:addChild(self.awardList)
    end
end

function BattleResultView:__hideAward()
    if tolua.cast(self.awardList,"cc.Node") then
        if self.awardList:getParent() then
            self.awardList:getParent():removeChild(self.awardList)
        end
        self.awardList = nil
    end
end

function BattleResultView:__showAddition()
    self.remain3:setString(qy.TextUtil:substitute(51009, self.classicModel.three_experience))
    self.additionNode:setVisible(true)
end

function BattleResultView:__hideAddition()
    self.additionNode:setVisible(false)
end

function BattleResultView:renderFail()
    -- self.winNode:setVisible(false)
    self.panel:removeChild(self.winNode)
    self.tipTitle:setVisible(false)

    self.title:initWithSpriteFrameName("Resources/battle/fight_0014.png")
    -- 是否显示遮罩
    qy.InternationalUtil:isShowView(self.titleBg, 2)
    self:showTitle(function()
        self.tipTitle:setVisible(true)
    end)

    local function showTips(target,delay)
        local x,y = target:getPosition()
        target:setPosition(x,y-400)
        -- target:setOpacity(0)
        target:setVisible(true)
        -- local mov1 = cc.FadeIn:create(0.3)
        local mov2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(x,y)))
        -- local spawn2 = cc.Spawn:create(mov1,mov2)
        target:runAction(cc.Sequence:create(cc.DelayTime:create(delay),mov2))
    end

    showTips(self.item1,0.5)
    showTips(self.item2,0.7)
    showTips(self.item3,0.9)

    local delay = qy.tank.utils.Timer.new(1.5,1,function()
        self.click_tip:setVisible(true)
        self:setCanceledOnTouchOutside(true)
    end)
    delay:start()
end

return BattleResultView
