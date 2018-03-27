local SignCell = qy.class("SignCell", qy.tank.view.BaseView)

local model = qy.tank.model.SignModel
function SignCell:ctor(delegate)
   	SignCell.super.ctor(self)
    self.delegate = delegate
end

function SignCell:render(_data, _idx)
	
	if self.Node then
		self:removeChild(self.Node)
	end

	self.Node = cc.Node:create()
	self.Node:setLocalZOrder(0)
	self:addChild(self.Node)

	for i = 1, 5 do
        local data = _data[i]

        if data ~= nil then
            local item = require("sign.src.SignCell2").new(self.delegate)
            local x, y = item:getPosition()
            item:setPosition(x + (i - 1) * 159, y)

            item:render(data, (_idx - 1) * 5 + i)

            self.Node:addChild(item)
        end
    end
end

return SignCell