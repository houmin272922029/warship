local AutoFightItem = qy.class("AutoFightItem", qy.tank.view.BaseView, "singlehero.ui.AutoFightItem")

function AutoFightItem:ctor(callBack, index , awards)
    AutoFightItem.super.ctor(self)

    self:InjectView("titleBg")
    self:InjectView("item1")
    self:InjectView("item2")
    self:InjectView("item3")
    self:InjectView("item4")
    self:InjectView("titleTxt")

    self.callBack = callBack

    self:showOrHideAll(false)
    self.titleTxt:setString(qy.TextUtil:substitute(6002, (index+1)))

    --时间片  每个道具出现的时间
    self.pieceTime = 0.2

    for i = 1, 4 do
        local item = qy.tank.view.common.ItemIcon.new()
        self["item" .. i]:addChild(item)
        self["icon" .. i] = item
        item:setVisible(false)
    end


    self.maxItem = 1

end

function AutoFightItem:setData(data)
    -- self.maxItem = 1
    -- for i = 1, 4 do
    --     self["icon" .. i]:setVisible(false)
    -- end
    
    -- local award = qy.tank.view.common.AwardItem.getItemData(data.award)
    -- self["icon" .. 1]:setData(award)
    -- self["icon" .. 1]:setVisible(true)

    self.maxItem = #data.award + 1
    for i = 1, 4 do
        self["icon" .. i]:setVisible(false)
    end
    local index = 0
    for i, v in pairs(data.award) do
        local num = tonumber(i) + index
        local award = qy.tank.view.common.AwardItem.getItemData(v)
        self["icon" .. num]:setData(award)
        self["icon" .. num]:setVisible(true)
    end
end


function AutoFightItem:update(index)
    self.titleTxt:setString(qy.TextUtil:substitute(6002, (index+1)))
    self:showOrHideAll(true)
    local scale = 0.8
    self.item1:setScale(scale)
    self.item2:setScale(scale)
    self.item3:setScale(scale)
    self.item4:setScale(scale)
end

function AutoFightItem:showOrHideAll(isVisible)
    self.item1:setScale(0.05)
    self.item2:setScale(0.05)
    self.item3:setScale(0.05)
    self.item4:setScale(0.05)
    self.item1:setVisible(isVisible)
    self.item2:setVisible(isVisible)
    self.item3:setVisible(isVisible)
    self.item4:setVisible(isVisible)
    self.titleBg:setVisible(isVisible)
    self.titleTxt:setVisible(isVisible)
end

function AutoFightItem:runThisAnimation(nextIndex)
    self:showOrHideAll(false)
    self.nextIndex = nextIndex
    self.titleBg:setVisible(true)
    self.titleTxt:setVisible(true)

    function callBack2()
        self:runEffert(self.img2, nil , 0.5)
    end

    for i=1,self.maxItem do
        if i ~= self.maxItem then
            self:runEffert(self:findViewByName("item"..i), nil , self.pieceTime*(i-1))
        else
            self:runEffert(self:findViewByName("item"..i)  ,cc.CallFunc:create(callBack2) , self.pieceTime*(i-1))
        end
    end

end

function AutoFightItem:runEffert(item , callBack , delayTime)

    function  initFunc( ... )
        item:setScale(0.1)
        item:setVisible(true)
    end

    if(callBack~=nil) then
        function toBack()
            self.callBack(self.nextIndex)
        end
        item:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime)  , cc.CallFunc:create(initFunc) ,cc.ScaleTo:create(self.pieceTime, 0.8) ,cc.DelayTime:create(0.4) ,cc.CallFunc:create(toBack)))
    else
        item:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime)  , cc.CallFunc:create(initFunc), cc.ScaleTo:create(self.pieceTime, 0.8) ,cc.DelayTime:create(0.4)))
    end

end

return AutoFightItem
