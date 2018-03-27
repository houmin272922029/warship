local PlayerCell = qy.class("PlayerCell", qy.tank.view.BaseView, "server_exercise/ui/PlayerCell")


function PlayerCell:ctor(delegate)
	PlayerCell.super.ctor(self)

	self:InjectView("bg")
	self:InjectView("level")--等级
    self:InjectView("Fightingnum")--战斗力
    self:InjectView("winning")--胜率
    self:InjectView("integral")--积分
    self:InjectView("diamondnum")--钻石
    self:InjectView("Headicon")--头像
    self:InjectView("playername")--昵称

    self.data = delegate.data
    self.type = delegate.type
    self:update()
   
end
function PlayerCell:update(  )
	if self.type == 1 then
		self.bg:loadTexture("server_exercise/res/3.png")
	else
		self.bg:loadTexture("server_exercise/res/5.png")
	end
	local icon = qy.TextUtil:StringSplit(self.data.head,"head_",false,false)

	local server = qy.TextUtil:StringSplit(self.data.server,"s",false,false)
	local png = "server_exercise/res/user"..icon[1]..".png"
	self.Headicon:loadTexture(png,1)
	self.playername:setString(self.data.nickname.."("..server[1].."服)")
	self.integral:setString(self.data.integral)
	self.diamondnum:setString(self.data.remain_diamond)
	self.winning:setString(self.data.win_proba.."%")
	self.Fightingnum:setString("战斗力: "..self.data.strength)
	self.level:setString("LV."..self.data.level)

end

return PlayerCell
