-- 抗日远征入口

local FightJapanView = qy.class("FightJapanView", qy.tank.view.BaseView, "view/fightJapan/FightJapanView")

function FightJapanView:ctor(delegate)
    FightJapanView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/fightJapan_title.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style, 13)

    self.delegate = delegate
    self.model = qy.tank.model.FightJapanModel


    self:InjectView("timeTxt1")
    self:InjectView("mapScrollView")
    self:InjectView("leftTimeTxt")
    self:InjectView("fogPic") -- 迷雾
    self:InjectView("encourageBtn")
    self:InjectView("arrowTip")
    self:InjectView("helpBtn")
    self.helpBtn:setLocalZOrder(14)

    for i = 1, 16 do
        self:InjectView("enemy_" .. i)
    end

    self.mapScrollView:setContentSize(qy.winSize.width , qy.winSize.height)

    self:OnClick("exitBtn", function(sender)
        qy.QYPlaySound.stopMusic(true)
        self.delegate:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    -- function openExchangeDialog( )
    --
    -- end

    local _ModuleType = qy.tank.view.type.ModuleType.F_J_EX_SHOP

    --远征商店
    self:OnClick("exchangeBtn", function(sender)
    --    openExchangeDialog()
        qy.tank.command.MainCommand:viewRedirectByModuleType(_ModuleType)
    end)

    --帮助
    self:OnClick("helpBtn", function(sender)
       qy.tank.view.common.HelpDialog.new(3):show(true)
    end)

    --鼓舞
    self:OnClick("encourageBtn", function(sender)
        local service = qy.tank.service.FightJapanService
         service:getEncourage(param,function(data)
            qy.GuideManager:nextTiggerGuide()
            qy.tank.view.fightJapan.EncourageDialog.new(
            {
                ["data"] = data
            }):show(true)
        end)
    end)

    --重置
     self:OnClick("againBtn", function(sender)
        if self.model.remainTimes < 1 then
            qy.hint:show(qy.TextUtil:substitute(70053))
            return
        end
        function callBack(flag)
            if flag == qy.TextUtil:substitute(70054) then
                local service = qy.tank.service.FightJapanService
                 service:restart(param,function(data)
                    self:updateAll()
                    self:updateExMaps()
                    self:moveListToRight()
                end)
            end
        end
        local alertMesg = qy.TextUtil:substitute(70055)
        qy.alert:show({qy.TextUtil:substitute(70056) ,{255,255,255} }  ,  alertMesg , cc.size(450 , 220),{{qy.TextUtil:substitute(70057) , 4}   , {qy.TextUtil:substitute(70054) , 5}} ,callBack,"")
    end)

    self:initExMaps()

    self.mapIsInit = false

    --自动开启远征商店（其他模块需求）
    if self.model.autoOpen ~=nil and self.model.autoOpen~="" then
        if self.model.autoOpen == "exchange" then
            -- openExchangeDialog()
            qy.tank.model.FightJapanModel.autoOpen = ""
        end
    end
end

function FightJapanView:initExMaps()
    local list = self.model:getExpeEnemyList()
    self.exEnemyCell = {}

    for i = 1, #list do
        local ui = nil
        if list[i].cType == 0 then
            ui = qy.tank.view.fightJapan.ExEnemyCell.new()
            -- print("FightJapanView:updateExMaps() =ExEnemyCell===" .. i)
        else
            -- print("FightJapanView:updateExMaps() =ExChestCell===" .. i)
            ui = qy.tank.view.fightJapan.ExChestCell.new({["updateExMaps"] = function ()
                self:updateExMaps()
            end})
        end
        self["enemy_" .. i]:addChild(ui)
        table.insert(self.exEnemyCell, ui)
    end
end

function FightJapanView:updateExMaps()
    for i = 1, #self.exEnemyCell do
        self.exEnemyCell[i]:refresh(i)
    end
    self:updateArrowPosition()
    self:updateFogPos()
end

function FightJapanView:updateFogPos()
    local index = self.model:getCurrentIndex()
    if index == -1 then
        index = 16
    end
    local _x = self["enemy_"..index]:getPositionX() + 100
    self.fogPic:setPosition(_x, 360)
end

function FightJapanView:updateArrowPosition()
    local index = self.model:getCurrentIndex()
    self.arrowTip:stopAllActions()
    if index == -1 then
        self.arrowTip:setVisible(false)
    else
        self.arrowTip:setVisible(true)
        local _x = self["enemy_"..index]:getPositionX()
        local _y = self["enemy_"..index]:getPositionY() + 80
        self.arrowTip:setPosition(_x, _y)

        local moveUp = cc.MoveBy:create(0.2, cc.p(0,10))
        local moveDown = cc.MoveBy:create(0.2, cc.p(0,-10))
        local seq = cc.Sequence:create(callFunc, moveUp, moveDown)
        self.arrowTip:runAction(cc.RepeatForever:create(seq))

        if index == self.model:getExpeEnemyNum() then
            local timer = qy.tank.utils.Timer.new(0.05,1,function()
                qy.hint:show(qy.TextUtil:substitute(70058))
            end)
            timer:start()
        elseif index == (self.model:getExpeEnemyNum() - 1) then
            self.delegate.showSpeak()
        end
    end
end

function FightJapanView:moveListToRight()
    local index = self.model:getCurrentIndex()
    if index > 11 then
        self.mapScrollView:scrollToPercentHorizontal(100, 0.5, false)
    elseif index ==1 then
        self.mapScrollView:jumpToLeft()
    else
        local per = (index - 1) * 10
        self.mapScrollView:scrollToPercentHorizontal(per, 0.5, false)
    end
end

--更新所有
function FightJapanView:updateAll()
    self.leftTimeTxt:setString(qy.TextUtil:substitute(70059, self.model.remainTimes))
    self.mapIsInit = true
end

function FightJapanView:onExit( )
    qy.tank.model.UserInfoModel.isInFightJapan = false
    qy.QYPlaySound.playMusic(qy.SoundType.M_W_BG_MS)
    --触发式引导
    qy.GuideCommand:removeTriggerUiRegister({"T_EX_6"})
end

function FightJapanView:onEnter()
    qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
    self:updateAll()
    self:updateExMaps()
    self:moveListToRight()
    qy.tank.model.UserInfoModel.isInFightJapan = true
    -- self:refresh()
    --触发式引导
    qy.GuideCommand:addTriggerUiRegister({
        {["ui"] = self.encourageBtn, ["step"] = {"T_EX_6"}},
    })
end

return FightJapanView
