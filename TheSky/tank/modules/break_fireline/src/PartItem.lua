--[[
	配件系统
	Author: 
]]

local PartItem = qy.class("PartItem", qy.tank.view.BaseView)

function PartItem:ctor(delegate)
    PartItem.super.ctor(self)
    self.data = delegate.data
end

function PartItem:update( index ,selectid ,datas)
    print("=========dsdsddd",index)
	local data = self.data
	self.index = index
	local item = qy.tank.view.common.AwardItem1.createAwardView(self.data[tostring(self.index)].award[1] ,1)
    item.name:setVisible(false)
    self:addChild(item)
  
  
end


return PartItem
