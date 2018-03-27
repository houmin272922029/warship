

local Awarditem = qy.class("Awarditem", qy.tank.view.BaseView, "fight_the_wolf/ui/Item")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService

function Awarditem:ctor(delegate)--delegate是传过来的表
    Awarditem.super.ctor(self)
    self:InjectView("Image_1")
    --self:InjectView("img")--进度
    self.types = delegate.types

    self:OnClick("Image_1", function(sender)
        require("fight_the_wolf.src.Tip").new(delegate):show()
    end)
    self.Image_1:setSwallowTouches(false)
end

return Awarditem
