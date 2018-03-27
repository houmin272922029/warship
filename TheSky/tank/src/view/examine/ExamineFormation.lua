--[[
	查看阵型
	Author: Aaron Wei
	Date: 2015-09-09 20:45:55
]]

local ExamineFormation = qy.class("ExamineFormation", qy.tank.view.BaseView, "view/examine/ExamineFormation")

function ExamineFormation:ctor(kid)
    self.kid = kid
    if self.kid <= 10000 then
        self.monster_type = 3
    else
        self.monster_type = 0
    end

	ExamineFormation.super.ctor(self)
	self.model = qy.tank.model.ExamineModel
    self:InjectView("frame1")
    self:InjectView("frame2")

    for i = 1, 4 do
        self:InjectView("equip_" .. i)
        self:InjectView("equip_icon_".. i)
    end
    --gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
    local equipName = {"gun","bullet","armor","engine"}
    self.equipEffertTable = {} --装备动画
    self.equipBg = {}
    self.equipIcon = {}
    for i =1, 4 do
        self.equipBg[i] = self["equip_" .. i]
        self.equipIcon[i] = self["equip_icon_" .. i]
    end
    
    if not tolua.cast(self.tankInfoList,"cc.Node") then
        self.tankInfoList = qy.tank.view.common.TankInfoList.new(cc.size(270,340))
        self.frame2:addChild(self.tankInfoList)
        self.tankInfoList:setPosition(5,345)
    end

    self:createTankList()

    self:OnClick("equip_1", function()
        self:showAlloy(1)
    end)
    self:OnClick("equip_2", function()
        self:showAlloy(2)
    end)
    self:OnClick("equip_3", function()
        self:showAlloy(3)
    end)
    self:OnClick("equip_4", function()
        self:showAlloy(4)
    end)
end

function ExamineFormation:createTankList()
	self.tankList = cc.TableView:create(cc.size(210,325))
    self.tankList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tankList:setPosition(7,12)
    self.frame1:addChild(self.tankList)
    self.tankList:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model.tankList
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
        local before = table:cellAtIndex(self.selectIdx-1)
        if before then
            before.item.light:setVisible(false)
        end
        self:setIdx(cell:getIdx()+1)
    end

    local function cellSizeForTable(tableView, idx)
        return 210, 120
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.garage.GarageTankCell.new(self.model.tankList[idx+1], idx + 1)
            cell:addChild(item)
            cell.item = item

            status = cc.Label:createWithSystemFont("", "Helvetica", 24.0)
            status:setTextColor(cc.c4b(255,255,0,255))
            status:setPosition(110,65)
            status:setAnchorPoint(0.5,0.5)
            cell:addChild(status)
            cell.status = status
        end
        cell.item:render(self.model.tankList[idx+1], idx+1)
        if self.selectIdx == idx+1 then
            cell.item.light:setVisible(true)
        else
            cell.item.light:setVisible(false)
        end
        return cell
    end

    self.tankList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    self.tankList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.tankList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.tankList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    self.tankList:reloadData()
    self:setIdx(1)
end

-- 坦克卡
function ExamineFormation:showTankImg(entity)
    local data = qy.tank.view.common.AwardItem.getItemData({
      ["type"] = 11,
      ["tank_id"] = entity.tank_id,
      ["monster_type"] = self.monster_type,
      ["isOther"] = true
    })

    if not tolua.cast(self.tankCard,"cc.Node") then
        local award = {["type"] = 11, ["num"] = 1, ["tank"] = data.entity,["isOther"] = true}
        self.tankCard = qy.tank.view.common.AwardItem.createAwardView(award,2)
        self.frame1:addChild(self.tankCard)
        self.tankCard:setPosition(383,225)
        self.tankCard:setScale(0.95)
    else
        self.tankCard:update(data)
    end

    -- if self.tankCard then
    --    self:removeChild(self.tankCard)
    --    self.tankCard = nil
    -- end
    -- local award = {["type"] = qy.tank.view.type.AwardType.TANK, ["num"] = 1, ["tank"] = entity,["monster_type"]=3,["isOther"]=true}
    -- self.tankCard = qy.tank.view.common.AwardItem.createAwardView(award,2)
    -- self.tankCard:setPosition(440,380)
    -- self.frame1:addChild(self.tankCard)
