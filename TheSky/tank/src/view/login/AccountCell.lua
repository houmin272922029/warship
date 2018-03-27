--[[--
--账号cell
    Author: H.X.Sun
    Date: 2015-07-28
--]]

local AccountCell = qy.class("AccountCell", qy.tank.view.BaseView, "view/login/AccountCell")

function AccountCell:ctor(delegate)
    AccountCell.super.ctor(self)

	self:InjectView("bg")
	self:InjectView("selectBtn")
	--确定
	self:OnClick("selectBtn", function()
		qy.tank.model.LoginModel:saveAccountData(qy.tank.model.LoginModel:getUserAccountData()[self.idx])
		delegate.updateData()
	end, {["isScale"] = false})
	-- self.selectBtn:setSwallowTouches(false)
end

function AccountCell:update(idx)
	self.idx = idx
	self.selectBtn:setTitleText(qy.tank.model.LoginModel:getUserAccountData()[idx].username)
	if idx % 2 == 1 then
		self.bg:setOpacity(255)
	else
		self.bg:setOpacity(64)
	end
end

return AccountCell
