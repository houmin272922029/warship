--[[
	模块间通讯基类
	Author: Aaron Wei
	Date: 2015-04-07 20:42:56
]]

local BaseCommand = class("BaseCommand")

function BaseCommand:startController(controller)
    qy.App.runningScene:push(controller)
end

function BaseCommand:finish()
    qy.App.runningScene:pop()
end

function BaseCommand:dispatchEvent(name, usedata)
    qy.Event.dispatch(name, usedata)
end

return BaseCommand
