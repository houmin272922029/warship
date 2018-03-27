local WarPictureSelectCell = qy.class("WarPictureSelectCell", qy.tank.view.BaseView, "war_picture.ui.WarPictureSelectCell")

function WarPictureSelectCell:ctor(delegate)
   	WarPictureSelectCell.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Num")
    self:InjectView("Prestige_Num")
    
end

function WarPictureSelectCell:render(data, _idx)

	self.bg:loadTexture("war_picture/res/".._idx.."/".."bg.jpg",0)
	self.Num:setString(_idx)
	for i, v in pairs(data.award) do
		if v.type == 28 then
			self.Prestige_Num:setString(v.num)
		end
	end
end

return WarPictureSelectCell