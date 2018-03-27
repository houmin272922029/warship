local LeaveDialog = qy.class("LeaveDialog", qy.tank.view.BaseDialog, "attack_berlin.ui.LeaveDialog")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function LeaveDialog:ctor(delegate, callback)
   	LeaveDialog.super.ctor(self)

   	self:InjectView("Text")
    if model:getStatus() == 1 then
        self.Text:setString("是否要离开队伍？")
    elseif model:getStatus() == 2 then
        self.Text:setString("是否要解散队伍？")
    end

    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_confirm", function()
        self:dismiss()
        callback()
    end,{["isScale"] = false})

end


return LeaveDialog
