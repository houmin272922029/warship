local LeaderboardDialog = qy.tank.module.BaseUI.class(
    "LeaderboardDialog",
    "gold_bunker.ui.LeaderboardDialog",
    qy.tank.module.DialogExt
)

local LeaderboardItem = require("gold_bunker.src.LeaderboardItem")

function LeaderboardDialog:ctor()
    LeaderboardDialog.super.ctor(self)
end

function LeaderboardDialog:setData(myrank, ranklist, level)
    self.ui.myrank:setString(myrank == 0 and qy.TextUtil:substitute(46010) or myrank)
    self.ui.mylevel:setString(qy.TextUtil:substitute(46011) .. level .. " ".. qy.TextUtil:substitute(46009))

    if qy.language == "cn" then 
        self.ui.update_time:setPositionX(self.ui.myrank:getContentSize().width + self.ui.myrank:getPositionX() + 10)
    end

    local tableView = cc.TableView:create(cc.size(737, 450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:addTo(self.ui.Image_2)

    local count = #ranklist
    local function numberOfCellsInTableView(tableView)
        return count
    end

    local function cellSizeForTable(tableView, idx)
        return 737, idx == 0 and 145 or 135
    end

    local function tableCellAtIndex(tableView, idx)
        return (tableView:dequeueCell() or LeaderboardItem.new()):setRank(ranklist[idx + 1])
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()

    return self
end

return LeaderboardDialog
