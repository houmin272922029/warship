local LeaderboardDialog = qy.tank.module.BaseUI.class(
    "LeaderboardDialog",
    "singlehero.ui.LeaderboardDialog",
    qy.tank.module.DialogExt
)

local LeaderboardItem = require("singlehero.src.LeaderboardItem")
local model = qy.tank.model.SingleHeroModel
function LeaderboardDialog:ctor()
    LeaderboardDialog.super.ctor(self)
    self:setData()
end

function LeaderboardDialog:setData()
    self.ui.myrank:setString(myrank == 0 and qy.TextUtil:substitute(62006) or model.myrank)
    self.ui.mylevel:setString(qy.TextUtil:substitute(62007) .. model.current .. " ".. qy.TextUtil:substitute(67012))

    -- self.ui.update_time:setPositionX(self.ui.myrank:getContentSize().width + self.ui.myrank:getPositionX() + 10)

    local tableView = cc.TableView:create(cc.size(737, 450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:addTo(self.ui.Image_2)

    local count = #model.ranklist
    local function numberOfCellsInTableView(tableView)
        return count
    end

    local function cellSizeForTable(tableView, idx)
        return 737, idx == 0 and 145 or 135
    end

    local function tableCellAtIndex(tableView, idx)
        return (tableView:dequeueCell() or LeaderboardItem.new()):setRank(model.ranklist[idx + 1])
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()

    return self
end

return LeaderboardDialog
