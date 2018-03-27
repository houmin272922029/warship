--[[
	全局1s频率的心跳
	Author: Aaron Wei
	Date: 2015-04-09 15:45:20
]]

local Runtime = {}

Runtime.TIMER_UPDATE = "secondUpdate"
Runtime.sequence = {}
Runtime.timer = nil

function Runtime.start() 
	Runtime.timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		qy.Event.dispatch(Runtime.TIMER_UPDATE)
	end,1,false)
end

function Runtime.stop()
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(Runtime.timer)
end

function Runtime.add(callback) 
	table.insert(Runtime.sequence,callback)
	return  cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback,1,false)
end

function Runtime.remove(id)
	-- if Runtime.check(id) then
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(id)
	-- end
end

function Runtime.removeAll()
	for k,v in pairs(Runtime.sequence) do
		Runtime.remove(v)
	end
end

function Runtime.check(id)
	for k,v in pairs(Runtime.sequence) do
		if v == id then
			return true
		end
	end
	return false
end

return Runtime