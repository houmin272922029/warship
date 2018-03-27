--[[
--装备tip
--Author: H.X.Sun
--Date: 2015-07-18
]]

local EquipTip = qy.class("EquipTip", qy.tank.view.BaseView)

function EquipTip:ctor(entity, _awardType)
    EquipTip.super.ctor(self)
    self.equipType = qy.tank.view.type.AwardType.EQUIP

	local style = qy.tank.view.style.DialogStyle5.new({
		size = cc.size(500,530),
        position = cc.p(0,0),
        offset = cc.p(0,0),

		-- ["onClose"] = function()
        --     self:getParent():removeChild(self)
        -- end
	})
	self:addChild(style)

	self.model = qy.tank.model.EquipModel

    if not tolua.cast(self.list,"cc.Node") then
        self.list =  qy.tank.view.equip.EquipInfoList.new({
            ["entity"] = entity,
            ["size"] = cc.size(500,520)
        })
        self:addChild(self.list)
        self.list:setPosition(qy.winSize.width/2 - 242 ,620)
    else
        self.list:update(entity)
    end
end

return EquipTip
