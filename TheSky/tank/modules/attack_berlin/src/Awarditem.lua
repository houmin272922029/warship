

local Awarditem = qy.class("Awarditem", qy.tank.view.BaseView, "attack_berlin/ui/Awarditem")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService

function Awarditem:ctor(delegate)
    Awarditem.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("img")--进度
    self.types = delegate.types
    self:OnClick("bg", function(sender)
        require("attack_berlin.src.Tip").new(delegate):show()
    end)
    self.bg:setSwallowTouches(false)
end

return Awarditem
