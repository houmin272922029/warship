--[[
	乘员信息
	Date: 2016-06-21 14:00:00
]]

local ExaminePassenger = qy.class("ExaminePassenger", qy.tank.view.BaseView, "view/examine/ExaminePassenger")

local PassengerModel = qy.tank.model.PassengerModel
function ExaminePassenger:ctor(kid)
    self.kid = kid
    if self.kid <= 10000 then
        self.monster_type = 3
    else
        self.monster_type = 0
    end

	ExaminePassenger.super.ctor(self)
	self.model = qy.tank.model.ExamineModel
    self:InjectView("frame1")
    self:InjectView("frame2")

    for i=1,4 do
        self:InjectView("AnswerBtn" .. i)
        self:InjectView("upAttr" .. i)
        self:InjectView("M_Name" .. i)
        self:InjectView("M1" .. i)
        self:InjectView("M" .. i)
        self:InjectView("MM_" .. i)
        self:InjectView("pass" .. i)
        self:InjectView("M".. i .."_Name")
        self:InjectView("updes" .. i)
        self:InjectView("upAttr" .. i)
        self:InjectView("updes1" .. i)
        self:InjectView("M_select" .. i) 
    end

    self:InjectView("updesName")
    self:InjectView("Panel_1")
    self:InjectView("upPlayerBg")
    self:InjectView("upPlayerinfo")
    self:InjectView("upPlayerName")
    self:InjectView("upPlayer")
    self:InjectView("upPlayer_1")
    self:InjectView("up_select")
    self:InjectView("Node_3")
    self:InjectView("upTitle")
    

    self:createTankList()
end

function ExaminePassenger:createTankList()
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



function ExaminePassenger:showCurPassenger(entity)
    local list = PassengerModel:getInfoFromTankEntity(entity)
    local staicData = qy.Config.passenger


    if type(entity) == "table" then
        -- 刷新下面选中将领
        self.upTitle:setVisible(true)
        self.upTitle:setString("【"..entity.name.."】" .. "乘员总加成")
    end


    -- 刷新中间乘员信息
    if list then
        self.Node_3:setVisible(true)
        local atk = 0
        local def = 0
        local hp = 0
        for i, v in pairs(list) do
            if v.isjoin == 100 then
                local key = v.passengerType
                if key == 1 then
                    self.upPlayer_1:setVisible(true)
                    self.upPlayer_1:loadTexture("res/passenger/" .. v.passenger_id .. "_1" .. ".png")
                    self.upPlayer:setVisible(true)
                    self.upPlayer:loadTexture("res/passenger/" .. v.passenger_id .. ".jpg")
                    self.upPlayerBg:setSpriteFrame("Resources/common/item/k".. v.quality ..".png")
                    self.upPlayerinfo:setString((v.passengerType == 1 and  "将领("..PassengerModel.typeNameList[v.passengerType..""]..")" or PassengerModel.typeNameList[v.passengerType..""]) .. " Lv."..v.level)
                    self.upPlayerinfo:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(v.quality))
                    self.upPlayerinfo:setVisible(true)
                    self.upPlayerName:setString(v.name)
                    self.upPlayerName:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(v.quality))
                else
                    local pass = self["pass" .. (key - 1)]
                    pass:setVisible(true)
                    self["M" .. (key - 1)]:setSpriteFrame("Resources/common/item/item_bg_".. v.quality ..".png")
                    local data = qy.tank.view.common.AwardItem.getItemData(v)
                    self["M" .. (key - 1) .."_Name"]:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality))
                    self["M" .. (key - 1) .."_Name"]:setString(PassengerModel.typeNameList[v.passengerType..""])
                    pass:loadTexture(data.icon)
                end
            end
            local passData = staicData[tostring(v.passenger_id)]
            atk = atk + math.floor(passData.attack * (v.level + 1)^1.5)
            def = def + math.floor(passData.defense * (v.level + 1)^1.5)
            hp = hp + math.floor(passData.blood * (v.level + 1)^1.5)
        end
        self.upAttr1:setString((atk > 0 and "攻击：+" .. atk or "攻击：+0"))
        self.upAttr2:setString((def > 0 and "防御：+" .. def or "防御：+0"))
        self.upAttr3:setString((hp > 0 and "生命：+" .. hp or "生命：+0"))
    else
        self.Node_3:setVisible(false)
        self.upAttr1:setString(("攻击：+0"))
        self.upAttr2:setString(("防御：+0"))
        self.upAttr3:setString(("生命：+0"))
    end
end




function ExaminePassenger:setIdx(idx)
    local entity = self.model.tankList[idx] 
    self.selectIdx = idx
    local cell = self.tankList:cellAtIndex(idx-1) 
    if cell then
        cell.item.light:setVisible(true)
    end
    self:showCurPassenger(entity)
end
	
return ExaminePassenger
