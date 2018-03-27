--[[
    声望 + 文字
]]

local Toast5 = qy.class("Toast5", qy.tank.view.BaseView, "view/common/Toast5")

function Toast5:ctor(params)
    Toast5.super.ctor(self)
	self:InjectView("s_num")
	self:InjectView("icon")
	self:InjectView("num")
	
	
	if params.award then
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
	else 
		self:InjectView("text")
		self:InjectView("text_1")

		self.text:setPosition(self.text:getPosition().x + 70, self.text:getPosition().y)
		self.text_1:setPosition(self.text_1:getPosition().x + 70, self.text_1:getPosition().y)
	end

	

	self.s_num:setString("x " .. params.s_num)
end

return Toast5
