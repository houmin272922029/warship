--[[
	战力竞赛cell
	Author: 
	Date: 2016年07月20日15:41:12
]]

local MatchFightPowerCell = qy.class("MatchFightPowerCell", qy.tank.view.BaseView, "match_fight_power/ui/MatchFightPowerCell")

function MatchFightPowerCell:ctor(delegate)
    MatchFightPowerCell.super.ctor(self)

    self:InjectView("bg")
	self:InjectView("s1")
	self:InjectView("s2")
	self:InjectView("s3")
	self:InjectView("Power")
	self:InjectView("Power_txt")
	self:InjectView("Name")
	self:InjectView("Level")
	self:InjectView("Power_txt2")
	self:InjectView("Rank")
end

function MatchFightPowerCell:render(entity, _type, _idx)
	
	self.s1:setVisible(false)
	self.s2:setVisible(false)
	self.s3:setVisible(false)
	self.Power:setVisible(false)
	self.Power_txt:setVisible(false)
	self.Power_txt2:setVisible(false)
	self.Name:setVisible(false)
	self.Level:setVisible(false)
	self.Rank:setVisible(false)

	if self.awardList then
		self.awardList:removeFromParent()
	end

	self.entity = entity
	if entity or _type == 3 then
		if _type == 1 then
			if _idx == 1 then
				self.s1:setVisible(true)
			elseif _idx == 2 then 
				self.s2:setVisible(true)
			elseif _idx == 3 then 
				self.s3:setVisible(true)
			else
				self.Rank:setVisible(true)
				self.Rank:setString(qy.TextUtil:substitute(67011).._idx.. qy.TextUtil:substitute(50012))
			end

			self.awardList = qy.AwardList.new({
		        ["award"] = self.entity.award,
		        ["cellSize"] = cc.size(130,180),
		        ["type"] = 1,
		        ["itemSize"] = 2,
		        ["hasName"] = false,
		    })
		    self.awardList:setPosition(280,250)
		    self.bg:addChild(self.awardList)

		elseif _type == 2 then
			self.Power:setVisible(true)
			self.Power_txt:setVisible(true)

			self.awardList = qy.AwardList.new({
		        ["award"] = self.entity.award,
		        ["cellSize"] = cc.size(130,180),
		        ["type"] = 1,
		        ["itemSize"] = 2,
		        ["hasName"] = false,
		    })
		    self.awardList:setPosition(280,250)
		    self.bg:addChild(self.awardList)

		    self.Power_txt:setString(self.entity.fightpower)
		elseif _type == 3 then
			if _idx == 1 then
				self.s1:setVisible(true)
			elseif _idx == 2 then 
				self.s2:setVisible(true)
			elseif _idx == 3 then 
				self.s3:setVisible(true)
			else
				self.Rank:setVisible(true)
				self.Rank:setString(qy.TextUtil:substitute(67011).._idx.. qy.TextUtil:substitute(50012))
			end

			self.Name:setVisible(true)
			if self.entity then 
				--{"list":[{"ranking":1,"FightPower":2,"name":"昵称"}],"ranking":0}
				
				self.Level:setString(self.entity.level or 0)
				self.Name:setString(self.entity.name)
				self.Power_txt2:setString(self.entity.FightPower)

				self.Level:setVisible(true)
				self.Power_txt2:setVisible(true)
			else 
				self.Name:setString(qy.TextUtil:substitute(49001))
			end

			
		end 
	end
end

return MatchFightPowerCell                   
