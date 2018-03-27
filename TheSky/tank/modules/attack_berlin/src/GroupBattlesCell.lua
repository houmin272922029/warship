local GroupBattlesCell = qy.class("GroupBattlesCell", qy.tank.view.BaseView, "attack_berlin.ui.GroupBattlesCell")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService

function GroupBattlesCell:ctor(delegate)
    GroupBattlesCell.super.ctor(self)

    self:InjectView("Bg")
    self:InjectView("Name")
    self:InjectView("Selected")
    self:InjectView("gongpoimg")
    self:InjectView("cheliimg")
    self:InjectView("times")
    self.changeColorUi1 = {self.Bg}

    self.data = delegate.data
end

function GroupBattlesCell:render( _idx,selected)
    local status = model:getElitestatus(self.data[_idx].id)
    self.Selected:setVisible(_idx == selected)
    self.Name:setString(self.data[_idx].name)
    self.gongpoimg:setVisible( status == "success")
    self.cheliimg:setVisible(status == "fail")
    self.times:setString("剩余进攻次数："..model.scene_list[_idx].last_can_attack_times)
    qy.tank.utils.NodeUtil:darkNode(self.Bg,status ~= "normal")
  
end

return GroupBattlesCell