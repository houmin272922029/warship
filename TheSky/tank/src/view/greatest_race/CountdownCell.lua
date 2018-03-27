--[[
	最强之战-分组倒计时 or 停赛
	Author: H.X.Sun
]]

local CountdownCell = qy.class("CountdownCell", qy.tank.view.BaseView, "greatest_race/ui/CountdownCell")

local NumberUtil = qy.tank.utils.NumberUtil

function CountdownCell:ctor(delegate)
    CountdownCell.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("suspend_node")
    self:InjectView("time_node")
    self:InjectView("time")
    self.model = qy.tank.model.GreatestRaceModel

    local _status = self.model:getCurrentStatus()
    if _status == self.model.STATUS_SUSPEND then
        -- 停赛
        self.suspend_node:setVisible(true)
        self.time_node:setVisible(false)
        self.bg:setScaleX(2)
        local year = os.date("%Y", qy.tank.model.UserInfoModel.serverTime)
        local mon = os.date("%m", qy.tank.model.UserInfoModel.serverTime)
        print("year=",year)
        print("mon = ",mon)
        if tostring(year) == "2016" and tostring(mon) == "09" then
            self.suspend_node:setString(qy.TextUtil:substitute(90207))
        else
            self.suspend_node:setString(qy.TextUtil:substitute(90208))
        end
    else
        -- 分组倒计时
        self.suspend_node:setVisible(false)
        self.time_node:setVisible(true)
        self.bg:setScaleX(1)
    end
end

function CountdownCell:updateTime()
    local time = self.model:getEndTime()
    if time > 0 then
        self.time:setString(NumberUtil.secondsToTimeStr(time,2))
    elseif time == 0 then
        self.time:setString(qy.TextUtil:substitute(90209))
        qy.Event.dispatch(qy.Event.GREATEST_RACE_UPDATE)
    elseif time < -self.model:getDelayTime() then
        -- 3s 延时
        self.time:setString("00:00:00")
        if not self.model:getErrorStatus() then
            qy.tank.view.greatest_race.ErrorDialog.new():show(true)
        end
    end
end

return CountdownCell
