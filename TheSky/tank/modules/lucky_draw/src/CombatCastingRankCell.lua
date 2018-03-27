local CombatCastingRankCell = qy.class("CombatCastingRankCell", qy.tank.view.BaseView, "lucky_draw.ui.CombatCastingRankCell")

local service = qy.tank.service.LuckyDrawService
local model = qy.tank.model.LuckyDrawModel

function CombatCastingRankCell:ctor(delegate)
   	CombatCastingRankCell.super.ctor(self)

   	self:InjectView("bg")
    self:InjectView("Rank")
    self:InjectView("Name")
    self:InjectView("Score")
end

function CombatCastingRankCell:render(data, _idx)

	self.Rank:setString(tonumber(data.rank))
	self.Name:setString("【"..data.server.."】 "..data.nickname)
	self.Score:setString(data.point)

end

return CombatCastingRankCell