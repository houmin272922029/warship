--[[
	最强之战-查看用户战报
	Author: H.X.Sun
]]

local UserCombatCell = qy.class("UserCombatCell", qy.tank.view.BaseView, "greatest_race/ui/UserCombatCell")

function UserCombatCell:ctor(delegate)
    UserCombatCell.super.ctor(self)

    self:InjectView("des")

    self.model = qy.tank.model.GreatestRaceModel
    local service = qy.tank.service.GreatestRaceService

    self:OnClickForBuilding("btn",function()
        -- print("self.data====",qy.json.encode(self.data))
        service:getCombat({["id"]=self.data.id},function()
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end)
end

function UserCombatCell:render(index)
    self.data = self.model:getLogListByIndex(index)
    self.des:setString(self.data.title)
end

return UserCombatCell
