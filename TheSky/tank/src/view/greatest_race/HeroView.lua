--[[
	最强之战-英雄榜
	Author: H.X.Sun
]]

local HeroView = qy.class("HeroView", qy.tank.view.BaseView, "greatest_race/ui/HeroView")

local ONE_CELL_W = 750
local UserResUtil = qy.tank.utils.UserResUtil

function HeroView:ctor(delegate)
    HeroView.super.ctor(self)

    self.model = qy.tank.model.GreatestRaceModel
    local service = qy.tank.service.GreatestRaceService
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "greatest_race/res/greatest_race_title.png",
        ["onExit"] = function()
            delegate.dismiss()
        end
    })
    self:addChild(style, 13)
    self:InjectView("container")
    self:InjectView("title_mon")
    for i = 1, 4 do
        self:InjectView("img_"..i)
        self:InjectView("name_"..i)
        self:InjectView("head_"..i)
        self:InjectView("des_"..i)
    end

    self:OnClick("left_btn", function(sender)
        service:getHistory(self.mon,1,function()
            self:updateView()
        end)
    end)

    self:OnClick("right_btn", function(sender)
        service:getHistory(self.mon,2,function()
            self:updateView()
        end)
    end)

    self:OnClick("help_btn",function()
        qy.tank.view.common.HelpDialog.new(28):show(true)
    end)

    for i = 1, 4 do
        self:OnClick("btn_"..i, function()
            service:getLog(self.list[i].kid,self.mon,function()
                if self.model:getLogNum() > 0 then
                    qy.tank.view.greatest_race.UserCombatDialog.new():show(true)
                else
                    qy.hint:show(qy.TextUtil:substitute(90211))
                end
            end)
        end)
    end

    self:updateView()
end

function HeroView:updateView()
    self.mon = self.model:getHistoryMon()
    self.list = self.model:getHistoryData()
    self.title_mon:setString(self.mon ..qy.TextUtil:substitute(90212))
    local num = self.mon % 2 + 1
    for i = 1, 4 do
        self["head_"..i]:setTexture(UserResUtil.getRoleImgByHeadType(self.list[i].headicon))
        self["des_"..i]:setString(self.list[i].server_title)
        self["name_"..i]:setString(self.list[i].nickname)
        self["img_"..i]:setTexture("greatest_race/res/"..num.."_"..i..".jpg")
    end
end

return HeroView
