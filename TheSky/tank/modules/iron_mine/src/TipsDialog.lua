local TipsDialog = qy.class("TipsDialog", qy.tank.view.BaseDialog, "iron_mine.ui.TipsDialog")

local model = qy.tank.model.OperatingActivitiesModel
function TipsDialog:ctor(type, award)
   	TipsDialog.super.ctor(self)

   	self:InjectView("ContentBg")
   	self:InjectView("Num")
   	self:InjectView("Img")
    self:InjectView("Mul")

    self:OnClick("Btn_ok", function()
        self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    local id = type + 5
    self.Img:setTexture("Resources/common/icon/coin/" .. id .. ".png" )
    self.Num:setString(award[1].num)
    self.Mul:setString(qy.TextUtil:substitute(49003) .. model.oldIronMineTimes .. qy.TextUtil:substitute(49004))
end

return TipsDialog
