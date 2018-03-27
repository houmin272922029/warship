--[[
	查看合金
]]

local ShowExamineEquipInfo = qy.class("ShowExamineEquipInfo", qy.tank.view.BaseDialog,"view/examine/ShowExamineEquipInfo")

local equipModel = qy.tank.model.EquipModel
local NodeUtil = qy.tank.utils.NodeUtil
local alloyModel = qy.tank.model.AlloyModel

function ShowExamineEquipInfo:ctor(equipTable)
	ShowExamineEquipInfo.super.ctor(self)
    
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(500,460),
        position = cc.p(0,0),
        offset = cc.p(0,0),

    })
    self:addChild(style, -1)

    self:InjectView("ScrollView_2")
    
    self:InjectView("biaotidi_2")
    self:InjectView("partTitle")
    self:InjectView("levelTitle") 
    self:InjectView("initTitle")
    self:InjectView("propertyTitle")
    self:InjectView("equipName")
    self:InjectView("part")
    self:InjectView("level")
    self:InjectView("init_property")
    self:InjectView("property")
    self:InjectView("equipIcon")
    self:InjectView("equipBg")
    self:InjectView("Node_5")


    local equipCfg = equipModel:getEquipCfgById(equipTable.equip_id)
    self.equipName:setString(equipTable:getName())
    self.equipName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(equipCfg.quality))
    self.part:setString(equipModel:getComponentName(equipCfg.type))
    
    self.level:setString(equipTable.level)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    self.equipBg:setSpriteFrame("Resources/common/item/item_bg_" .. equipCfg.quality .. ".png")
    self.equipIcon:setTexture("equip/icon/"..equipTable.equip_id ..".png")

    local initproperty
    if tonumber(equipCfg.type) == 1 then
        initproperty = qy.TextUtil:substitute(9015, equipCfg.initial) 
    elseif tonumber(equipCfg.type) == 2 then
        initproperty = qy.TextUtil:substitute(9015, equipCfg.initial) 
    elseif tonumber(equipCfg.type) == 3 then
        initproperty = qy.TextUtil:substitute(9016, equipCfg.initial)
    elseif tonumber(equipCfg.type) == 4 then
        initproperty = qy.TextUtil:substitute(9017, equipCfg.initial) 
    end
    self.init_property:setString(initproperty)

    local equipType = ""
    if tonumber(equipCfg.type) == 1 then
        equipType = equipType .. "gun"
    elseif tonumber(equipCfg.type) == 2 then
        equipType = equipType .. "bullet"
    elseif tonumber(equipCfg.type) == 3 then
        equipType = equipType .. "armor"
    elseif tonumber(equipCfg.type) == 4 then
        equipType = equipType .. "engine"
    end

    local  Property = equipCfg.initial + equipModel:getEquipGrowRatioByTypeAndQuality(equipType, equipCfg.quality )*(equipTable.level - 1)
    local PropertyInfo
    if tonumber(equipCfg.type) == 1 then
        PropertyInfo = qy.TextUtil:substitute(9015, Property) 
    elseif tonumber(equipCfg.type) == 2 then
        PropertyInfo = qy.TextUtil:substitute(9015, Property) 
    elseif tonumber(equipCfg.type) == 3 then
        PropertyInfo = qy.TextUtil:substitute(9016, Property)
    elseif tonumber(equipCfg.type) == 4 then
        PropertyInfo = qy.TextUtil:substitute(9017, Property) 
    end

    self.property:setString(PropertyInfo)

    self:InjectView("taozhuangxian_3")
    self:InjectView("suitTitle")
    self:InjectView("txt")
    self:InjectView("txtbg")
    self:InjectView("txt_2")
    self:InjectView("suitTitle")
    for i=1,4 do
        self:InjectView("suit_bg_"..i)
        self:InjectView("suit_"..i)
    end
    for i=1,8 do
        self:InjectView("clear_arr"..i)
        self:InjectView("clear_num"..i)
    end
    for i = 1, 3 do
        self:InjectView("reward_" .. i)
        for j = 1, 4 do
            self:InjectView("reward_" .. i .."_" .. j)
        end
    end
    for i = 1, 3 do
        self:InjectView("bg_" .. i) 
        self:InjectView("alloy_" .. i)
        self:InjectView("level_bg_" .. i)
        self:InjectView("level_" .. i)
        self:InjectView("att_"..i)
    end
    self.rewardUiTable = {
        [1] = {self.reward_1, self.reward_1_1, self.reward_1_2},
        [2] = {self.reward_2, self.reward_2_1, self.reward_2_2},
        [3] = {self.reward_3, self.reward_3_1, self.reward_3_2, self.reward_3_3, self.reward_3_4}
    }

    local suitList = {}

    local EquipCfg = qy.Config.equip

    for i = 1, table.nums(EquipCfg) do
        local item = EquipCfg[tostring(i)]
        if item.suit_id == equipCfg.suit_id then
            table.insert(suitList, item)
        end
    end

    self.suitTitle:setSpriteFrame("Resources/equip/suit_title_".. equipCfg.suit_id .. ".png")

    
    if equipCfg.suit_id > 0 then 
        for i=1,4 do
            self["suit_bg_"..i]:setSpriteFrame("Resources/common/item/item_bg_" .. equipCfg.quality .. ".png")
            self["suit_"..i]:setTexture("equip/icon/"..suitList[i].equip_id ..".png")
            NodeUtil:darkNode(self["suit_"..i], suitList[i].equip_id ~= equipTable.equip_id)
            NodeUtil:darkNode(self["suit_bg_"..i], suitList[i].equip_id ~= equipTable.equip_id)
            
        end

        local sameSuitNum = 0
        local suitReward = equipModel:getSuitReward(equipCfg.suit_id)

        for i = 1, #self.rewardUiTable do
            for j = 1, #self.rewardUiTable[i] do
                self.rewardUiTable[i][j]:setString(suitReward[i][j])
                if sameSuitNum > i  and j == 1 then
                    self.rewardUiTable[i][j]:setTextColor(cc.c4b(245, 218, 135,255))
                elseif sameSuitNum > i  and j ~= 1 then
                    self.rewardUiTable[i][j]:setTextColor(cc.c4b(255, 255, 255,255))
                else
                    self.rewardUiTable[i][j]:setTextColor(cc.c4b(177, 177, 177,255))
                end
            end
        end
    end

    local isHasAlloy = false
    local fuck = 0
    for i=1,3 do
        if equipTable.alloy["p_"..i].level then
            fuck = fuck + 1
            isHasAlloy = true
            local alloyType = ""
            if equipTable.alloy["p_"..i].alloy_id == 1 then
                alloyType = alloyType .."attack_"
            elseif equipTable.alloy["p_"..i].alloy_id == 2 then
                alloyType = alloyType .."defense_"
            else
                alloyType = alloyType .."blood_"
            end
            if equipTable.alloy["p_"..i].level < 4 then
                alloyType = alloyType .."1"
            elseif equipTable.alloy["p_"..i].level >= 4 and equipTable.alloy["p_"..i].level < 7 then
                alloyType = alloyType .."2"
            else
                alloyType = alloyType .."3"
            end
            self["alloy_" .. i]:setTexture("equip/alloy/alloy_"..alloyType..".png")
            self["level_bg_" .. i]:setVisible(true)
            self["level_"..i]:setString(equipTable.alloy["p_"..i].level)
            self["att_"..i]:setVisible(true)
            local data = qy.Config.alloy
            local _str = equipTable.alloy["p_"..i].alloy_id .. "_" .. equipTable.alloy["p_"..i].level
            local alloyStr = 0
            for _k, _v in pairs(data) do
                if _v["alloy_id_level"] == _str then
                    alloyStr = _v["plus"]
                end
            end
            self["att_"..fuck]:setString(alloyModel:getAttributeNameByAlloyId(equipTable.alloy["p_"..i].alloy_id) .. " + "..alloyStr)
        else
            self["alloy_" .. i]:setTexture("Resources/common/bg/c_12.png")
            self["level_bg_" .. i]:setVisible(false)
        end 
    end
    
    if fuck < 3 then
        self["att_"..3]:setVisible(false)
        if fuck < 2 then
            self["att_"..2]:setVisible(false)
        end
        if fuck == 0 then
            self["att_"..1]:setVisible(false)
        end
    end

    local Height = 850
    if isHasAlloy then
        if equipCfg.suit_id == 0 then
            self:refreshInerNode1Layer()
            self:refreshInerNode3Layer()
        end
    else
        Height = 580
        for i = 1, 3 do
            self["bg_" .. i]:setVisible(false)
            self["alloy_" .. i]:setVisible(false)
            self["level_bg_" .. i]:setVisible(false)
            self["level_" .. i]:setVisible(false)
            self["att_"..i]:setVisible(false)
            self.txt:setVisible(false)
            self.txt_2:setVisible(false)
            self.txtbg:setVisible(false)
        end
        
        if equipCfg.suit_id == 0 then
            self:refreshInerNode1Layer()
        else
            self:refreshInerNode1Layer()
            self:refreshInerNode2Layer()
        end
    end

    if equipCfg.suit_id == 0 then
        Height = 580
        for i=1,4 do
            self["suit_bg_"..i]:setVisible(false)
            self["suit_"..i]:setVisible(false)
            self["reward_3" .."_" .. i]:setVisible(false)
        end
        for i = 1, 3 do
            self["reward_" .. i]:setVisible(false)
        end
        for j = 1, 2 do
            self["reward_1" .."_" .. j]:setVisible(false)
            self["reward_2" .."_" .. j]:setVisible(false)
        end
        self.taozhuangxian_3:setVisible(false)
        self.suitTitle:setVisible(false)
        if isHasAlloy then
            for i = 1, 3 do
                self["bg_" .. i]:setPositionY(self["bg_" .. i]:getPositionY()+270)
                self["att_"..i]:setPositionY(self["att_"..i]:getPositionY()+270)
                self.txt:setPositionY(self.txt:getPositionY()+90)
                self.txt_2:setPositionY(self.txt_2:getPositionY()+90)
                self.txtbg:setPositionY(self.txtbg:getPositionY()+90)
            end
        end
    end

    for i = 1, 3 do
        self:InjectView("reform_att_"..i)
    end

    for i = 1, 2 do
        self:InjectView("reform_txt_"..i)
    end


    if equipTable.reform_level > 0 then
        self.reform_att_1:setString(equipTable.reform_level)
        self.reform_att_3:setString(equipTable:getPropertyReformName())
        self.reform_att_2:setString("+"..equipTable:getPropertyByLevel(equipTable.reform_level).."%")
    else
        for i = 1, 3 do
            self["reform_att_"..i]:setVisible(false)
        end

        for i = 1, 2 do
            self["reform_txt_"..i]:setVisible(false)
        end
    end

    local tpmHeight =  0 
    if equipTable:hasClear() then
        self.Node_5:setVisible(true)
        tpmHeight =  tpmHeight + 35
        for i = 1, 8 do
            if equipTable.addition_attr[i] then
                tpmHeight = tpmHeight + 35
                self["clear_arr"..i]:setVisible(true)
                self["clear_num"..i]:setVisible(true)
                local data = equipTable.addition_attr[i]
                local id  = data.id
                self["clear_arr"..i]:setString(qy.tank.model.EquipModel.TypeNameList[tostring(data.id)]..":")
                if id < 6 then
                    self["clear_num"..i]:setString("+"..data.num)
                else
                    local num1 = data.num / 10 
                    self["clear_num"..i]:setString("+"..num1.."%")
                end
            else
                self["clear_arr"..i]:setVisible(false)
                self["clear_num"..i]:setVisible(false)
            end
        end
    else
        self.Node_5:setVisible(false)
    end
    Height = Height + tpmHeight
    if not isHasAlloy then
        for i = 1, 3 do
            self["reform_att_"..i]:setPositionY(self["reform_att_"..i]:getPositionY()+260)
        end

        for i = 1, 2 do
            self["reform_txt_"..i]:setPositionY(self["reform_txt_"..i]:getPositionY()+260)
        end
        if equipTable.reform_level > 0 then        
            self.Node_5:setPositionY(self.Node_5:getPositionY()+ 260)
        else
            self.Node_5:setPositionY(self.Node_5:getPositionY()+ 360)
        end
        if equipCfg.suit_id ~= 0 then
            for i = 1, 3 do
                self["reform_att_"..i]:setPositionY(self["reform_att_"..i]:getPositionY()-260)
            end

            for i = 1, 2 do
                self["reform_txt_"..i]:setPositionY(self["reform_txt_"..i]:getPositionY()-260)
            end
            if equipTable.reform_level > 0 then   
                self.Node_5:setPositionY(self.Node_5:getPositionY()- 260)
            else
                self.Node_5:setPositionY(self.Node_5:getPositionY()- 260)
            end
        end
    else
        if equipTable.reform_level == 0 then        
            self.Node_5:setPositionY(self.Node_5:getPositionY()+ 100)
        end
    end
    --这是加洗练重新设置坐标
    if tpmHeight > 0 then
        self:refreshInerNode3Layer(tpmHeight)
        self:refreshInerNode1Layer(tpmHeight)
        self:refreshInerNode2Layer(tpmHeight)
        self:refreshInerNode4Layer(tpmHeight)
    end
    self.ScrollView_2:setInnerContainerSize(cc.size(500,Height))
