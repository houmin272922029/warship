--[[
	红色进度条
	Author: Aaron Wei
	Date: 2015-02-07 18:11:10
]]

local RedBar1 = qy.class("RedBar1", qy.tank.widget.progress.ScaleBar)

function RedBar1:ctor()
    RedBar1.super.ctor(self)
end

function RedBar1:create(d)
	if not tolua.cast(self.frame,"cc.Node") then
	    self.frame = ccui.Scale9Sprite:create("Resources/common/img/bar_3.png")
        self:addChild(self.frame)
	end

	if not tolua.cast(self.bar,"cc.Node") then
	    self.bar = ccui.Scale9Sprite:create("Resources/common/img/bar_1.png")
        self:addChild(self.bar)
	end
    self:setDirection(d)
    self:setBarSize(100,5)
    self:setBarPosition(1,1)
    self:setBgPosition(0,0)
end

function RedBar1:setBarSize(w, h)
    self.bar:setPreferredSize(cc.size(w,h))
end

return RedBar1
