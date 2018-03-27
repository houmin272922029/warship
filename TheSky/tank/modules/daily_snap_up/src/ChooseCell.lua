local ChooseCell = qy.class("ChooseCell", qy.tank.view.BaseView)


function ChooseCell:ctor(delegate)
   	ChooseCell.super.ctor(self)
   	
end

function ChooseCell:render(data, _idx,types)
	
    self.award = qy.tank.view.common.AwardItem.createAwardView(data, 1)
    self.award:setScale(0.85)
    self.award:showTitle(false)
    self.award:setPosition(77,77)
    self:addChild(self.award, -1)
    self.award.fatherSprite:setSwallowTouches(false)  
end

return ChooseCell