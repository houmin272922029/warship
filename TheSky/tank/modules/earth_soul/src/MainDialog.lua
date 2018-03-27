local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "earth_soul.ui.MainDialog")

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("Free1")
    self:InjectView("Free2")
    self:InjectView("Num")
    self:InjectView("Time")

   	self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_rank", function()
        local dialog = require("earth_soul.src.RankDialog").new()
        dialog:show()
    end,{["isScale"] = false})

    self:OnClick("Btn_achievement", function()
        local dialog = require("earth_soul.src.AchievementDialog").new()
        dialog:show()
    end,{["isScale"] = false})

    self:OnClick("Button_1", function()
        service:getCommonGiftAward({
                ["type"] = 1,
                ["id"] = 1,
                ["activity_name"] = activity.EARTH_SOUL
            }, activity.EARTH_SOUL,false, function(reData)
                self:update()
        end, true)
    end,{["isScale"] = false})

    self:OnClick("Button_2", function()
        service:getCommonGiftAward({
                ["type"] = 1,
                ["id"] = 100,
                ["activity_name"] = activity.EARTH_SOUL
            }, activity.EARTH_SOUL,false, function(reData)
                self:update()
        end, true)
    end,{["isScale"] = false})

    -- self.BG:addChild(self:createView())

    -- -- self:setAward()
    self:update()
end

function MainDialog:update()
    self:setTime()
    self:setTimes()
end

function MainDialog:setTime()
    self.Num:setString(model.earthSoulTotalTimes)
end

function MainDialog:setTimes()
    self.Free1:setVisible(model.earthSoulLeftTimes <= 0)
    self.Free2:setVisible(model.earthSoulLeftTimes > 0)
    self.Free2:setString(qy.TextUtil:substitute(45006) .. model.earthSoulLeftTimes .. qy.TextUtil:substitute(45005))
end

function MainDialog:onEnter()
    self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.earthSoulEndTime - qy.tank.model.UserInfoModel.serverTime, 3))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        -- self.Time1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.bonusBeginTime, 3))
        self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.earthSoulEndTime - qy.tank.model.UserInfoModel.serverTime, 3))
    end)
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
end

return MainDialog
