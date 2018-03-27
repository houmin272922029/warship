--[[
	选择配件界面
	Author: lijian
]]

local PropCellList2 = qy.class("PropCellList2", qy.tank.view.BaseView)

local model = qy.tank.model.FittingsModel

function PropCellList2:ctor(delegate)
    PropCellList2.super.ctor(self)
    self.cellArr1 = {}
    self.data = delegate.data
    for i = 1, 3 do
    	self.cellArr1[i] =  require("accessories.src.PartItem").new(delegate)
    	self.cellArr1[i]:setPosition(120*(i-1) + 65 ,60)
    	self:addChild(self.cellArr1[i])
    end
end

function PropCellList2:render(index,selectid)
	local maxNum = #self.data
	local listIdx = 0
	for i = 1, 3 do
		listIdx = index*3 + i
		if listIdx > maxNum then
			self.cellArr1[i]:setVisible(false)
		else
			self.cellArr1[i]:setVisible(true)
			self.cellArr1[i]:update(listIdx,selectid)
		end
	end
end

return PropCellList2                   

