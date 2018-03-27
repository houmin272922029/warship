local CheckPointView = qy.class("CheckPointView", qy.tank.view.BaseView, "soldiers_war.ui.CheckPointView")

function CheckPointView:ctor(delegate)
   	CheckPointView.super.ctor(self)

    self:InjectView("selected_bg")
    self:InjectView("checkpoint_num")
    self:InjectView("checkpoint_name")
    self:InjectView("completed")
    self:InjectView("Sprite_1")
    self:InjectView("Sprite_11")
    self:InjectView("tank")
end

function CheckPointView:render(data, idx)
    self.selected_bg:setVisible(false)
    self.Sprite_11:setVisible(false)
    self.completed:setVisible(false)
    self.checkpoint_name:setString(data.name)

    self.checkpoint_num:setString(qy.TextUtil:substitute(67011)..data.checkpoint_id..qy.TextUtil:substitute(67012))

    self.tank_icon = qy.tank.view.common.AwardItem.createAwardView({["id"] = data.monster2, ["type"] = 11, ["monster_type"] = 8}, 1, 1, false)
    self.tank_icon:showTitle(false)
    self.tank_icon:setPosition(23, 23)    
    self.tank:addChild(self.tank_icon)

end

return CheckPointView
