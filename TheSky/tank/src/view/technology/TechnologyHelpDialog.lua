--[[--
--炮手训练dialog
--Author: lianyi
--Date: 2015-06-29
--]]--

local TechnologyHelpDialog = qy.class("TechnologyHelpDialog", qy.tank.view.BaseDialog, "view/technology/TechnologyHelpDialog")

function TechnologyHelpDialog:ctor()
    TechnologyHelpDialog.super.ctor(self)

	--通用弹窗样式
	local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(575,343),
		position = cc.p(0,0),
		offset = cc.p(0,0), 
		titleUrl = "Resources/common/title/huodekejishu.png",

		["onClose"] = function()
			self:dismiss()
		end
	})
	self:addChild(style, -1)
	
	
	-- self:InjectView("item1")

	self:OnClick("btn1",function(sender)
		qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.CLASSIC_BATTLE)
		self:dismiss()
	end)

	self:OnClick("btn2",function(sender)
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXTRACTION_CARD)
		self:dismiss()
	end)

	self:OnClick("btn3",function(sender)
		qy.tank.model.FightJapanModel.autoOpen = "exchange"
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.F_J_EX_SHOP)
		self:dismiss()
	end)

end

return TechnologyHelpDialog