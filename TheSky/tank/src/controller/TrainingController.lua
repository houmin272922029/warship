
--[[--
   训练场 controller
    Author: H.X.Sun
    Date: 
]]

local TrainingController = qy.class("TrainingController", qy.tank.controller.BaseController)

function TrainingController:ctor(delegate)
    TrainingController.super.ctor(self)
	
	self.viewStack = qy.tank.widget.ViewStack.new()
	self.viewStack:addTo(self)
	self.model = qy.tank.model.TrainingModel

  if delegate == nil then
    delegate = {}
    delegate.tankUid = -1
  end

  delegate["dismiss"] = function()
    self.viewStack:pop()
    self.viewStack:removeFrom(self)
    self:finish()
  end

	self.viewStack:push(qy.tank.view.training.TrainingView.new(delegate))

		-- ["openOrUpdateArea"] = function(tankId)
  --           qy.tank.view.training.BatchTrainDialog.new(tankId, {
  --               --["dismiss"] = function()
  --           	--	self:finish()
  --       		--end
  --           }):show(true)
         
        -- end,

        
		-- }))
end

return TrainingController
