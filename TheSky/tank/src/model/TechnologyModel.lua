--[[
    科技 model 
    add by lianyi
    
    增加的属性
    1=攻击力
    2=防御力
    3=生命值
    4=攻击力系数
    5=防御力系数
    6=生命系数
]]
local TechnologyModel = qy.class("TechnologyModel", qy.tank.model.BaseModel)
local StrongModel = qy.tank.model.StrongModel
TechnologyModel.technologyList = {}
TechnologyModel.openList = {}

function TechnologyModel:init(data)
    self.technologyTypeConfig = qy.Config.technology_type
    self.technologyValueConfig = qy.Config.technology_value

    self.userInfoModel = qy.tank.model.UserInfoModel

    local attrArr = {0,0,0,1,1,1}
    local finalReturn = {}
    finalReturn.att_add = attrArr[1]
    finalReturn.def_add = attrArr[2]
    finalReturn.life_add = attrArr[3]
    finalReturn.att_c = attrArr[4]
    finalReturn.def_c = attrArr[5]
    finalReturn.life_c = attrArr[6]

    self.finalReturn = finalReturn
    self:updateTechnologyList(data.list)

    if not data.list then
        self:setOpenList(data)
    end

    local _table = {}
    local staticData = qy.Config.gongneng_open
    for i, v in pairs(staticData) do
        table.insert(_table, v)
    end

    table.sort(_table,function(a,b)
     return tonumber(a.id) < tonumber(b.id)
    end)

    self.open1 = _table[43].open_level
    self.open2 = _table[44].open_level
    self.open3 = _table[45].open_level
    self.open4 = _table[46].open_level

    self.unlockLevel = {_table[43].open_level, _table[44].open_level, _table[45].open_level, _table[46].open_level}
end


function TechnologyModel:init2(data)
    self.armed_forces_1 = {}
    self.armed_forces_2 = {}
    self.armed_forces_consume_1 = {}
    self.armed_forces_consume_2 = {}

    

    for i, v in pairs(qy.Config.armed_forces_1) do
        table.insert(self.armed_forces_1, v)
    end

    for i, v in pairs(qy.Config.armed_forces_2) do
        table.insert(self.armed_forces_2, v)
    end

    for i, v in pairs(qy.Config.armed_forces_consume_1) do
        table.insert(self.armed_forces_consume_1, v)
    end

    for i, v in pairs(qy.Config.armed_forces_consume_2) do
        table.insert(self.armed_forces_consume_2, v)
    end

    table.sort(self.armed_forces_1,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)

    table.sort(self.armed_forces_2,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)

    table.sort(self.armed_forces_consume_1,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)

    table.sort(self.armed_forces_consume_2,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)

    self:update(data)
end

function TechnologyModel:update(data)
    if data.technologyinfo then
        self.base = data.technologyinfo.base or self.base
        self.special = data.technologyinfo.special or self.special
    elseif data.technology_clear then
        self.base = data.technology_clear.base or self.base
        self.special = data.technology_clear.special or self.special
    end
end


function TechnologyModel:getBaseByPos(num)
    for i = 1, 6 do
        if self.base["p_"..i].position == num then
            return self.base["p_"..i].base
        end
    end
end


function TechnologyModel:getSpecialByPos(num)
    for i = 1, 6 do
        if self.special["p_"..i].position == num then
            return self.special["p_"..i].base
        end
    end
end


-- 开启列表
function TechnologyModel:setOpenList(data)
    for i, v in pairs(data) do
        self.openList[tostring(v.id)] = qy.tank.entity.TechnologyEntity.new(v , self:getTechnologyConfigByTemplateIndex(v.id))
    end
end

function TechnologyModel:testOpen(idx)
    return qy.tank.model.UserInfoModel.userInfoEntity.level >= self.unlockLevel[idx]
    -- return self.openList[tostring(idx)]
end

--更新科技列表
function TechnologyModel:updateTechnologyList(list)
    if list == nil or #list<1 then self:updateStrong(0) return end

    table.sort(list,
        function(a,b) 
            return a.id<b.id
        end
    )
    
    local entity = nil
    for i=1, #list do
        local entity = self:getTechnologyEntityByTemplateId(list[i].id)
        if entity == nil then
            self.technologyList[tostring(list[i].id)] = qy.tank.entity.TechnologyEntity.new(list[i] , self:getTechnologyConfigByTemplateIndex(list[i].id))
            -- table.insert(self.technologyList , )
        else
            entity:update(list[i])
        end
    end

    self:updateStrong()
    self:updateAddData()
end

function TechnologyModel:updateStrong(index)
    local i = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        i = i + 1
        if v.id == 8 then
            table.remove(StrongModel.StrongFcList, i)
        end
    end
    if index == 0 then
        local list = {["id"] = 8 , ["progressNum"] = 0}
        table.insert(StrongModel.StrongFcList,list)
        return
    end
    local level = qy.tank.model.UserInfoModel.userInfoEntity.level
    local totalLevel = 0
    for k,v in pairs(self.technologyList) do
        totalLevel = totalLevel + v.level
    end
    local list = {["id"] = 8 , ["progressNum"] = (totalLevel / level * 9 * 0.6) }
    table.insert(StrongModel.StrongFcList,list)
end

