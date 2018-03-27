--[[
    装备 entity
    Author: H.X.Sun
    Date: 2015-04-18
]]
local EquipEntity = qy.class("EquipEntity", qy.tank.entity.BaseEntity)

local AlloyModel = qy.tank.model.AlloyModel

function EquipEntity:ctor(data)
    self.data = data
    self.model = qy.tank.model.EquipModel
    self.AlloyModel = qy.tank.model.AlloyModel

    if type(data) == "number" then
        self:setproperty("equip_id", tostring(data))
        self:initByEquipID(self:get("equip_id"))
    elseif type(data) == "table" then
        self:update(data)
    end
end

--[[--
--根据装备ID初始化装备entity
--(仅用于显示，不能加到装备列表)
--@param #number nEquipId 装备ID
--]]
function EquipEntity:initByEquipID(nEquipId)
    local equip = qy.Config.equip[tostring(nEquipId)]
     --装备唯一ID
    self:setproperty("unique_id",0)
    --装备等级
    self:setproperty("level", 1)
    --改造等级
    self:setproperty("reform_level",0)
    --进阶等级
    self:setproperty("advanced_level",0)
    --已装备的坦克唯一ID
    self:setproperty("tank_unique_id",0)
    --装备出售的银币
    self:setproperty("price", equip.price)
    --数量
    self:setproperty("num", 0)
    -- 描述
    self:setproperty("desc",equip.desc)

    self:setproperty("addition_bad", 0)
end

--[[--
--更新
--]]
function EquipEntity:update(data)
    local equip = qy.Config.equip[tostring(data.equip_id)]
    -- 描述
    self:setproperty("desc",equip.desc)
    if data.num then
        --装备碎片--
        self:setproperty("unique_id",-1)
        --已装备的坦克唯一ID
        self:setproperty("tank_unique_id",-1)
        --装备ID
        self:setproperty("equip_id", data.equip_id)
        --数量
        self:setproperty("num", data.num)
        --装备等级
        self:setproperty("level",1)
        --改造等级
        self:setproperty("reform_level",0)
        --进阶等级
        self:setproperty("advanced_level",0)

        self:setproperty("addition_bad", 0)
    else
        --装备--
        --装备唯一ID
        self:setproperty("unique_id",data.unique_id)
        --装备ID
        self:setproperty("equip_id", data.equip_id)
        --装备等级
        -- self:setproperty("level", data.level)
        self.level = data.level
        --已装备的坦克唯一ID
        self:setproperty("tank_unique_id",data.tank_unique_id)
        --远征阵容坦克
        self:setproperty("expedition_tank_unique_id", data.expedition_tank_unique_id or 0)
        --装备出售的银币
        self:setproperty("silver", data.silver)
        --是否是新得到
        self:setproperty("isNew", data.isNew or false)
        --装备出售的银币
        self:setproperty("price", equip.price)
        --合金
        self:setproperty("alloy", data.alloy or {["p_1"] = 0,["p_2"] = 0, ["p_3"] = 0})
        --改造等级
        self:setproperty("reform_level", data.reform_level or 0)
        --改造经验
        self:setproperty("reform_essence", data.reform_essence or 0)
        --改造消耗银币
        self:setproperty("reform_silver", data.reform_silver or 0)
        --进阶等级
        self:setproperty("advanced_level",data.advanced_level or 0)
        --进阶所消耗的紫铁
        self:setproperty("advanced_purple_iron", data.advanced_purple_iron or 0)
        --没保存的洗练属性
        self:setproperty("addition_attr_tmp",data.addition_attr_tmp or {})
        --洗练属性
        self:setproperty("addition_attr",data.addition_attr or {})
        --洗练是否损坏
        self.addition_bad = data.addition_bad or 0
    end
end

--[[--
--是否是新得到
--]]
function EquipEntity:getNew()
    if self.isNew_ then
        return self:get("isNew")
    else
        return false
    end
end

--[[--
--更新是否是new
--]]
function EquipEntity:updateNew()
    if self.isNew_ then
        self.isNew_:set(false)
    end
end

--[[--
--是否有红点
--]]
function EquipEntity:hasRedDot()

    if self.unique_id and self.unique_id > 0 then
        --装备
        if self:get("level") < qy.tank.model.UserInfoModel:getMaxEquipLevelByUserLevel() then
            --等级
            if self:getUpgradeCost() < qy.tank.model.UserInfoModel.userInfoEntity.silver then
                --消耗
                return true
            else
                --个人银币不足，不加红点
                return false
            end

        else
            --等级不小于上限不加红点
            return false
        end

    else
        --装备碎片不加红点
        return false
    end
end


function EquipEntity:reformHasDot()
    if qy.tank.model.EquipModel:reformCanUp(self) then
        return true    
    end
end


function EquipEntity:advanceHasDot()
    if qy.tank.model.EquipModel:testCanAdvance(self) == 3 then
        return true    
    end
end

