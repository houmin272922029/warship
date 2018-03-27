local SelectCell = qy.class("SelectCell", qy.tank.view.BaseView, "strong.ui.SelectCell")

function SelectCell:ctor(delegate)
   	SelectCell.super.ctor(self)
   	self.delegate = delegate
   	self:InjectView("Sprite_1")
   	self:InjectView("Sprite_2")
   	self:InjectView("Sprite_3")
   	self:InjectView("Sprite_4")
   	self.Sprite_2:setScaleX(0.95)
   	self.Sprite_1:setVisible(false)

end

function SelectCell:setData(Type, idx)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("strong/res/strong.plist")
	local index = Type == 1 and idx or (idx + 3)
    self.Sprite_3:setSpriteFrame("strong/res/s".. index ..".png")
    self.Sprite_4:setSpriteFrame("strong/res/a".. index ..".png")
end

return SelectCell