--
-- Author: Your Name
-- Date: 2015-07-09 17:34:52
--
--[[
	战斗动作执行，包含一次完整的进攻（包括连击）防御（包括群上）回合
	Author: Aaron Wei
	Date: 2015-02-04 12:24:27
]]

local PreAction = class("PreAction")

PreAction.ACTION_START = "actionStart"
PreAction.ACTION_END = "actionEnd"

function PreAction:ctor(data)
	self.data = data
	self.manager = qy.tank.manager.BattleRoundManager
	self.model = qy.tank.model.BattleModel
end

function PreAction:excute()
	-- print("")
	self.manager:stop()
	self.manager:play()
end

function PreAction:stop()
	self.manager:play()
	-- if self.listener then
	-- 	qy.Event.remove(self.listener)
	-- end
end

return PreAction