--[[--
--是否被穿戴 1：是 0 否
--]]
function EquipEntity:isLoad()
    if self.tank_unique_id and self.tank_unique_id > 0 then
        return 1
    else
        return 0
    end
end

--装备名称
function EquipEntity:getName()
    local name = qy.Config.equip[tostring(self:get("equip_id"))].name
    if self.tank_unique_id == -1 then
        name = name .. qy.TextUtil:substitute(9010)
    end

    if self.advanced_level > 0 then
        name = name .. "+" ..self.advanced_level
    end
    return name
end

--装备部位 火炮(1) ,炮弹(2),装甲(3),发动机(4)
function EquipEntity:getType()
    return qy.Config.equip[tostring(self:get("equip_id"))].type
end

--装备套装ID
function EquipEntity:getSuitID()
    return qy.Config.equip[tostring(self:get("equip_id"))].suit_id
end

function EquipEntity:isHasSuit()
    local suit_id = qy.Config.equip[tostring(self:get("equip_id"))].suit_id
    if suit_id > 0 then
        return true
    else
        return false
    end
end

--装备品质
function EquipEntity:getQuality()
    return qy.Config.equip[tostring(self:get("equip_id"))].quality
end

-- --装备icon
-- function EquipEntity:getIcon()
--     return ""
-- end

--装备背景图路径
function EquipEntity:getIconBg()
    local quality = qy.Config.equip[tostring(self:get("equip_id"))].quality

    -- 白绿蓝紫橙
    return "Resources/common/item/item_bg_" .. quality .. ".png"
end

--装备icon
function EquipEntity:getIcon()
    return "equip/icon/"..self:get("equip_id") ..".png"
end

--目标等级强化基数
function EquipEntity:getLevelBase()
    local equip_upgrade = qy.Config.equip_upgrade[tostring(self:get("level") + 1)]
    if equip_upgrade ~= nil then
        local base = equip_upgrade.base
        if base ~= nil then
            return base
        else
            return 0
        end
    else
        return 0
    end    
end

--初始值
function EquipEntity:getInitial()
    local initial = qy.Config.equip[tostring(self:get("equip_id"))].initial
    if initial ~= nil then
        return initial
    else
        return 0
    end
end

--[[--
--获取部位名字
--]]
function EquipEntity:getComponentName()
    local type = self:getType()
    if tonumber(type) == 1 then
        return qy.TextUtil:substitute(9011)
    elseif tonumber(type) == 2 then
        return qy.TextUtil:substitute(9012)
    elseif tonumber(type) == 3 then
        return qy.TextUtil:substitute(9013)
    elseif tonumber(type) == 4 then
        return qy.TextUtil:substitute(9014)
    end
end

--[[--
--获取部位英文名字
--]]
function EquipEntity:getComponentEnglishName()
    local type = self:getType()
    if tonumber(type) == 1 then
        return "gun"
    elseif tonumber(type) == 2 then
        return "bullet"
    elseif tonumber(type) == 3 then
        return "armor"
    elseif tonumber(type) == 4 then
        return "engine"
    end
end

--[[--
--升1级强化价格
--公式：升1级强化价格=目标等级强化基数*部件费用系数*品级费用系数
--]]
function EquipEntity:getUpgradeCost()
    local name = self:getComponentEnglishName()
    return math.floor(self:getLevelBase() * self.model:getEquipTypeByType(name) * self.model:getEquipQualityByQuality(self:getQuality()))
end

--[[--
--属性
--公式：装备总属性数值=初始值+不同品级强化成长系数*强化等级
--]]
function EquipEntity:getProperty()
    return math.floor((self:getInitial() + self.model:getEquipGrowRatioByTypeAndQuality(self:getComponentEnglishName(), self:getQuality()) * (self:get("level") - 1)) * (100 + self:getPropertyByLevel(self:get("reform_level") or 0)) / 100) 
end

--[[--
--属性描述
--]]
function EquipEntity:getPropertyInfo()
    local type = self:getType()
    if tonumber(type) == 1 then
        return qy.TextUtil:substitute(9015, self:getProperty()) 
    elseif tonumber(type) == 2 then
        return qy.TextUtil:substitute(9015, self:getProperty()) 
    elseif tonumber(type) == 3 then
        return  qy.TextUtil:substitute(9016, self:getProperty())
    elseif tonumber(type) == 4 then
        return qy.TextUtil:substitute(9017, self:getProperty()) 
    end
end


--[[--
--进阶属性名称
--]]
function EquipEntity:getPropertyReformName()
    local type = self:getType()
    if tonumber(type) == 1 then
        return qy.TextUtil:substitute(90261) 
    elseif tonumber(type) == 2 then
        return qy.TextUtil:substitute(90261) 
    elseif tonumber(type) == 3 then
        return  qy.TextUtil:substitute(90262)
    elseif tonumber(type) == 4 then
        return qy.TextUtil:substitute(90263) 
    end
end


--[[--
--根据进阶等级获得加成属性
--]]
function EquipEntity:getPropertyByLevel(level)
    return level * level * 0.4 * 0.4 *0.005 * 100
end




