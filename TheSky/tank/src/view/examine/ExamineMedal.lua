--[[
	勋章信息
	Date: 2016-06-21 14:00:00
]]

local ExamineMedal = qy.class("ExamineMedal", qy.tank.view.BaseView, "view/examine/ExamineMedal")

local model = qy.tank.model.MedalModel
function ExamineMedal:ctor(kid)
    self.kid = kid
    if self.kid <= 10000 then
        self.monster_type = 3
    else
        self.monster_type = 0
    end

	ExamineMedal.super.ctor(self)
	self.model = qy.tank.model.ExamineModel
    self:InjectView("frame1")
    self:InjectView("frame2")
    self:InjectView("title")
    self:InjectView("nomedal")
    self:InjectView("imagebg")

    

    self:createTankList()
end

function ExamineMedal:createTankList()
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




function ExamineMedal:setIdx(idx)
    local entity = self.model.tankList[idx] 
    self.selectIdx = idx
    local cell = self.tankList:cellAtIndex(idx-1) 
    if cell then
        cell.item.light:setVisible(true)
    end
    self:showCurEquip(entity)
end
function ExamineMedal:showCurEquip( entity )
    self.imagebg:removeAllChildren()
    local temp = 0
    if entity.medal then
        local data = entity.medal
        for i=1,13 do
            local list = model:totalAttr3(data,i)
            if list ~= 0 and list ~= nil then
                temp = temp + 1
                local shuxing = qy.tank.view.examine.MedalCell.new({
                ["id"] = i,
                ["num"] = list
                })
                self.imagebg:addChild(shuxing,999,999)
                if temp <= 4 then
                    shuxing:setPosition(cc.p(35,285-(55*temp)))
                else
                    local nums = temp - 4
                    shuxing:setPosition(cc.p(290,285-(50*nums)))
                end 
                
            end
        end
    else
        self.nomedal:setVisible(true)
        self.title:setVisible(false)
    end
    if temp == 0 then
        self.nomedal:setVisible(true)
        self.title:setVisible(false)
    else
        self.nomedal:setVisible(false)
        self.title:setVisible(true)
    end
end
	
return ExamineMedal
