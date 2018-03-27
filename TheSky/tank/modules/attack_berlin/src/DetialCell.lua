
--仅仅是战报
local DetialCell = qy.class("DetialCell", qy.tank.view.BaseView, "attack_berlin.ui.DetialCell")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
local moduleType = qy.tank.view.type.ModuleType

function DetialCell:ctor(delegate)
   	DetialCell.super.ctor(self)

    self:InjectView("lookBt")
   	self:InjectView("name")
   	self:InjectView("time")
    
    self:OnClick("lookBt", function()
        local ss = self.data[self.index].combat_id
         service:showCombat(ss,function (  )
           -- body
         end)
    end,{["isScale"] = false})
    self.data = delegate.data
end



function DetialCell:render(_idx)
	self.index = _idx
	self.name:setString(self.data[_idx].combat_name)
	self.time:setString(self.data[_idx].t)
end

return DetialCell