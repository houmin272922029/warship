local ChooseCell = qy.class("ChooseCell", qy.tank.view.BaseView, "break_fireline/ui/ChooseCell")

local model = qy.tank.model.BreakFireModel

function ChooseCell:ctor(delegate)
   	ChooseCell.super.ctor(self)

    self:InjectView("img")

    self.delegate = delegate
    self.selectid = 0

end

function ChooseCell:render(data, _idx)
    if self.delegate.types == 3 and model.settup == 30 then
        self.award = qy.tank.view.common.AwardItem1.createAwardView(data, 1, nil, false, function(sender)
        if self.delegate.selected ~= _idx then
            self.delegate:update(_idx)
        end
        end)
        if self.delegate.selected == _idx then
            self.img:setVisible(true)
        else
            self.img:setVisible(false)
        end
    else
        self.img:setVisible(false)
        self.award = qy.tank.view.common.AwardItem1.createAwardView(data, 1)
    end
	
    self.award:showTitle(false)
    self.award:setPosition(77,77)
    self.award.fatherSprite:setSwallowTouches(false)
    self:addChild(self.award, -1)

  
end

return ChooseCell