--[[
	装备控制器
	Author: H.X.Sun
]]

local EquipController = qy.class("EquipController", qy.tank.controller.BaseController)

function EquipController:ctor(delegate)
    EquipController.super.ctor(self)

	print("EquipController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    -- self.model = qy.tank.model.ArenaModel

    self.view = qy.tank.view.equip.EquipView.new({
    	["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["type"] = delegate and delegate.type or "total",
        ["selectTankUid"] = delegate and delegate.selectTankUid,

        ["showSelectEquipForAdvance"] = function(equip_entity, callback, unique_id)
            local view = qy.tank.view.equip.EquipView.new({
                ["dismiss"] = function()
                    self.viewStack:pop()
                end,
                ["equipEntity"] = equip_entity,
                ["callback"] = callback,
                ["unique_id"] = unique_id,
                ["type"] = equip_entity:getType() or "total",
            })
            self.viewStack:push(view)
        end,

        ["showEquipAdvanceView"] = function(parent, cell, type, unique_id)
            local view = qy.tank.view.equip.EquipAdvanceView.new({
                ["dismiss"] = function()
                    self.viewStack:pop()
                end,
                ["parent"] = parent,
                ["cell"] = cell,
                ["type"] = type,
                ["unique_id"] = unique_id,
            })
            self.viewStack:push(view)
        end,
        ["showEquipClearView"] = function(parent, cell, type, unique_id)
            local view = qy.tank.view.equip.EquipClearView.new({
                ["dismiss"] = function()
                    self.viewStack:pop()
                end,
                ["parent"] = parent,
                ["cell"] = cell,
                ["type"] = type,
                ["unique_id"] = unique_id,
            })
            self.viewStack:push(view)
        end,
    })
    self.viewStack:push(self.view)
end


return EquipController
