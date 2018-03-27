local BeatEnemyRankCell = qy.class("BeatEnemyRankCell", qy.tank.view.BaseView, "beat_enemy.ui.BeatEnemyRankCell")

function BeatEnemyRankCell:ctor(delegate)
   	BeatEnemyRankCell.super.ctor(self)

   	self:InjectView("bg")
    self:InjectView("Rank")
    self:InjectView("Name")
    self:InjectView("Score")
    self:InjectView("Reward_icon")
    self:InjectView("Reward_num")
end

function BeatEnemyRankCell:render(data, reward, _idx)

	if data then
		self.Rank:setString(data.rank)
		self.Name:setString(data.nickname)
		self.Score:setString(data.point)
	else 
		self.Rank:setString(_idx)
		self.Name:setString(qy.TextUtil:substitute(45008))
		self.Score:setString("0")
	end

	
	self.Reward_icon:setTexture(qy.tank.utils.AwardUtils.getAwardIconByType(reward.award[1].type))
	self.Reward_num:setString("x"..tostring(reward.award[1].num))

end

return BeatEnemyRankCell