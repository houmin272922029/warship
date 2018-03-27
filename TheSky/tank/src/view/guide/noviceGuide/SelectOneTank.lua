--[[--
--选择一辆坦克(改：获得一辆坦克)
--Author: H.X.Sun
--Date: 2015-06-27
--]]--

local SelectOneTank = qy.class("SelectOneTank", qy.tank.view.BaseView, "view/guide/noviceGuide/SelectOneTank")

function SelectOneTank:ctor(delegate)
    SelectOneTank.super.ctor(self)
	self:InjectView("left")
	self:InjectView("right")
	self:InjectView("tank")
	self.left:setPosition(-300,0)
	self.right:setPosition(qy.winSize.width+300,0)
	self.tank:setScale(0.5)

	local scaleBig = cc.ScaleTo:create(0.2, 1.2)
	local scaleSmall = cc.ScaleTo:create(0.05, 1)
	local callBack = cc.CallFunc:create(function ()
        qy.QYPlaySound.playEffect(qy.SoundType.GET_AWARD)
		self.left:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(0,0))))
		self.right:runAction(cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(qy.winSize.width,0))))
	end)

	self.tank:runAction(cc.Sequence:create(scaleBig,scaleSmall, callBack))

	self:OnClick("confirmBtn", function(sender)
		--qy.tank.service.GuideService:chooseTank(function ()end)
		qy.GuideManager:next(123445678)
	end)
end



return SelectOneTank
