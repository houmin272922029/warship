--[[

]]
local RewardPreviewDialog = qy.class("RewardPreviewDialog", qy.tank.view.BaseDialog, "yuri_engineer.ui.RewardPreviewDialog")

function RewardPreviewDialog:ctor(delegate)
    RewardPreviewDialog.super.ctor(self)

    self.model = qy.tank.model.YuriEngineerModel

    self:InjectView("bg")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(620,470),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "yuri_engineer/res/20_.png",
        bgShow = false,

        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style , 1)

    self.bg:addChild(self:__createList(), 1)

end




function RewardPreviewDialog:__createList()
    local tableView = cc.TableView:create(cc.size(600, 410))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(25, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.model.rank_award_list
    end

    local function cellSizeForTable(tableView,idx)
        return 550, 180
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("yuri_engineer.src.RewardPreviewCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self.model.rank_award_list[idx+1], idx+1)

        cell.item.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    self.tableView = tableView

    return tableView
end




return RewardPreviewDialog
