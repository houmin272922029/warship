local AutoFightItem = qy.class("AutoFightItem", qy.tank.view.BaseView, "view/campaign/AutoFightItem")

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
    self.titleTxt:setString(qy.TextUtil:substitute(67006)..(index+1)..qy.TextUtil:substitute(67007))

    --时间片  每个道具出现的时间
    self.pieceTime = 0.2

    for i = 1, 4 do
        local item = qy.tank.view.common.ItemIcon.new()
        self["item" .. i]:addChild(item)
        self["icon" .. i] = item
        item:setVisible(false)
    end

    -- local awardType = qy.tank.view.type.AwardType

    -- local awardData = {}
    -- if awards.user_exp~=nil and awards.user_exp.add_exp ~=nil then
    --     awardData.type = awardType.USER_EXP
    --     awardData.num = awards.user_exp.add_exp
    -- else
    --     awardData.type = awardType.USER_EXP
    --     awardData.num = 0
    -- end
    -- local expItem = qy.tank.view.common.AwardItem.createAwardView(awardData,1)
    -- self.item1:addChild(expItem)

    self.maxItem = 1

    -- if awards.award~=nil and #awards.award>0 then
    --     self.maxItem = #awards.award + 1 
    --     for i=1,#awards.award do
    --         local tempAwardItem = qy.tank.view.common.AwardItem.createAwardView(awards.award[i],1)
    --         if i == 1 then 
    --             self.item2:addChild(tempAwardItem)
    --         elseif i==2 then
    --             self.item3:addChild(tempAwardItem)
    --         elseif i==3 then
    --             self.item4:addChild(tempAwardItem)
    --         end
    --     end
    -- end
--    self:runThisAnimation()
end

function AutoFightItem:setData(data)
    self.maxItem = #data.award + 1
    for i = 1, 4 do
        self["icon" .. i]:setVisible(false)
    end
    for i, v in pairs(data.award) do
        local num = tonumber(i) + 1
        local award = qy.tank.view.common.AwardItem.getItemData(v)
        self["icon" .. num]:setData(award)
        self["icon" .. num]:setVisible(true)
    end

    local awardType = qy.tank.view.type.AwardType
    local awardData = {}
    if data.user_exp~=nil and data.user_exp.add_exp ~=nil then
        awardData.type = awardType.USER_EXP
        awardData.num = data.user_exp.add_exp
    else
        awardData.type = awardType.USER_EXP
        awardData.num = 0
    end

    local award = qy.tank.view.common.AwardItem.getItemData(awardData)
    self.icon1:setData(award)
    self.icon1:setVisible(true)
end


function AutoFightItem:update(index)
    self.titleTxt:setString(qy.TextUtil:substitute(67006)..(index+1)..qy.TextUtil:substitute(67007))
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