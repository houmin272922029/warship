--[[--
--拜访名将dialog
--Author: lianyi
--Date: 2015-06-29
--]]--

local VisitGeneralDialog = qy.class("VisitGeneralDialog", qy.tank.view.BaseDialog)

function VisitGeneralDialog:ctor()
    VisitGeneralDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel 
	--通用弹窗样式
	local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(900,555),
		position = cc.p(0,0),
		offset = cc.p(0,0), 
		titleUrl = "Resources/common/title/baifang.png",

		["onClose"] = function()
			self:dismiss()
		end
	})

	self:addChild(style, -1)

	local view = qy.tank.view.operatingActivities.visitGeneral.VisitGeneralDialog2.new(self)
	view:setPosition(-100, -100)
	style.bg:addChild(view)
end

return VisitGeneralDialog