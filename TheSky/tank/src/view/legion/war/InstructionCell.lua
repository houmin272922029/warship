--[[
	军团战-帮助cell
	Author: H.X.Sun
]]

local InstructionCell = qy.class("InstructionCell", qy.tank.view.BaseView, "legion_war/ui/InstructionCell")

function InstructionCell:ctor(params)
    InstructionCell.super.ctor(self)
end

function InstructionCell:getHight()
    return 3128
end

return InstructionCell
