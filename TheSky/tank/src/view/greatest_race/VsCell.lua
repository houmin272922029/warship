--[[
	最强之战-vs界面
	Author: H.X.Sun
]]

local VsCell = qy.class("VsCell", qy.tank.view.BaseView, "greatest_race/ui/VsCell")

local NumberUtil = qy.tank.utils.NumberUtil
local UserInfoModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.GreatestRaceService

function VsCell:ctor(delegate)
    VsCell.super.ctor(self)
    self.delegate = delegate
    self:InjectView("final_node")
    self:InjectView("bg")
    self:InjectView("vs_icon")
    self:InjectView("time")
    self:InjectView("title")
    self:InjectView("line_up")
    self:InjectView("round")
    self:InjectView("left_win")
    self:InjectView("right_win")
    self:InjectView("time_title")
    self:InjectView("get_score")
    self:InjectView("first_icon")
    self:InjectView("award_icon")
    self.first_icon:setLocalZOrder(10)
    self.model = qy.tank.model.GreatestRaceModel

    self.left = qy.tank.view.greatest_race.UserInfoCell.new({
        ["index"] = 0,
        ["callback"] = function()
            self:userOper()
        end
    })
    self:addChild(self.left)
    self.left:setPosition(-330,-82)

    self.right = qy.tank.view.greatest_race.UserInfoCell.new({
        ["index"] = 1,
        ["callback"] = function()
            self:userOper()
        end
    })
    self:addChild(self.right)
    self.right:setPosition(330,-82)

    if self.model:getCurrentStage() == self.model.STAGE_FINAL then
        -- 决赛
        self.final_node:setVisible(true)
        self.bg:setContentSize(cc.size(231, 380))
        self.vs_icon:setPosition(0,94)
        self.title:setPositionY(357)
        self.line_up:setPositionY(335)
        self:updateTitle()
    else
        -- 不是决赛
        self.final_node:setVisible(false)
        self.bg:setContentSize(cc.size(231, 204))
        self.vs_icon:setPosition(0,130)
        self.title:setPositionY(181)
        self.line_up:setPositionY(159)
        self.title:setString(qy.TextUtil:substitute(90231))
    end

    if self.model.ID_MATCH == self.model:getCurrentId() then
        self.get_score:setPositionX(-79)
        self.award_icon:setPositionX(-2)
    else
        self.get_score:setPositionX(-104)
        self.award_icon:setPositionX(20)
    end
    self.get_score:setString(self.model:getScoreTip())
    self.lastUpdateTime = UserInfoModel.serverTime
end

function VsCell:updateTitle()
    self.title:setString(self.model:getFinalTitle())
    self.round:setString(self.model:getRoundTitle())
    local data = self.model:getAttResults()
    self.left_win:setString(data.win_times)
    self.right_win:setString(data.fail_times)
end

function VsCell:userOper()
    self.lastUpdateTime = UserInfoModel.serverTime
    if self.model:getCurrentId() == self.model.ID_SUPPORT then
        self.left:waitForServer()
        self.right:waitForServer()
    end
end

function VsCell:update()
    if not self.model:isCalculateBattle() and (self.model:getCurrentAction() ~= self.model.ACTION_CALC) and (self.model:getCurrentAction() ~= self.model.ACTION_GROUP) then
        -- 10s 请求后端一次
        local dis = 10 - (UserInfoModel.serverTime - self.lastUpdateTime)
        if dis < 0 then
            self.lastUpdateTime = UserInfoModel.serverTime
            qy.Event.dispatch(qy.Event.GREATEST_RACE_UPDATE)
        end
    end

    local time = self.model:getEndTime()
    if time > 0 then
        self.time:setString(NumberUtil.secondsToTimeStr(time,2))
    elseif time == 0 then
        self.time:setString(qy.TextUtil:substitute(90232))
        if self.bServiceSend then
            return
        end

        self.bServiceSend = true
        if self.model:getCurrentAction() == self.model.ACTION_GROUP or self.model:getCurrentAction() == self.model.ACTION_WAIT then
            qy.Event.dispatch(qy.Event.GREATEST_RACE_UPDATE)
        else
            service:getCombat(self.model:getCombatParam(),function()
                qy.tank.manager.ScenesManager:pushBattleScene()
                self.model:clearSupportNum()
                qy.Event.dispatch(qy.Event.GREATEST_RACE_UPDATE)
                self.bServiceSend = false
            end)
        end
    elseif time < -self.model:getDelayTime() then
        -- 3s 延时
        print("time====",time)
        self.time:setString("00:00")
        if not self.model:getErrorStatus() then
            qy.tank.view.greatest_race.ErrorDialog.new():show(true)
        end
    else
        print("time1====",time)
    end
    if not self.model:canOperMatchBtn() then
        self.left:waitForServer()
        self.right:waitForServer()
    end

    self.left:updateSupport()
    self.right:updateSupport()

    if self.model:getCurrentAction() == self.model.ACTION_WAIT then
        self.time_title:setString(qy.TextUtil:substitute(90233))
        self.first_icon:setVisible(false)
    elseif self.model:getCurrentAction() == self.model.ACTION_GROUP then
        self.time_title:setString(qy.TextUtil:substitute(90234))
        self.first_icon:setVisible(false)
    else
        self.time_title:setString(qy.TextUtil:substitute(90235))
        self.first_icon:setVisible(true)
        if self.model:isLeftPriority() then
            self.first_icon:setPositionX(-178)
        else
            self.first_icon:setPositionX(485)
        end
    end
end

return VsCell
