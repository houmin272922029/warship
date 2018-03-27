local ChooseCell = qy.class("ChooseCell", qy.tank.view.BaseView)

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService

function ChooseCell:ctor(delegate)
   	ChooseCell.super.ctor(self)

end

function ChooseCell:render(data, _idx)
    self.award = qy.tank.view.common.AwardItem.createAwardView(data, 1)
    self.award:setScale(0.85)
    self.award:showTitle(false)
    self.award:setPosition(77,77)
    self:addChild(self.award, -1)
    self.award.fatherSprite:setSwallowTouches(false)

  
end

return ChooseCell