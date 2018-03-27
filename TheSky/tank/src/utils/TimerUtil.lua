local TimerUtil = class("TimerUtil")

TimerUtil.sequence = {}

function TimerUtil.create(name,callback,interval,loop) 
    if not TimerUtil.sequence[name] then
        TimerUtil.sequence[name] = {}
        TimerUtil.sequence[name].count = 0
        TimerUtil.sequence[name].loop = loop
        local function fun()
        	if TimerUtil.sequence[name].count < TimerUtil.sequence[name].loop then
	        	callback(TimerUtil.sequence[name].count+1)
                if TimerUtil.sequence[name] then
	        	  TimerUtil.sequence[name].count =  TimerUtil.sequence[name].count + 1
                end
    		else
    			TimerUtil.remove(name)
    		end
    	end
    	if loop == nil or loop <= 0 then
            TimerUtil.sequence[name].timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback,interval,false)
        else
        	TimerUtil.sequence[name].timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(fun,interval,false)
        end
    end
    return TimerUtil.sequence[name].timer
end

function TimerUtil.remove(name)
    if TimerUtil.sequence[name] then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(TimerUtil.sequence[name].timer)
        TimerUtil.sequence[name] = nil
    end
end

function TimerUtil.check(name)
    return TimerUtil.sequence[name] ~= nil
end

function TimerUtil.setTimeout(callback,delay)
    local node = cc.Node:create()
    local act = cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(callback))
    node:runAction(act)
    return act
end

function TimerUtil.removeTimeout()
end

return TimerUtil