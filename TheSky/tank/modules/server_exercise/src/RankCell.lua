local RankCell = qy.class("RankCell", qy.tank.view.BaseView, "server_exercise/ui/RankCell")


local model = qy.tank.model.ServerExerciseModel

function RankCell:ctor(delegate)
	RankCell.super.ctor(self)
	self:InjectView("rank")--名次
	self:InjectView("rankinfo")--姓名
	self:InjectView("ranklevel")--积分
	self:InjectView("rankimage")
	self.date =  model.ranklist.list
   
end
function RankCell:render( _idx )
	if _idx < 4 then
		local png = "server_exercise/res/rank".._idx..".png"
		self.rank:setVisible(false)
		self.rankimage:setVisible(true)
		self.rankimage:loadTexture(png,1)
	else
		self.rank:setVisible(true)
		self.rankimage:setVisible(false)
		self.rank:setString(_idx)
	end	
	self.ranklevel:setString(self.date[_idx].source)
	local extratable = qy.TextUtil:StringSplit(self.date[_idx].server,"s",false,false)
	self.rankinfo:setString(self.date[_idx].nickname.."("..extratable[1].."服)")
end

return RankCell
