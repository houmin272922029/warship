--[[
    战斗场景
    Author: Aaron Wei
    Date: 2015-01-14 17:56:59
]]

local BattleScene = qy.class("BattleScene", qy.tank.view.scene.BaseScene)

function BattleScene:ctor()
	print("BattleScene ctor")
    BattleScene.super.ctor(self)

    -- 创建切换场景
    self.sceneTransition = qy.tank.widget.SceneTransition.new()
    self.sceneTransition:setLocalZOrder(27)
    self.sceneTransition:addTo(self)
end

function BattleScene:onEnter()
	print("BattleScene enter")
	BattleScene.super.onEnter(self)

    qy.tank.command.BattleCommand:addResources()

	self.sceneTransition:open(function()
        -- 销毁切换场景
        if self.sceneTransition and tolua.cast(self.sceneTransition,"cc.Node") then
            self.sceneTransition:destroy()
            self:removeChild(self.sceneTransition)
            self.sceneTransition = nil
        end
    end)

    self:push(qy.tank.controller.BattleController.new())
end

function BattleScene:onExit()
	print("BattleScene exit")
	BattleScene.super.onExit(self)
	local delay = qy.tank.utils.Timer.new(0.01,1,function()
		qy.Event.dispatch(qy.Event.BACK_OF_BATTLE)
	end)
	delay:start()
end

function BattleScene:onCleanup()
	print("BattleScene cleanup")
	BattleScene.super.onCleanup(self)

    qy.tank.command.BattleCommand:removeResources()

	-- 销毁切换场景
    if self.sceneTransition and tolua.cast(self.sceneTransition,"cc.Node") then
        self.sceneTransition:destroy()
        self:removeChild(self.sceneTransition)
        self.sceneTransition = nil
    end
end

return BattleScene
