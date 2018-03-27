--[[
	橙色进度条
	Author: Aaron Wei
	Date: 2015-02-10 11:20:27
]]

local OrangeBar1 = qy.class("OrangeBar1", qy.tank.widget.progress.ScaleBar)

function OrangeBar1:ctor()
    OrangeBar1.super.ctor(self)
end

function OrangeBar1:create(d)
	if not tolua.cast(self.frame,"cc.Node") then
	    self.frame = ccui.Scale9Sprite:create("Resources/common/img/bar_3.png")
        self:addChild(self.frame)
	end

	if not tolua.cast(self.bar,"cc.Node") then
	    self.bar = ccui.Scale9Sprite:create("Resources/common/img/bar_2.png")
        self:addChild(self.bar)
	end
    self:setDirection(d)
    self:setBarSize(100,5)
    self:setBarPosition(1,1)
    self:setBgPosition(0,0)
end

function OrangeBar1:setBarSize(w, h)
    self.bar:setPreferredSize(cc.size(w,h))
end

return OrangeBar1
