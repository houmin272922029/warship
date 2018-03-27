local ChestView = qy.class("ChestView", qy.tank.view.BaseView, "soldiers_war.ui.ChestCell")

function ChestView:ctor(delegate, _idx)
   	ChestView.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Box")
    self:InjectView("Box2")
    self:InjectView("Box_open")
    self:InjectView("Num")
    self:InjectView("Lingqu")

    self.idx = _idx
    self.parent = delegate
end

function ChestView:render(data, type, callback)
    self.Box:setVisible(false)
    self.Box2:setVisible(false)
    self.Box_open:setVisible(false)
    self.Lingqu:setVisible(false)
    if type == "open" then
        self.Box_open:setVisible(true)
        self.Lingqu:setVisible(true)
    elseif type == "current" then
        self.Box2:setVisible(true)
    else
        self.Box:setVisible(true)
    end


    self:OnClick("bg", function()
        --callback(data)
        local x, y = self.parent.scrollView:getInnerContainer():getPosition()

        if math.abs(x) < self.idx * 100 + 39 then
            callback(data)
        end
    end,{["isScale"] = false})
    self.bg:setSwallowTouches(false)

    self.Num:setString(qy.TextUtil:substitute(67011)..data.checkpoint_id..qy.TextUtil:substitute(67012))

end

return ChestView
