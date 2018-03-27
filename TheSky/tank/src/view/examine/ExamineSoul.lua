--[[
	军魂信息
	Date: 2016-06-21 14:00:00
]]

local ExamineSoul = qy.class("ExamineSoul", qy.tank.view.BaseView, "view/examine/ExamineSoul")

function ExamineSoul:ctor(kid)
    self.kid = kid
    if self.kid <= 10000 then
        self.monster_type = 3
    else
        self.monster_type = 0
    end

	ExamineSoul.super.ctor(self)
	self.model = qy.tank.model.ExamineModel
    self:InjectView("frame1")
    self:InjectView("frame2")

    for i = 1, 8 do
        self:InjectView("equip_" .. i)
        self:InjectView("Name_".. i)
        self:InjectView("Level_".. i)
        self:InjectView("Close_".. i)
        self:InjectView("Soul_".. i)
    end
    self.equipBg = {}
    self.equipIcon = {}
    self.Name = {}
    self.Level = {}
    self.SoulList = {}
    for i =1, 8 do
        self.equipBg[i] = self["equip_" .. i]
        self.Name[i] = self["Name_" .. i]
        self.Level[i] = self["Level_" .. i]
        self.equipIcon[i] = self["Close_" .. i]
        self.SoulList[i] = self["Soul_" .. i]
    end
    
    

    self:createTankList()
end

function ExamineSoul:createTankList()
	self.tankList = cc.TableView:create(cc.size(210,325))
    self.tankList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tankList:setPosition(37,12)
    self.frame2:addChild(self.tankList)
    self.tankList:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model.tankList
    end

    local function tableCellTouched(table,cell)
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



function ExamineSoul:showCurEquip(entity)
    if entity then
        local equipTable = entity.soul
        if equipTable then
            for i = 1, 8 do
                if equipTable["p_"..i].soul_id then
                    self:setLoadSoulByIndx(i, equipTable["p_"..i])
                else
                    self:setSoulDefaultStatusBySoulIndex(i)
                end

                self:OnClick("equip_"..i, function()
                    if equipTable["p_"..i].soul_id then
                        equipTable["p_"..i].type = 22
                        local data = qy.tank.view.common.AwardItem.getItemData(equipTable["p_"..i])
                        qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(data))
                    end
                end,{["isScale"] = false})

            end
        else
            for i = 1, 8 do
                self:setSoulDefaultStatusBySoulIndex(i)
            end
        end
    else
        for i = 1, 8 do
            self:setSoulDefaultStatusBySoulIndex(i)
        end
    end
end

--设置已装备
function ExamineSoul:setLoadSoulByIndx(index, entity)
    local soulModel = qy.tank.model.SoulModel
    self.SoulList[index]:setTexture(soulModel:getSoulIconBySoulId(entity.soul_id))
    self.SoulList[index]:setVisible(true)
    self.Name[index]:setVisible(true)
    self.Level[index]:setVisible(true)
    self.equipIcon[index]:setVisible(false)
    self.Name[index]:setString(soulModel:getSoulNameBySoulId(entity.soul_id))
    self.Level[index]:setString("Lv."..entity.level)
end

--设置装备默认状态
function ExamineSoul:setSoulDefaultStatusBySoulIndex(index)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/icon/common_icon.plist")
    self.equipIcon[index]:loadTexture("Resources/common/icon/c_8.png", 1)
    self.Name[index]:setVisible(false)
    self.Level[index]:setVisible(false)
    self.SoulList[index]:setVisible(false)
    self.equipIcon[index]:setVisible(true)
end

function ExamineSoul:setIdx(idx)
    local entity = self.model.tankList[idx] 
    self.selectIdx = idx
    local cell = self.tankList:cellAtIndex(idx-1) 
    if cell then
        cell.item.light:setVisible(true)
    end
    self:showCurEquip(entity)
end
	
return ExamineSoul
