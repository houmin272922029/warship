--
-- Author: Your Name
-- Date: 2015-07-09 17:35:11
--

local EndAction = class("EndAction")

EndAction.ACTION_START = "actionStart"
EndAction.ACTION_END = "actionEnd"

function EndAction:ctor(data)
	self.data = data
	self.manager = qy.tank.manager.BattleRoundManager
	self.model = qy.tank.model.BattleModel
end

function EndAction:excute()
	self.manager:stop()
	self.manager:play()
end

function EndAction:stop()
	self.manager:play()
	-- if self.listener then
	-- 	qy.Event.remove(self.listener)
	-- end
end

return EndAction