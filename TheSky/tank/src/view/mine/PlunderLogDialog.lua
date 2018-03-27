--[[
    战报
    Author: H.X.Sun
    Date: 2015-08-31
]]

local PlunderLogDialog = qy.class("PlunderLogDialog", qy.tank.view.BaseDialog)

function PlunderLogDialog:ctor(delegate)
    PlunderLogDialog.super.ctor(self)

    self.delegate = delegate
    -- self.model = qy.tank.model.TaskModel
    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(886,610),   
        position = cc.p(0,0),
        offset = cc.p(0,0), 
        bgOpacity = 200,
        titleUrl = "Resources/common/title/plunder_log_title.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)
    style.title:setPosition(style.title:getPositionX(), style.title:getPositionY() - 3)
    self.bg = style.bg

    self.logData = qy.tank.model.MineModel:getLog()
    self.logList = self:createList()
    self.bg:addChild(self.logList)
end

function PlunderLogDialog:createList()
    tableView = cc.TableView:create(cc.size(844,555))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:setPosition(8,0)
    tableView:setDelegate()
    
    local function numberOfCellsInTableView(table)
        return #self.logData
    end
    
    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(table,idx) 
        return 844,145 
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.mine.PlunderLogCell.new()
            cell:addChild(item)
            cell.item = item

        end
        cell.item:render(self.logData[idx + 1])
        return cell
    end


    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()
    return tableView
end

return PlunderLogDialog