local ChoiceAwardCell = qy.class("ChoiceAwardCell", qy.tank.view.BaseView)

local model = qy.tank.model.SignModel
function ChoiceAwardCell:ctor(delegate)
   	ChoiceAwardCell.super.ctor(self)
    self.delegate = delegate
end

function ChoiceAwardCell:render(_data, _idx)
	
	if self.Node then
		self:removeChild(self.Node)
	end

	self.Node = cc.Node:create()
	self.Node:setLocalZOrder(0)
	self:addChild(self.Node)


	for i = 1, 4 do
        local data = _data[i]
        if data ~= nil then
            local item = qy.tank.view.storage.ChoiceAwardCell2.new(self.delegate)
            local x, y = item:getPosition()
            item:setPosition(x + (i - 1) * 140, y) 
            item:render(data, (_idx - 1) * 4 + i)
            self.Node:addChild(item)
        end
    end
end

return ChoiceAwardCell