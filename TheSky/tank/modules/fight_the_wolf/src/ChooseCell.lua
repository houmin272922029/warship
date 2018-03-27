local ChooseCell = qy.class("ChooseCell", qy.tank.view.BaseView,"fight_the_wolf.ui.ChooseCell")


function ChooseCell:ctor(delegate)
   	ChooseCell.super.ctor(self)
   	self:InjectView("img")
end

function ChooseCell:render(data, _idx,types)
	self.img:setVisible(tonumber(types) == 1)
    self.award = qy.tank.view.common.AwardItem.createAwardView(data, 1)
    self.award:setScale(0.85)
    self.award:showTitle(false)
    self.award:setPosition(77,77)
    self:addChild(self.award, -1)
    self.award.fatherSprite:setSwallowTouches(false)  
end

return ChooseCell