--[[--
--初始属性描述
--]]
function EquipEntity:getInitPropertyInfo()
    local type = self:getType()
    if tonumber(type) == 1 then
        return qy.TextUtil:substitute(9015, self:getInitial())
    elseif tonumber(type) == 2 then
        return qy.TextUtil:substitute(9015, self:getInitial())
    elseif tonumber(type) == 3 then
        return  qy.TextUtil:substitute(9016, self:getInitial())
    elseif tonumber(type) == 4 then
        return qy.TextUtil:substitute(9017, self:getInitial())
    end
end

--[[--
--装备的于的坦克的名字
--]]
function EquipEntity:getTankName()
    local uid = self.tank_unique_id
    if uid > 0 then
        return qy.tank.model.GarageModel:getEntityByUniqueID(uid):get("name")
    else
        return nil
    end
end

--[[--
--装备的于的坦克的品质
--]]
function EquipEntity:getTankQuality()
    local uid = self.tank_unique_id
    if uid > 0 then
        return qy.tank.model.GarageModel:getEntityByUniqueID(uid):get("quality")
    else
        return nil
    end
end

--[[--
--获取角标
--]]
function EquipEntity:getMark()
    if self.tank_unique_id > 0 then
        if self.model:getFirstEquipTankUid() == self.tank_unique_id then
            --当前装备
            return "Resources/equip/dangqian.png"
        else
            --已装备
            return "Resources/equip/zhuangbei.png"
        end
    elseif self.tank_unique_id == -1 then
        --装备碎片
        return "Resources/equip/suipian.png"
    else
        return nil
    end
end

--[[--
--获取套装信息
--]]
function EquipEntity:getSuitIfo()
    return self.suitInfo
end

function EquipEntity:getAlloyAttribute()
    local arr = {}
    local alloyEntity = nil
    local index = ""
    --
    for i = 1, 3 do
        if i == AlloyModel.ALLOY_ID_1 then
            index = "attack"
        elseif i == AlloyModel.ALLOY_ID_2 then
            index = "defense"
        else
            index = "blood"
        end
        alloyEntity = self:getAlloyEntityByAlloyId(i)
        if type(alloyEntity) == "table" then
            arr[index] = alloyEntity:getAttribute()
        else
            arr[index] = 0
        end
    end
    -- print("arr========>>>>>",qy.json.encode(arr))
    return arr
end

function EquipEntity:hasAlloy()
    if self.alloy then
        for i = 1, 3 do
            
            if self.alloy["p_"..i] and self.alloy["p_"..i] > 0 then
                -- print("self.alloy[p_"..i.."]===>>>",self.alloy["p_"..i])
                return true
                
            end
        end
        return false
    else
        return false
    end
end


function EquipEntity:hasReform()
    if self.reform_level and self.reform_level > 0 then
        return true
    else
        return false
    end
end
function EquipEntity:hasClear()
    if self.addition_attr and #self.addition_attr > 0 then
        return true
    else
        return false
    end
end

--[[--
--获取套装标题
--]]
function EquipEntity:getSuitTitle()
    return "Resources/equip/suit_title_"..self:getSuitID() .. ".png"
end

function EquipEntity:getTextColor()
    return qy.tank.utils.ColorMapUtil.qualityMapColor(self:getQuality())
end

function EquipEntity:getAlloyEntityByAlloyId(_alloyId)
    if self.alloyEntityArr == nil then
        self.alloyEntityArr = {}
    end
    if self.alloy["p_".._alloyId] > 0 then
        --该位置已嵌入合金
        if self.alloyEntityArr[_alloyId] == nil then
            -- print("===>>>>>>>>>位置".. _alloyId .. "不存在合金实体，需查找")
            --合金数组不存在该位置的合金实体,则查找实体
            self.alloyEntityArr[_alloyId] = self.AlloyModel:getSelectListByIndex(_alloyId, self.unique_id)
        else
            --合金数组存在该位置的合金实体
            if self.alloyEntityArr[_alloyId].unique_id ~= self.alloy["p_".._alloyId] then
                -- print("===>>>>>>>>>位置".. _alloyId .. "存在合金实体，但ID不一致需查找")
                --合金实体的唯一ID和装备合金的唯一ID不一致，则重新查找实体
                self.alloyEntityArr[_alloyId] = self.AlloyModel:getSelectListByIndex(_alloyId, self.unique_id)
            else
                -- print("===>>>>>>>>>位置".. _alloyId .. "存在合金实体，不需查找")
            end
        end
    else
        -- print("===>>>>>>>>>位置".. _alloyId .. "没有嵌入合金")
        self.alloyEntityArr[_alloyId] = nil
    end

    return self.alloyEntityArr[_alloyId]
end

function EquipEntity:updateAlloy(_pos,_alloyUid)
    -- print("更新装备的合金信息pos===".._pos .. "  _alloyUid===" .. _alloyUid)
    if self.alloy == nil then
        self.alloy = {}
    end
    self.alloy[_pos] = _alloyUid
end

return EquipEntity
