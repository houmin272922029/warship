
-- local BaseScene = class("BaseScene",cc.Scene)
local BaseScene = class("BaseScene", function()
    return cc.Scene:create()
end)

function BaseScene:ctor()
    self.guide = qy.tank.view.guide.Guide.new()
    self.guide:setLocalZOrder(25)
    self.guide:addTo(self)
    qy.GuideManager:registerContainer(self.guide)

    self.controllerStack = qy.tank.widget.ViewStack.new()
    self.controllerStack:setLocalZOrder(5)
    self.controllerStack:addTo(self)

    self.dialogStack = qy.tank.widget.ViewStack.new()
    self.dialogStack:isRetain(true)
    self.dialogStack:setLocalZOrder(10)
    self.dialogStack:addTo(self)

    self.alertSingle = qy.tank.view.Alert.new()
    self.alertSingle:setLocalZOrder(20)
    self.alertSingle:addTo(self)

    self.alertSingle1 = qy.tank.view.Alert1.new()
    self.alertSingle1:setLocalZOrder(20)
    self.alertSingle1:addTo(self)

    self.hint = qy.tank.view.Hint.new()
    self.hint:setLocalZOrder(30)
    self.hint:addTo(self)

    self.loading = qy.tank.widget.ServiceLoading.new()
    self.loading:setLocalZOrder(40)
    self.loading:setVisible(false)
    self.loading:setVisible(false)
    self.loading:addTo(self)

    if qy.DEBUG then
        -- self.monitor = qy.tank.widget.Monitor.new()
        -- self.monitor:setPosition(0,95)
        -- self.monitor:setLocalZOrder(50)
        -- self:addChild(self.monitor)
    end

    self.debuger = qy.tank.widget.Debugger.new()
    self.debuger:setLocalZOrder(60)
    self:addChild(self.debuger)

    --只有新手引导再次注册，新手引导要由于其他模块的onEnter被注册
    qy.guide = nil
    qy.guide = self.guide

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

function BaseScene:push(controller)
    local currentController = self.controllerStack:currentView()
    if currentController and currentController.__cname == "MainController" then
        self.controllerStack:push(controller, false)
    else
        self.controllerStack:push(controller)
    end
end

function BaseScene:pop()
    self.controllerStack:pop()
end

function BaseScene:replace(controller)
    self.controllerStack:replace(controller)
end

function BaseScene:showDialog(dialog)
    self.dialogStack:push(dialog)
end

function BaseScene:dismissDialog()
    self.dialogStack:pop()
end

function BaseScene:disissAllDialog()
    -- self.dialogStack:popAll()
    self.dialogStack:clean()
end

function BaseScene:disissAllView()
    self.controllerStack:popToRoot()
end

function BaseScene:registHintAndAlert()
    qy.alert = nil
    qy.alert = self.alertSingle
    qy.alert1 = nil
    qy.alert1 = self.alertSingle1
    qy.hint = nil
    qy.hint = self.hint
    qy.debuger = nil
    qy.debuger = self.debuger
end

function BaseScene:onEnter()
    self.listener_a = qy.Event.add(qy.Event.SERVICE_LOADING_SHOW,function(event)
        self.loading:setVisible(true)
    end)

    self.listener_b = qy.Event.add(qy.Event.SERVICE_LOADING_HIDE,function(event)
        self.loading:setVisible(false)
    end)

    self.listener_c = qy.Event.add("SDKEvent",function(event)
        print("====================>> SDKEvent")
    end)

    qy.App.runningScene = self
    self:registHintAndAlert()

    if self.monitor then
        self.monitor:start()
    end
end

function BaseScene:onExit()
    qy.Event.remove(self.listener_a)
    qy.Event.remove(self.listener_b)

    if self.monitor then
        self.monitor:stop()
    end
end

function BaseScene:onCleanup()
end

return BaseScene
