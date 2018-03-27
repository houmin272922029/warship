--[[--
	商店图标
--]]--

local IconView = qy.class("IconView", qy.tank.view.BaseView, "servicewar.ui.IconView")

function IconView:ctor(params)
	self:InjectView("Light")
	self.Item = qy.tank.view.common.ItemIcon.new()
	self:addChild(self.Item)
end

function IconView:setData(data, light)
	self.Item:setData(data)
	self.Light:setVisible(light)
end

function IconView:setLight(flag)
	self.Light:setVisible(flag)
end

return IconView