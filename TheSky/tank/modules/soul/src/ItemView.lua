local ItemView = qy.class("ItemView", qy.tank.view.BaseView)

function ItemView:ctor(data, delegate)
   	ItemView.super.ctor(self)


    self.delegate = delegate
    for i = 1, 2 do
        self["item" .. i] = qy.tank.view.common.ItemIcon.new()
        self["item" .. i]:setPositionX(120 * i - 50)
        self["item" .. i]:setPositionY(80)
        self["item" .. i]:setVisible(false)
        self:addChild(self["item" .. i])
        
    end
    for i, v in pairs(data) do
        self:update(i, v)
    end

end

function ItemView:render(data)
    for i = 1, 2 do
        self["item" .. i]:setVisible(false)
    end

    for i, v in pairs(data) do
        self:update(i, v)
    end
end

function ItemView:update(i, v)
    self["item" .. i]:setVisible(true)
    local data = qy.tank.view.common.AwardItem.getItemData(v)
    data.beganFunc = function(sender)
        self.delegate.selectItem =  self["item" .. i]
        self.delegate.initPositionX = self["item" .. i]:getPositionX()
        self.delegate.initPositionY = self["item" .. i]:getPositionY()
    end

    data.callback = function()
        
    end

    self["item" .. i]:setData(data)
    self["item" .. i].fatherSprite:setSwallowTouches(false)
end

return ItemView
