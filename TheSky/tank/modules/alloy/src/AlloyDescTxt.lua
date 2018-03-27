--[[--
	属性
	Author: H.X.Sun
--]]--

local AlloyDescTxt = qy.class("AlloyDescTxt", qy.tank.view.BaseView, "alloy/ui/AlloyDescTxt")

function AlloyDescTxt:ctor(data)
	AlloyDescTxt.super.ctor(self)

	self:InjectView("level")
	self:InjectView("num")
	self.level:setString(qy.TextUtil:substitute(41016, data.level))
	self.num:setString(" "..data.name .. "+" .. data.plus)
	local color = qy.tank.model.AlloyModel:getColorByLevel(tonumber(data.level))
	self.level:setTextColor(color)
	self.num:setTextColor(color)
end

return AlloyDescTxt