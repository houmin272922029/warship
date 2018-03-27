--[[
	最强之战-最强统帅
	Author: H.X.Sun
]]

local RankName = qy.class("RankName", qy.tank.view.BaseView, "greatest_race/ui/RankName")

function RankName:ctor(delegate)
    RankName.super.ctor(self)
    self.model = qy.tank.model.GreatestRaceModel
    local service = qy.tank.service.GreatestRaceService
    self:InjectView("rank")
    self:InjectView("name")


    self:OnClickForBuilding("btn",function()
        -- print("===== 历程 =====")
        service:getLog(self.data.kid,nil,function()
            if self.model:getLogNum() > 0 then
                qy.tank.view.greatest_race.UserCombatDialog.new():show(true)
            else
                qy.hint:show(qy.TextUtil:substitute(90211))
            end
        end)
    end)
end

function RankName:render(index)
    self.data = self.model:getRankByIndex(index)
    self.rank:setString(self.data.rank_title)
    self.name:setString(self.data.nickname)
    if self.data.is_my then
        self.rank:setTextColor(cc.c4b(255,0,0,255))
        self.name:setTextColor(cc.c4b(255,0,0,255))
    else
        self.rank:setTextColor(cc.c4b(254,241,201,255))
        self.name:setTextColor(cc.c4b(254,241,201,255))
    end
end

return RankName
