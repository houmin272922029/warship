--[[
	最强之战-战报
	Author: H.X.Sun
]]

local CombatCell = qy.class("CombatCell", qy.tank.view.BaseView, "greatest_race/ui/CombatCell")

function CombatCell:ctor(delegate)
    CombatCell.super.ctor(self)

    self:InjectView("round")
    self:InjectView("vs_info")
    local service = qy.tank.service.GreatestRaceService

    self:OnClickForBuilding("btn",function()
        -- print("=====【查看战报】=====",qy.json.encode(self.data))
        service:getCombat({["id"]=self.data.id},function()
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end)
end

function CombatCell:render(data)
    self.data = data
    self.round:setString(data.title)
    self.vs_info:setString(data.vs)
end

return CombatCell
