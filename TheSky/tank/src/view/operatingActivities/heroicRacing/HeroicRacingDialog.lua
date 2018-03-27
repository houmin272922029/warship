--[[--
--y英勇竞速dialog
--Author: lianyi
--Date: 2015-06-29
--]]--

local HeroicRacingDialog = qy.class("HeroicRacingDialog", qy.tank.view.BaseDialog)

function HeroicRacingDialog:ctor()
    HeroicRacingDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel
	--通用弹窗样式
	local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(800, 615),
		position = cc.p(0,0),
		offset = cc.p(0,0),
		titleUrl = "Resources/common/title/yingyongjingsu.png",

		["onClose"] = function()
			self:dismiss()
		end
	})
	self:addChild(style, -1)

	local view = qy.tank.view.operatingActivities.heroicRacing.HeroicRacingDialog2.new(self)

	local winSize = cc.Director:getInstance():getWinSize()
    local fix = (winSize.width - 1080) / 2
	view:setPosition(-260 - fix, -10)
	style.bg:addChild(view)
end

function HeroicRacingDialog:onExit()
    qy.RedDotCommand:emitSignal(qy.RedDotType.HER_RAC, self.model:isHeroicRacingHasAward())
end

return HeroicRacingDialog
