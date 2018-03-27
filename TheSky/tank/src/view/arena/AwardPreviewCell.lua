--[[
	奖励预览cell
	Author: Aaron Wei
	Date: 2015-11-10 20:01:39
]]

local AwardPreviewCell = qy.class("AwardPreviewCell", qy.tank.view.BaseView,"view/arena/AwardPreviewCell")

function AwardPreviewCell:ctor()
	AwardPreviewCell.super.ctor(self)
	
    self:InjectView("rank")
    for i=1,3 do
	    self:InjectView("num"..i)
	    self:InjectView("icon"..i)
    end
end

function AwardPreviewCell:render(data)
	if data then
		self.rank:setString(tostring(data.range))
		for i=1,3 do
			local award = data.award[i]
			if award then
				self["num"..i]:setString(tostring(award.num))
				local icon = qy.tank.utils.AwardUtils.getAwardIconByType(award.type,award.id) 
				self["icon"..i]:setTexture(tostring(icon))
				self["num"..i]:setVisible(true)
				self["icon"..i]:setVisible(true)
			else
				self["num"..i]:setVisible(false)
				self["icon"..i]:setVisible(false)
			end
		end
	end
end

return AwardPreviewCell