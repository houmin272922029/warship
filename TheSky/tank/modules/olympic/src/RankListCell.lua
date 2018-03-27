--
-- Author: Your Name
-- Date: 2016-09-26 11:03:10
--

local RankListCell = qy.class("RankListCell", qy.tank.view.BaseView, "olympic.ui.RankListCell")

function RankListCell:ctor(params)
	self:InjectView("rank")
	self:InjectView("role")
	self:InjectView("score")
end

function RankListCell:render(data)
	if data then
		 self.rank:setString(data.rank)
		 self.role:setString(data.server.."-"..data.nickname)
		 self.score:setString(data.source)
	end
end

return RankListCell