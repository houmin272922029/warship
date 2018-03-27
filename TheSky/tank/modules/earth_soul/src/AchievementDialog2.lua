local AchievementDialog = qy.class("AchievementDialog", qy.tank.view.BaseView, "earth_soul.ui.AchievementDialog")

local model = qy.tank.model.OperatingActivitiesModel
function AchievementDialog:ctor(delegate)
   	AchievementDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("Times")
    -- self:InjectView("Attack")

    self.BG:addChild(self:createView())
    self.Times:setString(qy.TextUtil:substitute(45001) .. model.earthSoulTotalTimes .. qy.TextUtil:substitute(45005))
end

function AchievementDialog:createView()
    local tableView = cc.TableView:create(cc.size(950, 465))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(10, 5)

    local data = qy.Config.earth_soul_achieve
    local function numberOfCellsInTableView(tableView)
        return table.nums(data)
    end

    local function cellSizeForTable(tableView,idx)
        return 950, 160
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("earth_soul.src.ItemView").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(data[tostring(idx + 1)], idx)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    return tableView
end

return AchievementDialog