end

function ExamineFormation:showCurEquip(entity)
    local _redDotTankUid = 0
    if type(entity) == "table" then
        local equipTable = entity:getOtherEquipEntity()
        if equipTable then
            self.selectTankUid = entity.unique_id
            _redDotTankUid = entity.unique_id
            for i = 1, 4 do
                if type(equipTable[i]) == "table" then
                    self:setLoadEquipByIndx(i, equipTable[i])
                else
                    self:setEquipDefaultStatusByEquipIndex(i)
                end
            end
        else
            for i = 1, 4 do
                self:setEquipDefaultStatusByEquipIndex(i)
            end
        end
    else
         for i = 1, 4 do
                self:setEquipDefaultStatusByEquipIndex(i)
            end
    end
end

function ExamineFormation:createEquipSuitEffert(_target)
    local _effert = ccs.Armature:create("Flame")
    -- _effert:setScale(1.1)
    _target:addChild(_effert,999)
    _effert:setPosition(51,49)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

--设置已装备
function ExamineFormation:setLoadEquipByIndx(index, entity)
    self.equipBg[index]:loadTextureNormal(entity:getIconBg(),1)
    self.equipBg[index]:loadTexturePressed(entity:getIconBg(),1)
    self.equipIcon[index]:setTexture(entity:getIcon())
    self.equipIcon[index]:setVisible(true)

    if self.equipEffertTable[index] == nil and entity:getSuitID() > 0 then
        self.equipEffertTable[index] = self:createEquipSuitEffert(self.equipIcon[index])
    end

    if entity:getSuitID() == 0 then 
        if self.equipEffertTable[index] then
            self.equipEffertTable[index]:setVisible(false)
        end
    else
        if self.equipEffertTable[index] == nil then
            self.equipEffertTable[index] = self:createEquipSuitEffert(self.equipIcon[index])
        end
        self.equipEffertTable[index]:setVisible(true)
    end
    self.equipBg[index]:setEnabled(true)
end

--设置装备默认状态
function ExamineFormation:setEquipDefaultStatusByEquipIndex(index)
    self.equipBg[index]:loadTextureNormal("Resources/common/item/item_bg_1.png",1)
    self.equipBg[index]:loadTexturePressed("Resources/common/item/item_bg_1.png",1)
    self.equipIcon[index]:setSpriteFrame("Resources/garage/equip_d"..index..".png")
    if self.equipEffertTable[index] then
        self.equipEffertTable[index]:setVisible(false)
    end
    self.equipBg[index]:setEnabled(false)
end

function ExamineFormation:showTankInfo(entity)
    self.tankInfoList:render(entity)
end

function ExamineFormation:clearInfoList()
    if tolua.cast(self.dynamic_c,"cc.Node") then
        self.dynamic_c:getParent():removeChild(self.dynamic_c)
    end
end

function ExamineFormation:setStar(value)
    --print("GarageView:setStar star="..value)
    for i = 1,6 do
        if i <= value then
            self["star"..i]:setVisible(true)
        else
            self["star"..i]:setVisible(false)
        end
    end
end

function ExamineFormation:setIdx(idx)
    local entity = self.model.tankList[idx] 
    self.selectIdx = idx
    local cell = self.tankList:cellAtIndex(idx-1) 
    if cell then
        cell.item.light:setVisible(true)
    end
    self:showTankImg(entity)
    self:showCurEquip(entity)
    self:showTankInfo(entity)
end

function ExamineFormation:showAlloy(idx)
    local tankEntity = self.model.tankList[self.selectIdx] 
    if type(tankEntity) == "table" then
        local equipTable = tankEntity:getOtherEquipEntity()
        if equipTable then
            if type(equipTable[idx]) == "table" then
                qy.alert:showTip(qy.tank.view.examine.ShowExamineEquipInfo.new(equipTable[idx]))
            end
        end
    end
end
	
return ExamineFormation
