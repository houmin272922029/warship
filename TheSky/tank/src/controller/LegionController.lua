--[[
	军团
	Author: H.X.Sun
]]

local LegionController = qy.class("LegionController", qy.tank.controller.BaseController)

local model = qy.tank.model.LegionModel
local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.LegionService
local NumberUtil = qy.tank.utils.NumberUtil
local ActivitiesCommand = qy.tank.command.ActivitiesCommand
local ModuleType = qy.tank.view.type.ModuleType

local LegionCommand = qy.tank.command.LegionCommand

function LegionController:ctor(delegate)
    LegionController.super.ctor(self)

	print("LegionController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    if model:getCommanderEntity():isJoin() then
        --已加入军团
        if NumberUtil.isOtherDay(cc.UserDefault:getInstance():getStringForKey(userModel.userInfoEntity.kid .."_legion_time")) then
            self:__createHallNotServer(true)
        else
            self:__MainView(false)
        end
        cc.UserDefault:getInstance():setStringForKey(userModel.userInfoEntity.kid .."_legion_time", userModel.serverTime)
    else
        --未加入军团
        self.joinView = qy.tank.view.legion.basic.JoinView.new({
        	["dismiss"] = function(isCreateHall)
                self.viewStack:pop()
                if isCreateHall then
                    self:__MainView()
                else
                    self:finish()
                end
            end,
        })
        self.viewStack:push(self.joinView)
    end
end

--[[--
    --主界面
--]]
function LegionController:__MainView(_isRepalce)
    self.mainView = qy.tank.view.legion.MainView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["forceLogic"] = function()
            --军团势力战
            qy.hint:show(qy.TextUtil:substitute(50001))
        end,
        ["bossLogic"] = function()
            --军团boss
            qy.tank.command.ActivitiesCommand:showActivity("legion_boss")
        end,
        ["siegeLogic"] = function()
            --围攻柏林
            -- qy.hint:show(qy.TextUtil:substitute(50001))
            local Model = qy.tank.model.AttackBerlinModel
            if Model.totalflag == 1 then
                 LegionCommand:viewRedirectByModuleType(ModuleType.ATTACK_BERLIN)
            else
                if Model:getpower() == 1 then
                    qy.tank.view.common.ChooseHard.new():show()
                else
                    qy.hint:show("副本暂未开启")
                end
            end 
        end,
        ["mobilizeLogic"] = function()
            --军团总动员
            -- qy.hint:show("功能暂未开启，敬请期待")
            LegionCommand:viewRedirectByModuleType(ModuleType.LE_MOB)
        end,
        ["escortLogic"] = function()
            --军团押运
            -- qy.hint:show("功能暂未开启，敬请期待")
            ActivitiesCommand:showActivity(ModuleType.CARRAY)
        end,
        ["clubLogic"] = function()
            --俱乐部
            -- self:__MenuView()
            LegionCommand:viewRedirectByModuleType(ModuleType.LE_CLUB)
        end,
        ["hallLogic"] = function()
            --军团大厅
            self:__createHallView()
        end,
        ["warLogic"] = function()
            LegionCommand:viewRedirectByModuleType(ModuleType.LE_WAR)
        end,
    })
    if _isRepalce then
        self.viewStack:replace(self.mainView)
    else
        self.viewStack:push(self.mainView)
    end
end

-- function LegionController:__MenuView()
--
-- end

function LegionController:__createHallNotServer(_isCreateMain)
    self.hallView = qy.tank.view.legion.basic.HallView.new({
        ["dismiss"] = function(isLeave)
            self.viewStack:pop()
            if _isCreateMain then
                self:__MainView(true)
            elseif isLeave then
                self.viewStack:removeFrom(self)
                self:finish()
            end
        end,
        ["chooseMail"] = function()
            qy.tank.view.legion.basic.ToMailDialog.new():show(true)
        end
    })
    self.viewStack:push(self.hallView)
end

function LegionController:__createHallView()
    service:getMemberList(function()
        self:__createHallNotServer(false)
    end)
end

return LegionController
