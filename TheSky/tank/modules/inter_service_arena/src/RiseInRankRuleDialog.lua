local RiseInRankRuleDialog = qy.class("RiseInRankRuleDialog", qy.tank.view.BaseDialog, "inter_service_arena.ui.RiseInRankRuleDialog")


function RiseInRankRuleDialog:ctor(callback)
   	RiseInRankRuleDialog.super.ctor(self)

   	self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(590,530),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "inter_service_arena/res/jinjishuoming.png",
        bgShow = false,

        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style)
end

return RiseInRankRuleDialog
