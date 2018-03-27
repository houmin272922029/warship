local BaseUI = class("BaseUI", cc.Node)

local function instanceUI(uifile)
    local root = nil
    local callBackProvider = function(luaFileName, node, callbackName)
        return function(sender)
            local func = root[callbackName]
            if func then
                func(root, sender)
            else
                if qy.DEBUG then
                    print("Warning: Cannot found lua function [" .. root.__cname .. ":" ..  callbackName .. "] in " .. root.__cname .. ".lua")
                end
            end
        end
    end
    if qy.product == "local" then
        package.loaded[uifile] = nil
    end
    local uiclass = require(uifile).create(callBackProvider)
    root = uiclass.root
    root:setContentSize(cc.Director:getInstance():getVisibleSize())
    ccui.Helper:doLayout(root)
    -- 所有UI组件的索引表，由LuaExtend.lua中实现
    root.ui = uiclass
    return root
end

function BaseUI.class(name, uifile, ...)
    if type(uifile) == "string" then
        local cls = class(name, BaseUI, ...)
        cls.__create = function()
            return instanceUI(uifile)
        end
        return cls
    else
        return class(name, BaseUI, uifile, ...)
    end
end

function BaseUI:ctor()
    -- 监听事件
    if self.onEnter or self.enterFinish or self.onExit or self.onExitStart or self.onCleanup then
        self:registerScriptHandler(function(event)
            if event == "enter" then
                if type(self.onEnter) == "function" then
                    self:onEnter()
                end
            elseif event == "enterTransitionFinish" then
                if type(self.onEnterFinish) == "function" then
                    self:onEnterFinish()
                end
            elseif event == "exit" then
                if type(self.onExit) == "function" then
                    self:onExit()
                end
            elseif event == "exitTransitionStart" then
                if type(self.onExitStart) == "function" then
                    self:onExitStart()
                end
            elseif event == "cleanup" then
                if type(self.onCleanup) == "function" then
                    self:onCleanup()
                end
            end
        end)
    end
end

function BaseUI:use(middleware)
    middleware(self)
    return self
end

function BaseUI:pushTo(viewStack)
    viewStack:push(self)
    return self
end

function BaseUI:InjectView(name, var)
    self[var or name] = self.ui[name]
end

return BaseUI
