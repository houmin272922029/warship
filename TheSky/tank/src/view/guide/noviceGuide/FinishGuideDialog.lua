--[[--
--完成新手引导 Dialog
--Author: H.X.Sun
--Date: 2015-08-24
--]]

local FinishGuideDialog = qy.class("FinishGuideDialog", qy.tank.view.BaseDialog, "view/guide/noviceGuide/FinishGuideDialog")

function FinishGuideDialog:ctor(delegate)
    FinishGuideDialog.super.ctor(self)

	self:OnClick("confirmBtn", function()
		self:dismiss()
	end)

end

return FinishGuideDialog