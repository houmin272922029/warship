
local IntelligenceDialog = qy.class("IntelligenceDialog", qy.tank.view.BaseDialog, "offer_a_reward.ui.IntelligenceDialog")

function IntelligenceDialog:ctor(data)
    IntelligenceDialog.super.ctor(self)

    self:InjectView("Txt_detailed")
    self:InjectView("Txt_reward_add")
    self:InjectView("Btn_confirm")

    self.Txt_detailed:setString(data.content)
    self.Txt_reward_add:setString("军功奖励加成："..(data.plus / 10).."%")

    self:OnClick(self.Btn_confirm, function()
        self:removeSelf()
    end,{["isScale"] = false})

end


return IntelligenceDialog
