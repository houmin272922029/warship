local ItemCell = qy.class("ItemCell", qy.tank.view.BaseView, "strong.ui.ItemCell")
local model = qy.tank.model.StrongModel

function ItemCell:ctor(delegate)
   	ItemCell.super.ctor(self)
   	self.delegate = delegate
    self:InjectView("name")
    self:InjectView("Sprite_4")
    self:InjectView("Sprite_2")
    self:InjectView("Sprite_3")
    self:InjectView("Button_1")
    for i=1,5 do
        self:InjectView("Sprite"..i)
    end
    self.Sprite_2:removeAllChildren()
    -- 进度条 
    self.bar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("strong/res/8.png"))
    self.bar:setAnchorPoint(0,0)
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar:setMidpoint(cc.p(0,0))
    self.bar:setBarChangeRate(cc.p(1, 0))
    self.bar:setPosition(0, 0)
    self.Sprite_2:addChild(self.bar)
    self:OnClick("Button_1", function(sender)
        model:viewRedirectByModuleType(self.data)
    end)
end

function ItemCell:setData(index, data)
    self.index = index
    self.data = data
    self.Sprite_2:setVisible(self.index == 1)
    self.Sprite_3:setVisible(self.index == 1)
    self.bar:setPercentage(self.index == 1 and (model.StrongFcList[data.id].progressNum) * 100 or 0)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("strong/res/strong.plist")
    self.Sprite_4:setSpriteFrame("strong/res/".. (index == 1 and 9 or 10) ..".png")
    self.name:setString(data.des)
    for i=1,5 do
        self["Sprite"..i]:setVisible(false)
        if self.index == 2 then
            for j=1,data.rank do
                self["Sprite"..j]:setVisible(true)
            end
        end
    end
end

return ItemCell