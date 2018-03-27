local ChestBoxCell = qy.class("ChestBoxCell", qy.tank.view.BaseView, "beat_enemy.ui.ChestBoxCell")

function ChestBoxCell:ctor(_idx)
   	ChestBoxCell.super.ctor(self)

    self:InjectView("Box")
    self:InjectView("Box_empty")
    self:InjectView("Box_open")
    self:InjectView("Btn_open")
    self:InjectView("Point")

    self.idx = _idx
end

function ChestBoxCell:render(delegate, data, _type)
    self.Box:setVisible(false)
    self.Box_empty:setVisible(false)
    self.Box_open:setVisible(false)
    self.type = _type
    if _type == "open" then
        self.Box_open:setVisible(true)
    elseif _type == "empty" then
        self.Box_empty:setVisible(true)
    else
        self.Box:setVisible(true)
    end


    self:OnClick(self.Btn_open, function()
        --local x, y = self.parent.scrollView:getInnerContainer():getPosition()

        --if math.abs(x) < self.idx * 100 + 39 then
            require("beat_enemy.src.ChestDetailsDialog").new(delegate, data, _type):show()
        --end
    end,{["isScale"] = false})
    self.Btn_open:setSwallowTouches(false)

    self.Point:setString(data.point)

end


return ChestBoxCell
