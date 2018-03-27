--[[
	仓库
	Author: lijian
]]

local PropCellList = qy.class("PropCellList", qy.tank.view.BaseView)

local model = qy.tank.model.FittingsModel

function PropCellList:ctor(delegate)
    PropCellList.super.ctor(self)
    self.cellArr = {}
    for i = 1, 5 do
    	self.cellArr[i] =  require("accessories.src.PartItem").new(delegate)
    	self.cellArr[i]:setPosition(70+140*(i-1),60)
    	self:addChild(self.cellArr[i])
    end
    self.data = delegate.data
end

function PropCellList:render(index,selectid)
	local maxNum = #self.data
	local listIdx = 0
	for i = 1, 5 do
		listIdx = index*5 + i
		if listIdx > maxNum then
			self.cellArr[i]:setVisible(false)
		else
			self.cellArr[i]:setVisible(true)
			self.cellArr[i]:update(listIdx,selectid,self.data)
		end
	end
end

return PropCellList                   

