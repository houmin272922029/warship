--[[--
	一键升级成功的弹窗
	Author: H.X.Sun
--]]--

local UpSuccessDialog = qy.class("UpSuccessDialog", qy.tank.view.BaseDialog, "alloy/ui/UpSuccessDialog")

function UpSuccessDialog:ctor(data)
	UpSuccessDialog.super.ctor(self)
	self.isCanceledOnTouchOutside = true
	self:InjectView("bg")
	self:InjectView("exp_num")
	local awardList = qy.AwardList.new({
        ["award"] = data,
        ["hasName"] = true,
        ["cellSize"] = cc.size(180,180),--一个cell的大小，包括间距
    })
	self.bg:addChild(awardList)
	awardList:setPosition(106,355)
	local addExp = qy.tank.model.AlloyModel:getAddExp()
	self.exp_num:setString(addExp)

	self:OnClick("ok_btn",function()
		self:dismiss()
	end)
end

return UpSuccessDialog
