local BattleResultView = qy.class("BattleResultView", qy.tank.view.BaseDialog,"view/battle/BattleResultView1")

-- BattleResultView.__create = function(theme)
--     return BattleResultView.super.__create(, "view/battle/" .. theme)
-- end

function BattleResultView:ctor(delegate)
    BattleResultView.super.ctor(self)
    self:setCanceledOnTouchOutside(false)
    self.isPopup = false

    -- 通用
    self:InjectView("panel")
    self:InjectView("figure")
    self:InjectView("title")
    self:InjectView("shareBtn")
    self:InjectView("replayBtn")
    self:InjectView("click_tip")
    self.click_tip:setVisible(false)

    -- 胜利
    self:InjectView("winNode")
    self:InjectView("winBg")
    self:InjectView("tip_0")

    -- 失败
    self.tips = qy.Config.battle_result_link
    self:InjectView("failNode")
    self:InjectView("tipTitle")
    for i=1,3 do
        self:InjectView("item"..i)
        self:InjectView("label"..i)
        self["item"..i]:setVisible(false)
        self["item"..i]:setSwallowTouches(true)
        self:OnClick("item"..i, function()
            local data,idx = self.tips,self.tipIdx
            self:dismiss()
            delegate.confirm()
            local delay = qy.tank.utils.Timer.new(0.2,1,function()
                qy.tank.utils.ModuleUtil.viewRedirectByViewId(data[idx]["link"..i],function()
                end)
            end)
            delay:start()
        end, {["isScale"] = true})
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

    --跨服军演
    self:InjectView("diamondnum")--钻石
    self:InjectView("diamondicon")--钻石图标
    self:InjectView("jifennum")--积分
    self.diamondnum:setVisible(false)
    self.jifennum:setVisible(false)
    self.diamondicon:setVisible(false)

    self:OnClick("shareBtn", function()
        -- delegate.share()
        if qy.tank.utils.SDK:channel() == "google" then
            qy.tank.utils.SDK:shareToFacebook({},function(result)
                    if result == 1 then
                        qy.hint:show("share to facebook callback success!")
                    elseif result == 2 then
                        qy.hint:show("share to facebook callback cancel!")
                    elseif resume() == 3 then
                        qy.hint:show("share to facebook callback error!")
                    end
                end)
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
    print("战斗类型",self.model.fight_type)
    self.figure:runAction(cc.Sequence:create(spawn1,cc.CallFunc:create(function()
        if not qy.isNoviceGuide then
            if self.model.totalBattleData.ext.is_history and self.model.totalBattleData.ext.is_history == 1 then
                self.shareBtn:setVisible(false)
            elseif self.model.battleData.fight_type == 17 or self.model.fight_type == 18 or self.model.fight_type == 21 or self.model.fight_type == 22 or self.model.fight_type == 32 then
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

    self.title:initWithSpriteFrameName("Resources/battle/win_title.png")
    self.title:setPosition(640,515)
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
        --跨服军演
        if self.model.fight_type == 21 then
            self.tip_0:setVisible(false)
            if self.model.dimond ~= -1 then
                self.diamondnum:setVisible(true)
                self.jifennum:setVisible(true)
                self.diamondicon:setVisible(true)
                self.diamondnum:setString("+"..self.model.dimond)
                self.jifennum:setString("积分 +"..self.model.integral)
            end
         
        end
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
    self.expBar:setPosition(120,290)
    self.winBg:addChild(self.expBar)
    self.expBar:setPercent(self.userInfo.userInfoEntity.level,data)
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
        self.awardList:setPosition(210,270)
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
    self.remain3:setString("今日剩余次数："..tostring(self.classicModel.three_experience))
    self.additionNode:setVisible(true)
end

function BattleResultView:__hideAddition()
    self.additionNode:setVisible(false)
end

function BattleResultView:renderFail()
    -- self.winNode:setVisible(false)
    self.panel:removeChild(self.winNode)
    self.tipTitle:setVisible(false)

    self.title:initWithSpriteFrameName("Resources/battle/failure_title.png")
    self.title:setPosition(644,540)
    self:showTitle(function()
        if self.model.fight_type ~= 21  then
            self.tipTitle:setVisible(true)
        else
            if self.model.dimond ~= -1 then
                self.tipTitle:setVisible(false)
            else
                self.tipTitle:setVisible(true)
            end
        end
    end)

    local function showTips(target,delay)
        local x,y = target:getPosition()
        -- target:setPosition(x,y-400)
        -- target:setOpacity(0)
        target:setVisible(true)
        -- local mov1 = cc.FadeIn:create(0.3)
        -- local mov2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(x,y)))
        -- local spawn2 = cc.Spawn:create(mov1,mov2)
        target:setScale(0)
        -- local mov1 = cc.EaseElasticInOut:create(cc.ScaleTo:create(2,1))
        local mov1 = cc.ScaleTo:create(0.2,1.4)
        local mov2 = cc.ScaleTo:create(0.05,0.9)
        local mov3 = cc.ScaleTo:create(0.05,1)
        target:runAction(cc.Sequence:create(cc.DelayTime:create(delay),mov1,mov2,mov3))
    end

    for i=1,5 do
        local level = self.userInfo.userInfoEntity.level
        if level >= self.tips[tostring(i)].min and level <= self.tips[tostring(i)].max then
            self.tipIdx = i
            break   
        end 
    end

    local level = self.userInfo.userInfoEntity.level
    for k, v in pairs(self.tips) do
        if level >= v.min and level <= v.max then
            self.tipIdx = k
            break   
        end 
    end
    if self.model.fight_type ~= 21 then
        for i=1,3 do
            showTips(self["item"..i],0.3+(i-1)*0.2)
            self["label"..i]:setString(self.tips[self.tipIdx]["name"..i])
        end
    else
        if self.model.dimond ~= -1 then
        else
            for i=1,3 do
                showTips(self["item"..i],0.3+(i-1)*0.2)
                self["label"..i]:setString(self.tips[self.tipIdx]["name"..i])
            end
        end
    end

    local delay = qy.tank.utils.Timer.new(1.5,1,function()
        if tolua.cast(self.click_tip,"cc.Node") then
            self.click_tip:setVisible(true)
            self:setCanceledOnTouchOutside(true)
        end
        if self.model.fight_type == 21 then 
            if self.model.dimond ~= -1 then
                self.tipTitle:setVisible(false)
                self.diamondnum:setVisible(true)
                self.jifennum:setVisible(true)
                self.diamondicon:setVisible(true)
                for i=1,3 do
                    self["item"..i]:setVisible(false)
                end
                self.diamondnum:setString("-"..self.model.dimond)
                self.jifennum:setString("积分 -"..self.model.integral)
            end
        end
    end)
    delay:start()

end

return BattleResultView
