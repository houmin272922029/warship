--[[
战斗场景Title效果
Author: lianyi
Date: 2015-02-11
]]

local BattleHeader = qy.class("BattleHeader", qy.tank.view.BaseView, "view/battle/BattleHeader")

function BattleHeader:ctor(delegate)
    BattleHeader.super.ctor(self)

    print("ClassName::BattleHeader")
    self.delegate = delegate
    self:InjectView("leftInfoBar")
    self:InjectView("rightInfoBar")
    self:InjectView("leftName")
    self:InjectView("rightName")
    self:InjectView("vs")
    self:InjectView("officer1_frame")
    self:InjectView("officer2_frame")
    self:InjectView("officer1")
    self:InjectView("officer2")
    self:InjectView("officer1_name")
    self:InjectView("officer2_name")
    self:InjectView("svipbg1")
    self:InjectView("svipbg2")
    self:InjectView("sviplevel1")
    self:InjectView("sviplevel2")
    self.vs_fx = nil

    self.model = qy.tank.model.BattleModel

    self.leftInfoBar:setVisible(false)
    self.rightInfoBar:setVisible(false)
    self.officer1_frame:setVisible(false)
    self.officer2_frame:setVisible(false)
    self.vs:setVisible(false)

    self.leftName:setString(self.model.leftPlayerName)
    self.rightName:setString(self.model.rightPlayerName)
end

function BattleHeader:play()
    -- VS fx
    self:playVsFx()
    -- qy.Timer.create("battle_vs",function()
    --     self:playVsFx()
    -- end,0.5,1)
end

function BattleHeader:destroy()
    if tolua.cast(self.vs_fx,"cc.Node") then
        if self.vs_fx:getAnimation().stop then
            self.vs_fx:getAnimation():stop()
        end
        if self.vs_fx:getParent() then
            self.vs_fx:getParent():removeChild(self.vs)
        end
        self.vs_fx = nil
    end
end

function BattleHeader:showInfoBar()
    print("+++++++++++++++++++++++mmmmmmmmm",self.model.totalBattleData.ext.att_passenger,self.model.totalBattleData.ext.def_passenger)
    -- left
    local p1_1 = cc.p(0,qy.winSize.height)
    -- local act1_1 = cc.EaseExponentialIn:create(cc.MoveTo:create(0.2,p1_1))
    -- local seq1 = cc.Sequence:create(ac1_1,act1_2)
    -- self.leftInfoBar:runAction(seq1)
    self.leftInfoBar:setPosition(p1_1)
    self.leftInfoBar:setVisible(true)

    if self.model.totalBattleData.ext.att_passenger_data then
        self.officer1:setTexture("passenger/"..self.model.totalBattleData.ext.att_passenger_data.id .."_1.png")
        self.officer1_frame:setPosition(290,qy.winSize.height-90)
        self.officer1_frame:setVisible(true)
        self.officer1_name:setString(self.model.totalBattleData.ext.att_passenger_data.name)
        self.officer1_name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(self.model.totalBattleData.ext.att_passenger_data.quality))
    else
        self.officer1_frame:setVisible(false)
    end
    if self.model.totalBattleData.ext.att_recharge_buff_level then
        if self.model.totalBattleData.ext.att_recharge_buff_level == 0 then
            self.svipbg1:setVisible(false)
        else
            self.svipbg1:setVisible(true)
            self.svipbg1:setPosition(210,qy.winSize.height-90)
            self.sviplevel1:setString("lv"..self.model.totalBattleData.ext.att_recharge_buff_level)
        end
    else
        self.svipbg1:setVisible(false)
    end

    -- right
    local p2_1 = cc.p(qy.winSize.width,qy.winSize.height)
    -- local act2_1 = cc.EaseExponentialIn:create(cc.MoveTo:create(0.2,p2_1))
    -- local act2_2 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.5,p2_2))
    -- local seq2 = cc.Sequence:create(ac2_1,act2_2)
    -- self.rightInfoBar:runAction(seq2)
    self.rightInfoBar:setPosition(p2_1)
    self.rightInfoBar:setVisible(true)

    if self.model.totalBattleData.ext.def_passenger_data then
        self.officer2_frame:setPosition(qy.winSize.width-290,qy.winSize.height-90)
        self.officer2_frame:setVisible(true)
        self.officer2:setTexture("passenger/"..self.model.totalBattleData.ext.def_passenger_data.id.."_1.png")
        self.officer2_name:setString(self.model.totalBattleData.ext.def_passenger_data.name)
        self.officer2_name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(self.model.totalBattleData.ext.def_passenger_data.quality))
    else
        self.officer2_frame:setVisible(false)
    end

    if self.model.totalBattleData.ext.def_recharge_buff_level then
        if self.model.totalBattleData.ext.def_recharge_buff_level == 0 then
            self.svipbg2:setVisible(false)
        else
            self.svipbg2:setVisible(true)
            self.svipbg2:setPosition(qy.winSize.width-210,qy.winSize.height-90)
            self.sviplevel2:setString("lv"..self.model.totalBattleData.ext.def_recharge_buff_level)
        end
    else
        self.svipbg2:setVisible(false)
    end

    if self.model.totalBattleData.ext.att_battle_ui then
        if self.model.totalBattleData.ext.att_battle_ui == 0 then
            self.leftInfoBar:setTexture("Resources/battle/blue_1.png")
        else
            self.leftInfoBar:setTexture("Resources/battle/blue_2.png")
        end
    end

    if self.model.totalBattleData.ext.def_battle_ui then
        if self.model.totalBattleData.ext.def_battle_ui == 0 then
            self.rightInfoBar:setTexture("Resources/battle/red_1.png")
        else
            self.rightInfoBar:setTexture("Resources/battle/red_2.png")
        end
    end
end

function BattleHeader:showVS()
    self.vs:setPosition(qy.winSize.width/2,qy.winSize.height/2+10)
    self.vs:setVisible(true)

    local p = cc.p(qy.winSize.width/2,qy.winSize.height-45)
    local move = cc.EaseExponentialIn:create(cc.MoveTo:create(0.2,p))
    local seq = cc.Sequence:create(move,cc.DelayTime:create(0.5),cc.CallFunc:create(function()
        -- self:showInfoBar()
        self.delegate.ended()
    end))
    self.vs:runAction(seq)
end

function BattleHeader:playVsFx()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/ui/ui_fx_duijue")
    self.vs_fx = ccs.Armature:create("ui_fx_duijue")
    -- self.vs_fx:setSpeedScale(1)
    -- self.vs_fx:setAnimationScale(1)
    self.vs_fx:setPosition(qy.winSize.width/2,qy.winSize.height/2)
    self:addChild(self.vs_fx)
    self.vs_fx:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            self:showVS()
            if self.vs_fx and tolua.cast(self.vs_fx,"cc.Node") then
                self:removeChild(self.vs_fx)
            end
        end
    end)
    self.vs_fx:getAnimation():playWithIndex(0)
    qy.QYPlaySound.playEffect(qy.SoundType.BATTEL_BEGAN)

    -- self:showVS()
    self:showInfoBar()
    -- self.delegate.ended()
end

return BattleHeader
