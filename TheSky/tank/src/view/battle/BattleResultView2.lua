--[[
    最强之战战斗结算面板
    H.X.Sun
]]--
local BattleResultView = qy.class("BattleResultView", qy.tank.view.BaseDialog,"view/battle/BattleResultView2")

function BattleResultView:ctor(delegate)
    BattleResultView.super.ctor(self)
    self.model = qy.tank.model.BattleModel
    self.greatestRaceModel = qy.tank.model.GreatestRaceModel

    self:setCanceledOnTouchOutside(false)
    self:InjectView("figure")
    self:InjectView("award_node")
    self:InjectView("text_1")
    self:InjectView("text_2")
    self:InjectView("winBg")

    self:OnClick(self.mask, function()
        if self.isCanceledOnTouchOutside then
            self:dismiss()
            delegate.confirm()
        end
    end,{["isScale"] = false, ["hasAudio"] = false})
end

function BattleResultView:renderWin()
    self.winBg:setVisible(true)
    print("self.model.awardList===",qy.json.encode(self.model.awardList))
    if self.model.awardList and #self.model.awardList >0 then
        local awardList = qy.AwardList.new({
            ["award"] = self.model.awardList,
            ["hasName"] = true,
            ["cellSize"] = cc.size(140,180),
        })

        self.award_node:addChild(awardList)
        awardList:setPosition(-137,100)
    else
        self.award_node:setVisible(false)
    end
    local data = self.greatestRaceModel:getBResultDes()
    self.text_1:setString("恭喜"..data.win_name.."获得本场战斗胜利")
    self.text_2:setString(data.up_des)
    if not data.show_up then
        self.text_1:setPositionY(50)
    end
end

function BattleResultView:onEnter()
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

    self.figure:runAction(spawn1)
    -- self:renderWin()
    local timer1 = qy.tank.utils.Timer.new(0.2,1,function()
        qy.QYPlaySound.playMusic(qy.SoundType.BATTLE_W_BG_MS,false)
        self:renderWin()
        self:setCanceledOnTouchOutside(true)
    end)
    timer1:start()
end

function BattleResultView:onExit()
    qy.QYPlaySound.stopMusic(true)
    self.timer = qy.tank.utils.Timer.new(0.5,1,function()
        qy.Event.dispatch(qy.Event.BATTLE_EXIT)
        qy.QYPlaySound.resumeMsAfterBattle()
    end)
    self.timer:start()
end

return BattleResultView
