--[[
	最强之战-晋级名单
	Author: H.X.Sun
]]

local PromotionName = qy.class("PromotionName", qy.tank.view.BaseView, "greatest_race/ui/PromotionName")

function PromotionName:ctor(delegate)
    PromotionName.super.ctor(self)
    self.model = qy.tank.model.GreatestRaceModel

    self:InjectView("rank")
    self:InjectView("server")
    self:InjectView("name")
end

function PromotionName:render(index)
    local data = self.model:getRankByIndex(index)
    self.rank:setString(data.rank)
    self.server:setString(data.server_name)
    self.name:setString(data.nickname)
    if data.is_my then
        self.rank:setTextColor(cc.c4b(255,0,0,255))
        self.server:setTextColor(cc.c4b(255,0,0,255))
        self.name:setTextColor(cc.c4b(255,0,0,255))
    else
        self.rank:setTextColor(cc.c4b(254,241,201,255))
        self.server:setTextColor(cc.c4b(254,241,201,255))
        self.name:setTextColor(cc.c4b(254,241,201,255))
    end
end

return PromotionName
