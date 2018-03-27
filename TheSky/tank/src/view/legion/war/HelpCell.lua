--[[
	军团战-帮助cell
	Author: H.X.Sun
]]

local HelpCell = qy.class("HelpCell", qy.tank.view.BaseView, "legion_war/ui/HelpCell")

function HelpCell:ctor(params)
    HelpCell.super.ctor(self)
    self:InjectView("title")
    local model = qy.tank.model.LegionWarModel
    local index = params.stage or 0
    local color = model:getColorByRank(4-index)
    self.title:setString(params.title)
    self.title:setTextColor(color)
end

return HelpCell
