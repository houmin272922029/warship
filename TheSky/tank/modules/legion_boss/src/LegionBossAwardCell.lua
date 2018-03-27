--[[
	世界Boss奖励预览cell
	Author: Aaron Wei
	Date: 2015-12-10 14:43:59
]]

local LegionBossAwardCell = qy.class("LegionBossAwardCell", qy.tank.view.BaseView, "legion_boss.ui.LegionBossAwardCell")

function LegionBossAwardCell:ctor(params)
	self.model = qy.tank.model.LegionBossModel
	self:InjectView("rank")
	for i=1,2 do
		self:InjectView("num"..i)
		self:InjectView("icon"..i)
		self:InjectView("name"..i)
	end
end

function LegionBossAwardCell:render(data,_type)
	if data then
		self.rank:setString(qy.TextUtil:substitute(4003, data.rank))
		for i=1,2 do
			local award
			if _type == 1 then
				award = data["die_award"..self.model.boss_id][i]
			else
				award = data["award"..self.model.boss_id][i]
			end
			if award then
				if award.type == 13 then
					-- local name = qy.tank.utils.AwardUtils.getAwardNameByType(award.type,award.id)
					local data = qy.tank.view.common.AwardItem.getItemData(award)
					self["name"..i]:setString(data.name)
					self["name"..i]:setTextColor(data.nameTextColor)
					self["num"..i]:setString(tostring(award.num).."x")
					self["icon"..i]:setVisible(false)
					self["name"..i]:setVisible(true)
				else
					self["num"..i]:setString(tostring(award.num).."x")
					local icon = qy.tank.utils.AwardUtils.getAwardIconByType(award.type,award.id)
					self["icon"..i]:setTexture(tostring(icon))
					self["icon"..i]:setVisible(true)
					self["name"..i]:setVisible(false)
				end
				self["num"..i]:setVisible(true)
			else
				self["num"..i]:setVisible(false)
				self["icon"..i]:setVisible(false)
				self["name"..i]:setVisible(false)
			end
		end
	end
end

return LegionBossAwardCell
