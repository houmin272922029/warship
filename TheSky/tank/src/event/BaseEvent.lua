--[[
	事件类基类	
	Author: Aaron Wei
	Date: 2015-01-15 21:11:34
]]

local BaseEvent = class("BaseEvent")


function BaseEvent:ctor(name,callback,fixedPriority)
	self.listener = nil
	self.dispatcher = cc.Director:getInstance():getEventDispatcher()
	self:add(name,func,fixedPriority)
end

-- 增加一个事件监听
-- name: 事件名称
-- func: 事件回调
-- fixedPriority: 优化级, 默认为1
function BaseEvent:add(name,callback,fixedPriority)
    self.listener = cc.EventListenerCustom:create(name,callback)
    self.dispatcher:addEventListenerWithFixedPriority(self.listener, fixedPriority or 1)
end

-- 删除一个事件监听
function BaseEvent:remove()
    if self.listener then
        self.dispatcher:removeEventListener(self.listener)
    end
end

-- 触发一个事件监听
function BaseEvent:dispatch(name, usedata)
    local event = cc.EventCustom:new(name)
    event._usedata = usedata
    self.dispatcher:dispatchEvent(event)
end

return BaseEvent