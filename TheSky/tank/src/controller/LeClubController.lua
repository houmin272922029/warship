--[[
	军团俱乐部
	Author: H.X.Sun
]]

local LeClubController = qy.class("LeClubController", qy.tank.controller.BaseController)

local model = qy.tank.model.LegionModel
local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.LegionService
local NumberUtil = qy.tank.utils.NumberUtil

function LeClubController:ctor(delegate)
    LeClubController.super.ctor(self)

    print("LeClubController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.menuView = qy.tank.view.legion.club.ClubMenu.new({
        ["dismiss"] = function(isCreateHall)
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["showClub"] = function(_name)
            if _name == "farm" then
                self:__FarmView()
            elseif _name == "party" then
                self:__PartyView()
            elseif _name == "dice" then
                self:__DiceView()
            elseif _name == "bank" then
                self:__BankView()
            elseif _name == "skill" then
                self:__SkillView()
            end
        end})
    self.viewStack:push(self.menuView)
end

function LeClubController:__FarmView()
    service:getFarmMain(function()
        self.farmView = qy.tank.view.legion.club.FarmView.new({
            ["dismiss"] = function()
                self.viewStack:pop()
            end,
        })
        self.viewStack:push(self.farmView)
    end)
end

function LeClubController:__DiceView()
    service:getDiceMain(function()
        self.diceView = qy.tank.view.legion.club.DiceView.new({
            ["dismiss"] = function()
                self.viewStack:pop()
            end,
        })
        self.viewStack:push(self.diceView)
    end)
end

function LeClubController:__BankView()
    service:getBankMain(function()
        self.bankView = qy.tank.view.legion.club.BankView.new({
            ["dismiss"] = function()
                self.viewStack:pop()
            end,
        })
        self.viewStack:push(self.bankView)
    end)
end

function LeClubController:__PartyView()
    service:getPartyMain(function()
        self.partyView = qy.tank.view.legion.club.PartyView.new({
            ["dismiss"] = function()
                self.viewStack:pop()
            end,
        })
        self.viewStack:push(self.partyView)
    end)
end

function LeClubController:__SkillView()
    qy.tank.command.ActivitiesCommand:showActivity("legion_skill")
end

return LeClubController
