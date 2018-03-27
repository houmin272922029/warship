--[[
    toast2 用于飘icon + 文字
    Author: H.X.Sun
    Date: 2015-04-18
]]

local Toast2 = qy.class("Toast2", qy.tank.view.BaseView, "view/common/Toast2")

--params.critNum: 暴击倍数，现在有2、4、6、8倍，默认没有
--params.award: 奖励 award内含type、num、id
function Toast2:ctor(params)
    Toast2.super.ctor(self)

	self:InjectView("crit")
	self:InjectView("icon")
	self:InjectView("num")
	self:InjectView("tipLabel")
	-- print("toast2 ==" .. qy.json.encode(params))
	if params.critMultiple and params.critMultiple > 1 then
		self.crit:setSpriteFrame("Resources/toast/bj_ty_" .. params.critMultiple .. ".png")
		self.crit:setVisible(true)
	else
		self.crit:setVisible(false)
	end

	local award
	if #params.award > 0 then
		award = params.award[1]
	else
		award = params.award
	end
	if qy.tank.view.type.AwardType.DIAMOND == award.type then
		--钻石
		self.icon:setTexture(qy.tank.utils.AwardUtils.getSmallDiamond())
		self.icon:setScale(1.3)
	else
		--其他
		self.icon:setTexture(params.award.icon)
		self.icon:setScale(0.7)
	end
	self.num:setString("x " .. award.num)

	if params.tipTxt then
		self.tipLabel:setString(params.tipTxt)
		local x = (self.tipLabel:getContentSize().width - 100 - self.num:getContentSize().width) / 2
		self.tipLabel:setPosition(x, 5)
		self.num:setPosition(x + 100, 5)
		self.icon:setPosition(x + 50, 5)
	end
end

return Toast2
