local ScenesManager = {}

function ScenesManager:instance()
    local o = _G.ScenesManager
    if o == nil then 
        o = {}
        _G.ScenesManager = o
        setmetatable(o, self)
        self.__index = self 
    end
    return o
end

function ScenesManager:start()
    print("ScenesManager:start")
    self:showLoginScene()
end

function ScenesManager:showLoginScene()
    self:replaceScene(qy.tank.view.scene.LoginScene.new())
end

function ScenesManager:showMainScene()
    self:replaceScene(qy.tank.view.scene.MainScene.new())
end

function ScenesManager:showBattleScene()
    self:replaceScene(qy.tank.view.scene.BattleScene.new())
end

function ScenesManager:pushBattleScene()
    if self:getRunningScene() then
        self:getRunningScene().sceneTransition:show(function ()
            qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
            qy.GuideManager:next(4)
        end)
    else
        qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
    end
end

function ScenesManager:popScene()
    cc.Director:getInstance():popScene()
end

function ScenesManager:pushScene(scene)
    cc.Director:getInstance():pushScene(scene)
end

function ScenesManager:replaceScene(scene)
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

function ScenesManager:getRunningScene()
    return cc.Director:getInstance():getRunningScene()
end

return ScenesManager