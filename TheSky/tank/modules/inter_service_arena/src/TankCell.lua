 local TankCell = qy.class("TankCell", qy.tank.view.BaseView)

local model = qy.tank.model.SignModel
function TankCell:ctor(delegate)
   	TankCell.super.ctor(self)
    self.delegate = delegate
end

function TankCell:render(_data, _idx, _type)
	
	if self.Node then
		self:removeChild(self.Node)
	end

	self.Node = cc.Node:create()
	self.Node:setLocalZOrder(0)
	self:addChild(self.Node)

    local list = {}

    if _type == "left" then
        list = {4, 1, 5, 2, 6, 3}
    else
        list = {1, 4, 2, 5, 3, 6}
    end

    _idx = (_idx - 1) * 2 + 1

	for i = _idx, _idx + 1 do
        local data = _data[list[i]]
        if not data then
            data = _data[tostring(list[i])]
        end 

        if data ~= nil and (type(data) == "table" or type(data) == "userdata") then
            local item = require("inter_service_arena.src.TankCell2").new()
            item:setPosition((i - _idx) * 200, 0)

            item:render(data)

            self.Node:addChild(item)
        end
    end
end

return TankCell