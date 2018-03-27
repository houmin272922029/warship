--[[
    伞兵入侵
]]
local InvadeDialog = qy.class("InvadeDialog", qy.tank.view.BaseView, "view/invade/InvadeDialog")

function InvadeDialog:ctor(delegate)
    InvadeDialog.super.ctor(self)
	self.model = qy.tank.model.InvadeModel
    self.userModel = qy.tank.model.UserInfoModel
    

    self:InjectView("enemy1")
    -- self:InjectView("enemy2")
    -- self:InjectView("enemy3")
    -- self:InjectView("enemy4")
    self:InjectView("tank")
    self:InjectView("eventTitle")
    -- self:InjectView("tank3")
    -- self:InjectView("tank4")
    self:InjectView("cdTitleTxt")
    self:InjectView("cdTxt")
    self:InjectView("noCdTxt")
    self:InjectView("enemyDiamondTxt")
    self:InjectView("enemyDiamond")
    self:InjectView("enemySilverTxt")
    self:InjectView("enemySilver")
    self:InjectView("doneTxt")
    self:InjectView("extraTxt")
    self:InjectView("fightBtn")
    self:InjectView("chestOnBtn")
    self:InjectView("award")
    self:InjectView("chestOpenBtn")
	self:InjectView("effertNode")

	qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/ui/campaign/ui_fx_cqyan")

    -- self.style = qy.tank.view.style.DialogStyle2.new({
    --     size = cc.size(742,500),
    --     position = cc.p(0,0),
    --     offset = cc.p(-4,4), 

    --     ["onClose"] = function()
    --         self:dismiss()
    --     end
    -- })
    -- self:addChild(self.style , -1)

    self.chestEffect = ccs.Armature:create("ui_fx_xiangziguang") 
    self.award:addChild(self.chestEffect,999)
    self.chestEffect:setAnchorPoint(0.5,0.5)
    self.chestEffect:setPosition(5,0)
    self.chestEffect:setVisible(false)

    self:updataAll()

    self:OnClick(self.chestOnBtn, function(sender)
        if self.isAward then
            local service = qy.tank.service.InvadeService
            local param = {}
            param.id = i
            service:getAward(param,function(data)
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    self.userData.is_receive = 1
                    self:updataAll()
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(17001))
        end
    end)

    self:OnClick(self.chestOpenBtn, function(sender)
        qy.hint:show(qy.TextUtil:substitute(17002))
    end)

    self:OnClick(self.fightBtn, function(sender)
        --播放动画过程中点击击退无效
        if self.isPlay ~=nil and self.isPlay == true then
            return
        end

    	local service = qy.tank.service.InvadeService
        local param = {}
        param.fight_id = self.fightId
        service:fight(param , function(data)
            if data.win ~=0 then
                self.canFightUpdate = true
                
            end
            qy.tank.model.BattleModel:init(data.fight_result)
            -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end)
    self.canFightUpdate = false
    self.isCreated = true
    -- self.isAward = false
end

function InvadeDialog:showAnimation(tank , container)
    self.isPlay = true
    local posX,posY = tank:getPosition()
    tank:setPosition(posX ,  400)
    local ease = cc.EaseSineInOut:create(cc.MoveTo:create(0.2,cc.p(posX , posY)))
    -- local seq = cc.Sequence:create(ease,cc.CallFunc:create(function()
    --      self:runAnimationSmoke(cc.p(-20, -30) , container)
    -- end))
    local func = cc.Spawn:create(ease, cc.CallFunc:create(function()
         self:runAnimationSmoke(cc.p(-20, -30) , container)
    end))
    tank:runAction(func)
end

function InvadeDialog:runAnimationSmoke(pos , container)
    local effect = ccs.Armature:create("ui_fx_cqyan") 
    container:addChild(effect,-1)
    effect:setScale(3)
    effect:setPosition(pos)
    effect:getAnimation():playWithIndex(0)
    qy.QYPlaySound.playEffect(qy.SoundType.INVADE)
    effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            effect:getParent():removeChild(effect)
            effect = nil
            self.isPlay = false
        end
    end)
end

-- 更新全部
function InvadeDialog:updataAll()
    self:clearTimer()
    self:initData()
    self:showCurrentEnemy()
    self:updateExtraAward()
end

--初始化数据
function InvadeDialog:initData(  )
    self.serverTime = self.userModel.serverTime
    self.userData = self.model:getCurrentFightData()
    self.fightId = self.userData.fight_id 
    self.leftTimes = self.userData.left_times
    self.winList = self.userData.win_list
    self.hasGot = self.userData.is_receive
    self.configData = self.model:getConfigDataById(self.fightId)
    print("self.fightId ==" .. self.fightId)
    print("self.configData ==" .. qy.json.encode(self.configData))
    if self.configData == nil then
        self.index = 0
    else
        self.index = self.configData.event_id
    end
end