end
function ShowExamineEquipInfo:refreshInerNode4Layer( height )
    for i = 1, 3 do
        self["reform_att_"..i]:setPositionY(self["reform_att_"..i]:getPositionY()+ height)
    end

    for i = 1, 2 do
        self["reform_txt_"..i]:setPositionY(self["reform_txt_"..i]:getPositionY()+ height)
    end
    self.Node_5:setPositionY(self.Node_5:getPositionY() + height)
end
function ShowExamineEquipInfo:refreshInerNode3Layer(Height)
    local height = Height or 0
    local high = height == 0 and -260 or height 
    for i = 1, 3 do
        self["bg_" .. i]:setPositionY(self["bg_" .. i]:getPositionY() + high)
        self["att_"..i]:setPositionY(self["att_"..i]:getPositionY() + high)
    end
    self.txt_2:setPositionY(self.txt_2:getPositionY()+ high)
    self.txtbg:setPositionY(self.txtbg:getPositionY()+ high)
    self.txt:setPositionY(self.txt:getPositionY()+ high)
end

function ShowExamineEquipInfo:refreshInerNode1Layer(Height )
    local height = Height or 0
    local high = height == 0 and -260 or height 
    self.biaotidi_2:setPositionY(self.biaotidi_2:getPositionY() + high)
    self.part:setPositionY(self.part:getPositionY() + high)
    self.level:setPositionY(self.level:getPositionY() + high)
    self.equipBg:setPositionY(self.equipBg:getPositionY() + high)
    self.partTitle:setPositionY(self.partTitle:getPositionY() + high)
    self.levelTitle:setPositionY(self.levelTitle:getPositionY() + high)
    self.initTitle:setPositionY(self.initTitle:getPositionY() + high)
    self.propertyTitle:setPositionY(self.propertyTitle:getPositionY() + high)
    self.init_property:setPositionY(self.init_property:getPositionY() + high)
    self.property:setPositionY(self.property:getPositionY()+ high)
end
function ShowExamineEquipInfo:refreshInerNode2Layer( Height)
    local height = Height or 0
    local high = height == 0 and -260 or height 
    for i=1,4 do
        self["suit_bg_"..i]:setPositionY(self["suit_bg_"..i]:getPositionY() + high)
        self["reward_3" .."_" .. i]:setPositionY(self["reward_3" .."_" .. i]:getPositionY() + high)
    end
    for i = 1, 3 do
        self["reward_" .. i]:setPositionY(self["reward_" .. i]:getPositionY() + high)
    end
    for j = 1, 2 do
        self["reward_1" .."_" .. j]:setPositionY(self["reward_1" .."_" .. j]:getPositionY() + high)
        self["reward_2" .."_" .. j]:setPositionY(self["reward_2" .."_" .. j]:getPositionY()+ high)
    end
    self.suitTitle:setPositionY(self.suitTitle:getPositionY() + high)
    self.taozhuangxian_3:setPositionY(self.taozhuangxian_3:getPositionY() + high)
end

return ShowExamineEquipInfo