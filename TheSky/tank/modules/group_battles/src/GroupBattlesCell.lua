local GroupBattlesCell = qy.class("GroupBattlesCell", qy.tank.view.BaseView)

local model = qy.tank.model.GroupBattlesModel
function GroupBattlesCell:ctor(delegate)
   	GroupBattlesCell.super.ctor(self)
    self.delegate = delegate
end

function GroupBattlesCell:render(_data, _idx)
	
	if self.Node then
		self:removeChild(self.Node)
	end

	self.Node = cc.Node:create()
	self.Node:setLocalZOrder(0)
	self:addChild(self.Node)

	for i = 1, 2 do
        local data = _data[i]

        if data ~= nil then
            local item = require("group_battles.src.GroupBattlesCell2").new(self.delegate)
            local x, y = item:getPosition()
            item:setPosition(x + (i - 1) * 250, y)

            item:render(data, (_idx - 1) * 2 + i)

            self.Node:addChild(item)
        end
    end
end

return GroupBattlesCell