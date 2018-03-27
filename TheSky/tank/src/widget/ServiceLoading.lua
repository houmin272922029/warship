--[[
    说明: 网络交换的菊花
]]

local ServiceLoading = qy.class("ServiceLoading", qy.tank.view.BaseView, "widget/ServiceLoading")

function ServiceLoading:ctor()
    ServiceLoading.super.ctor(self)

    self:InjectView("Loading")
    self:InjectView("container")
    self:InjectView("Bg")
    self:InjectView("txt")
    self.container:setVisible(false)
    self.times = 0
    -- self.Loading:setPositionX(qy.winSize.width/2)
    self.Bg:setPositionX(qy.winSize.width/2)
    local func1 = cc.RotateBy:create(1, 360)
    local fun2 = cc.CallFunc:create(function ( )
    	self.times = (self.times + 1) % 4
 	local str = ""
    	for i = 1, self.times do
    		str = str .. "."
    	end  
    	self.txt:setString(str)
    end)
    local delay = cc.DelayTime:create(0.3)
    local seq = cc.Sequence:create(fun2,delay)
    self.Loading:runAction(cc.RepeatForever:create(func1))
    self.txt:runAction(cc.RepeatForever:create(seq))
    self.container:runAction(cc.Sequence:create(cc.DelayTime:create(0.4),cc.CallFunc:create(function ()
        self.container:setVisible(true)
    end)))
end

return ServiceLoading