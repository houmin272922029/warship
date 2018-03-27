local CombatCastingRankCell = qy.class("CombatCastingRankCell", qy.tank.view.BaseView, "combat_casting.ui.CombatCastingRankCell")

function CombatCastingRankCell:ctor(delegate)
   	CombatCastingRankCell.super.ctor(self)

   	self:InjectView("bg")
    self:InjectView("Rank")
    self:InjectView("Name")
    self:InjectView("Score")
end

function CombatCastingRankCell:render(data, reward, _idx)

	if data then
		self.Rank:setString(data.rank)
		self.Name:setString("【"..data.server.."】 "..data.nickname)
		self.Score:setString(data.point)
	else 
		self.Rank:setString(_idx)
		self.Name:setString(qy.TextUtil:substitute(45008))
		self.Score:setString("0")
	end

end

return CombatCastingRankCell