--根据模版类型获取该类型下的科技配置数组
function TechnologyModel:getTechnologyConfigListByTemplateIndex(index)
    local listArr = {}
    for templateIndex , templateData in pairs(self.technologyTypeConfig) do
        if tonumber(templateData.template) == tonumber(index) then
            table.insert(listArr, templateData)
        end
    end
    table.sort(listArr,
        function(a,b) 
            return tonumber(a.id)<tonumber(b.id)
        end
    )
    return listArr
end

--获取某一等级的技能配置数据
function TechnologyModel:getTechnologyConfigValueByLevel(level)
    for lv, levelData in pairs(self.technologyValueConfig) do
        if tonumber(level) == tonumber(lv) then 
            return levelData
    	end
    end
    return nil
end

--根据科技ID获取科技配置
function TechnologyModel:getTechnologyConfigById( id )
    for templateIndex , templateData in pairs(self.technologyTypeConfig) do
        if tonumber(templateData.id) == tonumber(id) then
            return templateData
        end
    end
    return nil
end

--根据科技模块索引ID获取科技配置
function TechnologyModel:getTechnologyConfigByTemplateIndex(index)
    for templateIndex , templateData in pairs(self.technologyTypeConfig) do
        if tonumber(templateData.template) == tonumber(index) then
            return templateData
        end
    end
    return nil
end

--从已有科技列表中获取指定科技实体
function TechnologyModel:getTechnologyEntityByTemplateId(id)
    -- if TechnologyModel.technologyList == nil or #TechnologyModel.technologyList<1 then return nil end
    
    -- for i=1, #TechnologyModel.technologyList do
    -- 	if TechnologyModel.technologyList[i].id == tonumber(id) then
    --         return TechnologyModel.technologyList[i]
    -- 	end
    -- end
    return TechnologyModel.technologyList[tostring(id)]
end

--获取当前科技的用户信息
function TechnologyModel:getCurrentTechUserData(id)
    -- if TechnologyModel.technologyList == nil or #TechnologyModel.technologyList<1 then return nil end
    -- for i=1, #TechnologyModel.technologyList do
    --     if TechnologyModel.technologyList[i].id == id then
    --         return TechnologyModel.technologyList[i]
    --     end
    -- end
    return TechnologyModel.technologyList[tostring(id)]
end 

function TechnologyModel:getImgUrlByIndex(index)
    local imgUrl = "Resources/technology/"..index..".png"
    return imgUrl
end

--[[
    获取科技效果属性加成
        攻击加值，  防御加值，  生命加值，   攻击系数，防御系数，生命系数。 例如： 85,91,124,1.07,1.85,2.9
        att_add , def_add , life_add , att_c , def_c , life_c
    
    用法：
        qy.tank.model.TechnologyModel:getTechEffertAttr()   
        return {"att_add":120 , "def_add":189 , "life_add":400 , "att_c":1.05 , "def_c":1 , "life_c":1.7}
]]

function TechnologyModel:updateAddData()
    local attrArr = {0,0,0,1,1,1}
    local techObj = nil
    local levelObj = nil
    local index = -1
    local attrIndex = 0
    for i, techObj in pairs(TechnologyModel.technologyList) do
        -- techObj = TechnologyModel.technologyList[i]
        index = techObj.id
        levelObj = self:getTechnologyConfigValueByLevel(techObj.level)
        attrIndex = levelObj["attribute"..index]
        attrValue = levelObj["value"..index]
        if attrIndex > 3 then
            attrArr[attrIndex] = attrArr[attrIndex] * attrValue
        else
            attrArr[attrIndex] = attrArr[attrIndex] + attrValue
        end
    end

    local finalReturn = {}
    finalReturn.att_add = attrArr[1]
    finalReturn.def_add = attrArr[2]
    finalReturn.life_add = attrArr[3]
    finalReturn.att_c = attrArr[4]
    finalReturn.def_c = attrArr[5]
    finalReturn.life_c = attrArr[6]

    self.finalReturn = finalReturn
end


function TechnologyModel:getTechEffertAttr()    
    return self.finalReturn
end

---------------红点专属------------
-- 红点通知 专属接口
function TechnologyModel:getAllTechnolog()
    return TechnologyModel.technologyList
end

--判断当前科技是否可以升级
function TechnologyModel:canUpgradeOrNotByTechId(id)
    id = tonumber(id)
    print("id==" .. id) 
    local maxTechLevel = self.userInfoModel:getMaxTechnologyLevelByUserLevel()
    --print("maxTechLevel==" .. maxTechLevel) 
    local currentTechUserData = self:getCurrentTechUserData(id)
    local currentLevel = currentTechUserData == nil and 1 or currentTechUserData.level
    --print("currentLevel==" .. currentLevel) 
    local currentTechConfigLevelValue = self:getTechnologyConfigValueByLevel(currentLevel)
    local totalItemNum = self.userInfoModel.userInfoEntity.technologyHammer
    --print("totalItemNum==" .. totalItemNum) 
    local currentNeedNum = self:getTechnologyConfigValueByLevel(currentLevel)["tech_hammer"..id]
    --print("currentNeedNum==" .. currentNeedNum) 

        --有足够的科技书
    local canUpgrade = false
    if currentNeedNum <= totalItemNum and currentLevel < maxTechLevel then 
        canUpgrade = true
    end

    return canUpgrade
end

return TechnologyModel
