--
-- Author: Your Name
-- Date: 2016-09-26 11:44:32
--


local AwardPreviewCell = qy.class("AwardPreviewCell", qy.tank.view.BaseView, "olympic.ui.AwardPreviewCell")

function AwardPreviewCell:ctor(params)
	self:InjectView("bg")
	self:InjectView("rank")
end

function AwardPreviewCell:render(data)
	if data then
		if data.max_rank == data.min_rank then
			self.rank:setString("第"..data.max_rank.."名奖励")
		elseif data.min_rank == -1 then
			self.rank:setString("第"..data.max_rank.."名奖励")
		else
			self.rank:setString("第"..data.max_rank.."~"..data.min_rank.."名奖励")
		end

		if not self.awardList then
			self.awardList = qy.AwardList.new({
		            ["award"] =  data.award,
		            ["hasName"] = true,
		            ["type"] = 1,
		            ["cellSize"] = cc.size(200,100),
		            ["itemSize"] = 1,
		    })
		    self.awardList:setPosition(110,190)
		    self:addChild(self.awardList)
		else
			self.awardList:update(data.award)
		end
	end
end

return AwardPreviewCell