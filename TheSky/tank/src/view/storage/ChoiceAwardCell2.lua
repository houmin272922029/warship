local ChoiceAwardCell2 = qy.class("ChoiceAwardCell2", qy.tank.view.BaseView, "view/storage/ChoiceAwardCell")


function ChoiceAwardCell2:ctor(delegate)
   	ChoiceAwardCell2.super.ctor(self)

    self:InjectView("Receive")

    self.delegate = delegate

end

function ChoiceAwardCell2:render(data, _idx)
	
    
	self.award = qy.tank.view.common.AwardItem.createAwardView(data, 1, nil, false, function(sender)
        if self.delegate.selected ~= _idx then
            self.delegate:update(_idx)
        end
    end)
    self.award:showTitle(false)
    self.award:setPosition(77,77)
    self.award.fatherSprite:setSwallowTouches(false)
    self:addChild(self.award, -1)

    if self.delegate.selected == _idx then
        self.Receive:setVisible(true)
    else
        self.Receive:setVisible(false)
    end
end

return ChoiceAwardCell2