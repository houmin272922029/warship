local RewardsPreviewDialog = qy.tank.module.BaseUI.class(
    "RewardsPreviewDialog",
    "gold_bunker.ui.RewardsPreviewDialog",
    qy.tank.module.DialogExt
)

local Model = require("gold_bunker.src.Model")
local RewardsPreviewItem = require("gold_bunker.src.RewardsPreviewItem")

function RewardsPreviewDialog:ctor()
    RewardsPreviewDialog.super.ctor(self)

    self:createTableView()
end

function RewardsPreviewDialog:createTableView()
    local tableView = cc.TableView:create(cc.size(737, 519))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:addTo(self.ui.Image_2)

    local function numberOfCellsInTableView(tableView)
        return Model:getRewardCount()
    end

    local function cellSizeForTable(tableView, idx)
        return 737, idx == 0 and 260 or 235
    end

    local function tableCellAtIndex(tableView, idx)
        return (tableView:dequeueCell() or RewardsPreviewItem.new()):setIdx(idx)
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
end

return RewardsPreviewDialog
