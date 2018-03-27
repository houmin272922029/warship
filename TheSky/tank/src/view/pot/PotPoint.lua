local potPoint = qy.class("potPoint", qy.tank.view.BaseView, "view/pot/potPoint")

function potPoint:ctor(delegate)
    potPoint.super.ctor(self)

    self:InjectView("close")
    self:InjectView("open")
    self:InjectView("itemContainer")
    self.delegate = delegate

    self.open:setVisible(true)
    self.close:setVisible(false)
    self.itemContainer:setVisible(false)

    self:OnClick("close", function(sender)
        self.close:setVisible(false)
        self.open:setVisible(true)
        self.delegate:getAward()
    end)
end

function potPoint:upReward(data)
    if not self.awardItem then
        self.awardItem = qy.tank.view.common.AwardItem.createAwardView(data , 1 , 1)
        self.itemContainer:addChild(self.awardItem)
    else
       local param = qy.tank.view.common.AwardItem.getItemData(data)
        self.awardItem:update(param)
    end
end

return potPoint