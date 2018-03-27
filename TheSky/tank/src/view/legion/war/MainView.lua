--[[
	军团战
	Author: H.X.Sun
]]

local MainView = qy.class("MainView", qy.tank.view.BaseView, "legion_war/ui/MainView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.LegionWarService

function MainView:ctor(delegate)
    MainView.super.ctor(self)
    local head = qy.tank.view.legion.war.HeadCell.new({
        ["onExit"] = delegate.dismiss,
    })
    self:addChild(head,10)
    self.delegate = delegate
    self.model = qy.tank.model.LegionWarModel
    self.StorageModel = qy.tank.model.StorageModel

    self:InjectView("home_node")
    self:InjectView("results_node")
    self:InjectView("exchange_node")
    self:InjectView("reward_node")
    self:InjectView("rest_node")
    self:InjectView("time_num")
    self:InjectView("main_bg")
    for i = 1, 3 do
        self:InjectView("props_"..i)
    end

    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{qy.TextUtil:substitute(53012), qy.TextUtil:substitute(53013),qy.TextUtil:substitute(53014),qy.TextUtil:substitute(53015),qy.TextUtil:substitute(53016)},cc.size(190,67),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self:addChild(self.tab)
    self.tab:setPosition(qy.winSize.width/2-475,qy.winSize.height-140)
    self.tab:setLocalZOrder(4)

    self:OnClick("main_bg",function()
        if self.tab_idx ~= 1 then
            print("self.tab_idx ~= 1")
            return
        end

        local _action = self.infoEntity:getGameAction()
        if _action == self.model.ACTION_SIGN or _action == self.model.ACTION_WATCH then
            --报名界面/观战界面 点击刷新
            local lastUpdateTime = cc.UserDefault:getInstance():getStringForKey("legion_fight_main_time",0)
            if userModel.serverTime - lastUpdateTime >= 60 then
                cc.UserDefault:getInstance():setStringForKey("legion_fight_main_time",userModel.serverTime)
                service:get(true,function()
                    self:createContent(1)
                end)
            end
        end
    end,{["isScale"] = false})
end

function MainView:createContent(_idx)
    if _idx ~= 4 then
        self.model:setLastTab(_idx)
    end

    self.infoEntity = self.model:getLegionWarInfoEntity()
    self.rest_node:setString("")
    self.home_node:removeAllChildren()
    if tolua.cast(self.exchangeList,"cc.Node") then
        self.exchange_node:removeChild(self.exchangeList)
        self.exchangeList = nil
    end

    self.tab_idx = _idx
    if _idx == 1 then
        --首页
        self.results_node:setVisible(false)
        self.exchange_node:setVisible(false)
        self.home_node:setVisible(true)
        self.reward_node:setVisible(false)
        if self.infoEntity:getGameStage() == self.model.STAGE_REST then
            self.rest_node:setString(qy.TextUtil:substitute(53017))
        elseif self.infoEntity:getGameAction() == self.model.ACTION_WATCH then
            --观看比赛
            self:finalRecord(self.home_node)
        elseif self.infoEntity:getGameAction() == self.model.ACTION_END then
            --最终结果
            local leList = qy.tank.view.legion.war.LeRankList.new({["view"] = _idx})
            self.home_node:addChild(leList)
            leList:setPosition(-488,-207)
            local usList = qy.tank.view.legion.war.UsRankList.new({["view"] = _idx})
            self.home_node:addChild(usList)
            usList:setPosition(-150,-207)
        else
            self:firstRecord(self.home_node)
        end

    elseif _idx == 2 then
        --昨日战况
        self.results_node:setVisible(true)
        self.home_node:setVisible(false)
        self.exchange_node:setVisible(false)
        self.reward_node:setVisible(false)

        -- if self.model:getCombatNum() == 0 then
        if not self.model.isHasCombat then
            self.results_node:removeAllChildren()
            service:getCombatList(function()
                self:showCombatView()
            end)
        else
            self:showCombatView()
        end

    elseif _idx == 3 then
        --兑换
        self.results_node:setVisible(false)
        self.home_node:setVisible(false)
        self.exchange_node:setVisible(true)
        self.reward_node:setVisible(false)
        self:updateProps()
        service:getShopList(true,function()
            self.exchangeList = qy.tank.view.legion.war.ExchangeList.new({
                ["exchangeCallFunc"]=function(_str)
                    self:updateShopTime(_str)
                end,
                ["updateProps"] = function()
                    self:updateProps()
                end,
            })
            self.exchange_node:addChild(self.exchangeList)
            self.exchangeList:setPosition(-482,-210)
        end)
    elseif _idx == 4 then
        --排行
        service:getRankList(function()
            self.delegate.showRank({["callFunc"]=function()
                self.tab:switchTo(self.model:getLastTab())
            end})
        end)
    elseif _idx == 5 then
        --奖励
        self.results_node:setVisible(false)
        self.home_node:setVisible(false)
        self.exchange_node:setVisible(false)
        self.reward_node:setVisible(true)
        if not tolua.cast(self.rewardList,"cc.Node") then
            self.rewardList = qy.tank.view.legion.war.RewardList.new()
            self.reward_node:addChild(self.rewardList)
            self.rewardList:setPosition(-492,-260)
        end
    end
end

function MainView:showCombatView()
    if not tolua.cast(self.resultsList2,"cc.Node") then
        self.resultsList2 = qy.tank.view.legion.war.ResultList.new({
            ["callback"] = function(_str)
                self.rest_node:setString(_str)
            end
        })
        self.results_node:addChild(self.resultsList2)
        self.resultsList2:setPosition(-482,-257)
    else
        self.resultsList2:update(false)
    end
end

function MainView:firstRecord(_isShowAnim)
    if self.infoEntity:getGameAction() == self.model.ACTION_SIGN or self.infoEntity:getGameAction() == self.model.ACTION_PLAY then
        --报名,轮数赛果
        if not tolua.cast(self.signList,"cc.Node") then
            self.signList = qy.tank.view.legion.war.SignUpList.new()
            self.home_node:addChild(self.signList)
            self.signList:setPosition(-486,-257)
        else
            self.signList:update()
        end
    end

    if self.infoEntity:getGameAction() == self.model.ACTION_SIGN then
        --初赛报名右侧
        if not tolua.cast(self.signCell,"cc.Node") then
            self.signCell = qy.tank.view.legion.war.SignUpCell.new({["callback"]=function()
                self.signList:update()
            end})
            self.home_node:addChild(self.signCell)
            self.signCell:setPosition(-150,-257)
        else
            self.signCell:update()
        end
    elseif self.infoEntity:getGameAction() == self.model.ACTION_PLAY then
        if not tolua.cast(self.resultsList1,"cc.Node") then
            self.resultsList1 = qy.tank.view.legion.war.ResultList.new({["callback"]=function()
                self:createContent(1)
            end})
            self.home_node:addChild(self.resultsList1)
            self.resultsList1:setPosition(-150,-257)
        else
            self.resultsList1:update(_isShowAnim)
        end
    end
end

function MainView:finalRecord(f_ui)
    local watchCell = qy.tank.view.legion.war.WatchCell.new()
    f_ui:addChild(watchCell)
    watchCell:setPosition(-482,-257)
end

function MainView:updateProps()
    for i = 1, 3 do
        -- id == 28,29,30
        local num =  self.StorageModel:getPropNumByID(27+i)
        self["props_"..i]:setString("x "..num)
    end
end

function MainView:updateTime()
    if self.infoEntity:getGameStage() ~= self.model.STAGE_FINAL then
        if self.model:getJoinNum() > 0 and self.infoEntity:getGameAction() == self.model.ACTION_PLAY then
            local time = self.model:getOpenTime() - userModel.serverTime
            if time < 0 then
                service:get(false,function()
                    if self.tab_idx == 1 then
                        if self.infoEntity:getGameAction() == self.model.ACTION_END then
                            self:createContent(1)
                        else
                            self:firstRecord(true)
                        end
                    end
                end)
            end
        end
    end
end

function MainView:updateShopTime(_str)
    self.time_num:setString(_str)
end

function MainView:onEnter()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function MainView:onExit()
    qy.Event.remove(self.timeListener)
	self.timeListener = nil
end

return MainView
