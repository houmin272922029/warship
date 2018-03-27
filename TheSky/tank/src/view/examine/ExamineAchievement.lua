--[[
	查看成就
	Author: Aaron Wei
	Date: 2015-09-09 20:45:55
]]

local ExamineAchievement = qy.class("ExamineAchievement", qy.tank.view.BaseView, "view/examine/ExamineAchievement")

function ExamineAchievement:ctor()
	self:InjectView("panel")
    self.model = qy.tank.model.ExamineModel
	-- local layer = cc.LayerColor:create(cc.c4b(0,255,255,125))

    local tableView = cc.TableView:create(cc.size(860,310))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-320,-200)
    -- tableView:addChild(layer)
    tableView:setDelegate()
    self.panel:addChild(tableView)

    local function numberOfCellsInTableView(table)
    	return #self.model.achieve
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 800, 105
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.examine.ExamineAchievementCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.achieve[idx+1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
end
	
return ExamineAchievement
