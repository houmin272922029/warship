--[[
    说明：纯即时lua事件，与EventUtil分开
    作者：林国锋
]]

local EventEmitter = class("EventEmitter")

-- 全局的
local listeners = setmetatable({}, {__made = "k"})

local call_event = function(func, ...)
    if type(func) == "function" then
        func(...)
    end
end

function EventEmitter.on(self, event, listener)
    listeners[self] = listeners[self] or {}

    listeners[self][event] = listener
end

function EventEmitter.emit(self, event, ...)
    local l = listeners[self]
    if l and l[event] then
        call_event(l[event], ...)
    else
        for _, l in pairs(listeners) do
            call_event(l[event], ...)
        end
    end
end

function EventEmitter.removeListener(self)
    listeners[self] = nil
end

return EventEmitter

--[[test]]
--[[

local A = setmetatable({}, {__index = EventEmitter})
local B = setmetatable({}, {__index = EventEmitter})

EventEmitter.on(A, "close", function()
    print("onclose")
end)

A:on("open", function()
    print("onopen")
end)

B:on("open2", function()
    print("onopen2")
end)

A:emit("open")
A:emit("close")
EventEmitter.removeListener(B)
A:emit("open2")
]]
