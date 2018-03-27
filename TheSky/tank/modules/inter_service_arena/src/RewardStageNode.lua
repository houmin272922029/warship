local RewardStageNode = qy.class("RewardStageNode", qy.tank.view.BaseView, "inter_service_arena.ui.RewardStageNode")

-- local model = qy.tank.model.SingleHeroModel
-- local service = qy.tank.service.SingleHeroService
function RewardStageNode:ctor(delegate)
   	RewardStageNode.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Text_day")
    self:InjectView("Text_hour")

    self.model = qy.tank.model.InterServiceArenaModel


    self.bg:addChild(self:createTable())
end



function RewardStageNode:createTable()
    local tableView = cc.TableView:create(cc.size(950, 470))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(5, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return 20 --自己所在分段 + 王者到青铜3共19个
    end

    local function cellSizeForTable(tableView,idx)
        if idx == 0 then
            return 950, 280
        else
            return 950, 120
        end
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if (nil == cell or cell.idx == 0) and idx ~= 0 then
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.RewardStageCell").new(self)
            cell:addChild(item)
            cell.item = item
            cell.idx = idx
        elseif idx == 0 then
            cell = nil
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.RewardStageCell_1").new(function()
                self:update()
            end)
            cell:addChild(item)
            cell.item = item
            cell.idx = idx
        end
        cell.item:render(idx == 0 and nil or self.model:getStageAwardByStage(idx), idx)

        return cell
    end

    local function tableAtTouched(table, cell)
        print(1)
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableView = tableView

    return tableView
end



function RewardStageNode:update()
    local point = self.tableView:getContentOffset()

    self.tableView:reloadData()

    self.tableView:setContentOffset(point) 
end




return RewardStageNode
