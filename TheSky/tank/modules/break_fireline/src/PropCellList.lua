local PropCellList = qy.class("PropCellList", qy.tank.view.BaseView)

local model = qy.tank.model.SignModel
function PropCellList:ctor(delegate)
   	PropCellList.super.ctor(self)
    self.delegate = delegate
end

function PropCellList:render(_data, _idx)
	
	if self.Node then
		self:removeChild(self.Node)
	end

	self.Node = cc.Node:create()
	self.Node:setLocalZOrder(0)
	self:addChild(self.Node)


	for i = 1, 5 do
        local data = _data[i]
        if data ~= nil then
            local item =  require("break_fireline.src.ChooseCell").new(self.delegate)
            local x, y = item:getPosition()
            item:setPosition(x + (i - 1) * 100, y-25) 
            item:render(data, (_idx - 1) * 5 + i)
            self.Node:addChild(item)
        end
    end
end

return PropCellList