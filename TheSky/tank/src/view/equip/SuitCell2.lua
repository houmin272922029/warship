--[[--
    装备套装2
    Author: H.X.Sun
--]]--
local SuitCell2 = qy.class("SuitCell2", qy.tank.view.BaseView, "view/equip/SuitCell2")
local NodeUtil = qy.tank.utils.NodeUtil

function SuitCell2:ctor(delegate)
    SuitCell2.super.ctor(self)
    self.model = qy.tank.model.EquipModel

    self:InjectView("reward_3_6")
    self:InjectView("reward_3_7")

    self:update(delegate.entity)
end

--[[--
--套装信息
--]]
function SuitCell2:update(entity)
    --变灰或变亮套装图标
    local suitId = entity:getSuitID()
    local suitReward = self.model:getSuitReward(suitId)
    local tankUid = entity.tank_unique_id
    local num = self.model:getCurrentEquipSuitNum(suitId,tankUid)

    local suitReward = self.model:getSuitReward(suitId)
    self:choose(suitReward,3,6,num)
    self:choose(suitReward,3,7,num)
end

function SuitCell2:choose(data,i,j,num)
    if data[i][j] and data[i][j] then
        self["reward_"..i.."_"..j]:setString(data[i][j])
    else
        self["reward_"..i.."_"..j]:setString("")
    end
    if num == 4 then
        self["reward_"..i.."_"..j]:setTextColor(cc.c4b(255, 255, 255,255))
    else
        self["reward_"..i.."_"..j]:setTextColor(cc.c4b(177, 177, 177,255))
    end
end

function SuitCell2:getHeight()
    return 30
end



return SuitCell2