--更新额外奖励
function InvadeDialog:updateExtraAward( )
    -- self.chestOffBtn:setVisible(false)
    -- self.chestOnBtn:setVisible(false)
    self.isAward = false
    self.chestOpenBtn:setVisible(false)
    if self.winList == nil or #self.winList<1 then
        self.extraTxt:setString(0)
        -- self.chestOffBtn:setVisible(true)
        self.isAward = false
    else
        local extraDiamond = 0
        if self.hasGot == 0 then
            for i=1,#self.winList do
                local tempFightId = self.winList[i]
                local tempFightConfig = self.model:getConfigDataById(tempFightId)
                extraDiamond  = extraDiamond + tempFightConfig.diamond
            end
            -- if self.leftTimes > 0 then 
            --     -- self.chestOffBtn:setVisible(true)
            --     self.isAward = false
            -- else
            --     self.isAward = true
            --     self.chestOnBtn:setVisible(true)
            -- end
            if #self.winList >= 3 then
                self.isAward = true
                self.chestEffect:setVisible(true)
                self.chestEffect:getAnimation():playWithIndex(0, 1, 1)
                self.chestOnBtn:setOpacity(0)
            else
                self.isAward = false
            end
        else
            self.chestOpenBtn:setVisible(true)
            self.chestEffect:setVisible(false)
        end
        
        self.extraTxt:setString(math.floor(extraDiamond/2))
    end
end

-- 更新当前敌人
function InvadeDialog:showCurrentEnemy()
    local diamond = self.configData == nil and 0 or self.configData.diamond
    local silver = self.configData == nil and 0 or self.configData.silver
    if diamond == 0 and  self.leftTimes < 1 then
        self.enemyDiamond:setVisible(false)
        self.enemyDiamondTxt:setVisible(false)
    else
        self.enemyDiamondTxt:setVisible(true)
        self.enemyDiamond:setVisible(true)
        self.enemyDiamondTxt:setString(" x " .. diamond)
    end

    if silver and self.leftTimes < 1 then
        self.enemySilver:setVisible(false)
        self.enemySilverTxt:setVisible(false)
    else
        self.enemySilverTxt:setVisible(true)
        self.enemySilver:setVisible(true)
        self.enemySilverTxt:setString(" x " .. silver)
    end

    if self.index > 0 then
        self.tank:setSpriteFrame("Resources/invade/tank" .. self.index .. ".png")
        self.eventTitle:setSpriteFrame("Resources/invade/name" .. self.index .. ".png")
        -- self.eventTitle:setTexture(self.model:getEventPicByEventId(self.index))
         self:showAnimation(self.tank , self.effertNode)
        self.tank:setVisible(true)
        self.eventTitle:setVisible(true)
    else
        self.tank:setVisible(false)
        self.eventTitle:setVisible(false)
    end

    -- self.enemy1:setVisible(false)
    -- self.enemy2:setVisible(false)
    -- self.enemy3:setVisible(false)
    -- self.enemy4:setVisible(false)
    -- self.enemyDiamondTxt:setString("x"..diamond)
    -- if self.index == 1 then 
    --     self:showAnimation(self.tank1 , self.effertNode)
    --     self.enemy1:setVisible(true)
    -- elseif self.index == 2 then
    --     self:showAnimation(self.tank2 , self.effertNode)
    --     self.enemy2:setVisible(true)
    -- elseif self.index == 3 then
    --     self:showAnimation(self.tank3 , self.effertNode)
    --     self.enemy3:setVisible(true)
    -- elseif self.index == 4 then
    --     self:showAnimation(self.tank4 , self.effertNode)
    --     self.enemy4:setVisible(true)
    -- else

    -- end
    self:createTimer1()
end

--创建定时器1
function InvadeDialog:createTimer1()
    self.remainTime1 = self.userData.cd_time - self.serverTime

    if self.remainTime1 <=0 then 
        self:clearTimer()
        self:updateLeftTime(0)
        return
    end
    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,self.remainTime1,function(leftTime)
            self:updateLeftTime(leftTime)
        end)
        self.timer1:start()
    end
    self:updateLeftTime(self.remainTime1)
end

--更新剩余时间
function InvadeDialog:updateLeftTime( leftTime)
    self.cdTxt:setVisible(false)
    self.cdTitleTxt:setVisible(false)
    self.noCdTxt:setVisible(false)
    self.doneTxt:setVisible(false)
    self.fightBtn:setVisible(false)

    if leftTime == 0 then        
        self:clearTimer()
        if self.index ~= 0 and self.leftTimes > 0 then
            self.noCdTxt:setVisible(true)    
            self.fightBtn:setVisible(true)
            self:setBtnEnable(self.fightBtn , true)
        else
            self.doneTxt:setVisible(true)    
        end
    else
        if self.index ~= 0 and self.leftTimes > 0 then
            self.cdTxt:setVisible(true)
            self.cdTitleTxt:setVisible(true)
            self.fightBtn:setVisible(true)
            self:setBtnEnable(self.fightBtn , false)
            local timeStr = qy.tank.utils.DateFormatUtil:toDateString(leftTime)
            self.cdTxt:setString(timeStr)
        else
            self.doneTxt:setVisible(true)   
        end
    end
end

-- 设置按钮可用状态
function InvadeDialog:setBtnEnable(btn , enabled)
    btn:setEnabled(enabled)
    btn:setBright(enabled)
end

-- 清除时钟
function InvadeDialog:clearTimer( )
    if self.timer1 ~=nil then
        self.timer1:stop()
    end   
    
    self.timer1 = nil
end

function InvadeDialog:onExit()
    self:clearTimer()
end

function InvadeDialog:onEnter( )
    if self.isCreated ~=nil and self.isCreated == true and self.canFightUpdate == true then
        self.canFightUpdate = false
        self:updataAll()
    end
end

return InvadeDialog