--[[
	Timer类，可生成独立instance，便于单独管理
	Author: Aaron Wei
	Date: 2015-03-04 17:46:50
]]

local Timer = class("Timer")

function Timer:ctor(delay,repeatCount,callback)
	self.currentCount = 0
	self.delay = delay
	self.repeatCount = repeatCount
	self.running = false
	self.timer = nil
	self.callback = callback
end

function Timer:start()
	if not self.timer then 
		self.running = true
		local function fun()
			-- print("Timer:callback")
			if self.repeatCount ~= nil and self.repeatCount > 0 and self.currentCount >= self.repeatCount then
				self:stop()
			else
				self.currentCount = self.currentCount + 1
                self.callback(self.repeatCount - self.currentCount)
			end
		end
    	self.timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(fun,self.delay,false)
    end
end

function Timer:stop() 
	if self.timer ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
		self.timer = nil
		self = nil
	end
end

function Timer:reset()
	self.currentCount = 0
	self:stop()
end

return Timer

