local RankCell = qy.class("RankCell", qy.tank.view.BaseView, "activity_2048/ui/RankCell")

function RankCell:ctor(delegate)
   	RankCell.super.ctor(self)

   	self:InjectView("bg")
    self:InjectView("Text_rank")
    self:InjectView("Name")
    self:InjectView("Image_rank")
    self:InjectView("Rank_score")
end

function RankCell:render(data, _idx)

	-- if data then
	-- 	self.Text_rank:setString(data.rank)
	-- 	self.Name:setString(data.nickname)
	-- 	self.Score:setString(data.point)
	-- else 
	-- 	self.Rank:setString(_idx)
	-- 	self.Name:setString(qy.TextUtil:substitute(45008))
	-- 	self.Score:setString("0")
	-- end

	
	-- self.Reward_icon:setTexture(qy.tank.utils.AwardUtils.getAwardIconByType(reward.award[1].type))
	-- self.Reward_num:setString("x"..tostring(reward.award[1].num))
	if data.rank < 4 then
		self.Text_rank:setVisible(false)
		self.Image_rank:setVisible(true)
		self.Image_rank:loadTexture("activity_2048/res/"..data.rank..".png",0)
	else
		self.Text_rank:setVisible(true)
		self.Image_rank:setVisible(false)
		self.Text_rank:setString(data.rank)
	end

	self.Name:setString(data.nickname)
	self.Rank_score:setString(data.source)

end

return RankCell