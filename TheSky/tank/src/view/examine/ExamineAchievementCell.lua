--[[
	查看成就cell
	Author: Aaron Wei
	Date: 2015-09-10 21:20:36
]]

local ExamineAchievementCell = qy.class("ExamineAchievementCell", qy.tank.view.BaseView, "view/examine/ExamineAchievementCell")

function ExamineAchievementCell:ctor(delegate)
    ExamineAchievementCell.super.ctor(self)

	self:InjectView("name")
	for i=1,3 do
		self:InjectView("att"..i)
		self:InjectView("value"..i)
	end
end

function ExamineAchievementCell:render(data)
	local color = qy.tank.utils.ColorMapUtil.qualityMapColor(data.level)
	
	self.name:setString(data.name)
	self.name:setTextColor(color)

	for i=1,3 do
		local name = self["att"..i]
		local value = self["value"..i]
		if data.attr[i].name then
			name:setString(data.attr[i].name) 
			value:setString(tostring(data.attr[i].value))
			value:setTextColor(color)
			value:setPositionX(name:getPositionX()+name:getContentSize().width+10)
		else
			name:setString("") 
			value:setString("")
		end
	end
end

return ExamineAchievementCell                   
