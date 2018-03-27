--[[
--成就属性列表
--Author: mingming
--Date:
]]

local AttributeItem = qy.class("AttributeItem", qy.tank.view.BaseView, "view/achievement/AttributeItem")

local model = qy.tank.model.AchievementModel
function AttributeItem:ctor(delegate)
	AttributeItem.super.ctor(self)
	self:InjectView("Price_Num")
	self:InjectView("Price")
	self:InjectView("Info1")
	self:InjectView("Text_1_0")
	-- local info = qy.tank.view.achievement.InfoView.new()
	-- local winSize = cc.Director:getInstance():getWinSize()
	-- info:setPosition(120, -450)
	-- self:addChild(info)
 --    self:addChild(self:createTableView())
end

function AttributeItem:setData(data)
	self.Price:setTexture(qy.tank.utils.AwardUtils.getAwardIconByType(data.up_type))

	self.Price_Num:setVisible(data.preup_val > 0)
	self.Price:setVisible(data.preup_val > 0)
	-- if data.up_val > 0 then
	self.Price_Num:setString(data.preup_val)
	self.Text_1_0:setString(data.preup_val > 0 and qy.TextUtil:substitute(1008) or qy.TextUtil:substitute(1009))
	-- end
	
	local color = qy.tank.utils.ColorMapUtil.qualityMapColor(data.star)
	self.Info1:setTextColor(color)

	local content = model.attrLevels[tostring(data.star)] .. "：" .. data.shuxing1_type .. "+" .. data.shuxing1_val .. qy.TextUtil:substitute(1005) .. data.shuxing2_val .. qy.TextUtil:substitute(1006) .. data.shuxing3_val

	local val1 = data.shuxing1_val
	if data.shuxing1_type == 6 or data.shuxing1_type == 7 or data.shuxing1_type == 9 or data.shuxing1_type == 10 or data.shuxing1_type == 14 then
		val1 = data.shuxing1_val / 10 .. "%"
	end

	local val2 = data.shuxing2_val
	if data.shuxing2_type == 6 or data.shuxing2_type == 7 or data.shuxing2_type == 9 or data.shuxing2_type == 10 or data.shuxing2_type == 14 then
		val2 = data.shuxing2_val / 10 .. "%"
	end

	local val3 = data.shuxing3_val
	if data.shuxing3_type == 6 or data.shuxing3_type == 7 or data.shuxing3_type == 9 or data.shuxing3_type == 10 or data.shuxing3_type == 14 then
		val3 = data.shuxing3_val / 10 .. "%"
	end

	if data.shuxing1_type == 0 then
		content = model.attrLevels[tostring(data.star)] .. "："
	elseif data.shuxing2_type == 0 then
		content = model.attrLevels[tostring(data.star)] .. "：" .. model.attrTypes[tostring(data.shuxing1_type)] .. "+" .. val1
	elseif data.shuxing3_type == 0 then
		content = model.attrLevels[tostring(data.star)] .. "：" .. model.attrTypes[tostring(data.shuxing1_type)] .. "+" .. val1 .. " ".. model.attrTypes[tostring(data.shuxing2_type)] .. "+" .. val2
	else
		content = model.attrLevels[tostring(data.star)] .. "：" .. model.attrTypes[tostring(data.shuxing1_type)] .. "+" .. val1 .. " ".. model.attrTypes[tostring(data.shuxing2_type)] .. "+" .. val2 .. " " .. model.attrTypes[tostring(data.shuxing3_type)] .. "+" .. val3
	end
	self.Info1:setString(content)
end

return AttributeItem