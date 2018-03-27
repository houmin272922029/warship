

local MillitaryCell = qy.class("MillitaryCell", qy.tank.view.BaseView, "service_faction_war/ui/MillitaryCell")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function MillitaryCell:ctor(delegate)
    MillitaryCell.super.ctor(self)
    self.delegate = delegate
    self:InjectView("rank")
    self:InjectView("score")
    self:InjectView("name")
end

function MillitaryCell:render(idx)
	local data = model.camp_war_level[idx]
	self.rank:setString(data.name)
	self.score:setString(data.need_contribution)
	self.name:setString(data.max_people == 0 and "无限制" or data.max_people)

end


return MillitaryCell
