--[[
	分解
	Author: lijian
]]

local PropCellList1 = qy.class("PropCellList1", qy.tank.view.BaseView)

local model = qy.tank.model.FittingsModel

function PropCellList1:ctor(delegate)
    PropCellList1.super.ctor(self)
    self.cellArr1 = {}
    for i = 1, 5 do
    	self.cellArr1[i] =  require("accessories.src.PartItem2").new(delegate)
    	self.cellArr1[i]:setPosition(200*(i-1) ,0)
    	self:addChild(self.cellArr1[i])
    end
    self.data = delegate.data
end

function PropCellList1:render(index)
	local maxNum = #self.data
	local listIdx = 0
	for i = 1, 5 do
		listIdx = index*5 + i
		if listIdx > maxNum then
			self.cellArr1[i]:setVisible(false)
		else
			self.cellArr1[i]:setVisible(true)
			self.cellArr1[i]:update(listIdx)
		end
	end
end

return PropCellList1                   

