
local TitleCells = qy.class("TitleCells", qy.tank.view.BaseView, "Military_rank/ui/TitleCell")


function TitleCells:ctor(delegate)
    TitleCells.super.ctor(self)
    self:InjectView("titleimage")
    self.h = 60
   
end

function TitleCells:render(_idx)
   	self:update(_idx)
end

function TitleCells:update(_idx)
	local png 
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Military_rank/res/Military_rank.plist")
	if _idx == 1 then
		png = "Military_rank/res/27.png"
    else
    	png = "Military_rank/res/28.png"
    end
     self.titleimage:loadTexture(png,1)

end


return TitleCells
