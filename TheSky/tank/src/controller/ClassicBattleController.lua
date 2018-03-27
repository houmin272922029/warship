--[[
	经典战役控制器
	Author: Aaron Wei
	Date: 2015-04-28 17:26:05
]]

local ClassicBattleController = qy.class("ClassicBattleController", qy.tank.controller.BaseController)

function ClassicBattleController:ctor(delegate)
    ClassicBattleController.super.ctor(self)

	print("ClassicBattleController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    self.model = qy.tank.model.ClassicBattleModel

    -- 提前加载JDZ_2.jpg 占用内存为 2700KB => 1800KB
    qy.Utils.preloadJPG("Resources/classicbattle/JDZ_2.jpg")

    self.view = qy.tank.view.classicbattle.ClassicBattleView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end

    --     ["enterTraining"] = function()
    --         local service = qy.tank.service.TrainingService
    --         service:getTrainInfo(nil,function(data)
    --             qy.tank.view.training.TrainingView.new( {
    --                     ["updateUserData"] = function()
    --                     end
    --             }):show(true)
    --         end)
    --     end,
    })

    self.viewStack:push(self.view)
end

return ClassicBattleController
