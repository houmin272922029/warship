--[[
	战斗事件类
	Author: Aaron Wei
	Date: 2015-08-05 18:36:27
]]

local BattleEvent = qy.class("BattleEvent", qy.tank.event.BaseEvent)

GloabalEvent.SERVICE_LAODING_SHOW = "serviceLoadingShow"
GloabalEvent.SERVICE_LAODING_HIDE = "serviceLoadingHide"

function BattleEvent:ctor(name,callback,fixedPriority)
	BattleEvent.super.ctor(self,name,callback,fixedPriority)
end

return BattleEvent