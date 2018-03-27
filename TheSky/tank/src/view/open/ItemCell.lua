local ItemCell = qy.class("ItemCell", qy.tank.view.BaseView, "view/open/ItemCell")

function ItemCell:ctor(delegate)
    ItemCell.super.ctor(self)

    self:InjectView("icon")
    self:InjectView("name")
    self:InjectView("levelopen")
    self:InjectView("des")
end

function ItemCell:setData(data)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/activity/activity.plist")
    self.icon:setSpriteFrame("Resources/activity/".. data.e_name..".png")
    self.des:setString(data.introduce)
    self.levelopen:setString(data.open_level.."级开启")
    self.name:setString("开启"..data.note.."功能")
end

return ItemCell