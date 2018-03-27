--[[
	
]]

local ItemView = qy.class("ItemView", qy.tank.view.BaseDialog, "legion_recharge.ui.ItemView")

function ItemView:ctor()
	self:InjectView("Id")
    self:InjectView("Name")
    self:InjectView("Num")
    self:InjectView("Money")
    
end

function ItemView:render(data,idx)--idx 从 1 开始
	self.Id:setString(data.legion_id)
	self.Name:setString(data.legion_name)
	self.Num:setString(data.people)
	self.Money:setString(data.recharge)
end

return ItemView

