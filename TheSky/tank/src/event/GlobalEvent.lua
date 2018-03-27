--[[
	全局事件类
	Author: Aaron Wei
	Date: 2015-04-03 20:53:28
]]

local GlobalEvent = qy.class("GlobalEvent", qy.tank.event.BaseEvent)

GloabalEvent.SERVICE_LAODING_SHOW = "serviceLoadingShow"
GloabalEvent.SERVICE_LAODING_HIDE = "serviceLoadingHide"

function GlobalEvent:ctor(name,callback,fixedPriority)
	GlobalEvent.super.ctor(self,name,callback,fixedPriority)
end

return GlobalEvent