--[[
    战争图卷
    2016年07月26日17:42:39
]]
local RankDialog = qy.class("RankDialog", qy.tank.view.BaseDialog, "activity_2048/ui/RankDialog")

local model = qy.tank.model.Activity2048Model
local service = qy.tank.service.Activity2048Service
function RankDialog:ctor(delegate)
    RankDialog.super.ctor(self)

    self:InjectView("bg")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(600,500),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/ranking_title.png",


        ["onClose"] = function()
            self:removeSelf()
        end
    })


    self:addChild(self.style , -1)

    self.bg:addChild(self:__createList(), 1)



end




function RankDialog:__createList()
    local tableView = cc.TableView:create(cc.size(574, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-287, -210)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #model.rank_list
    end

    local function cellSizeForTable(tableView,idx)
        return 574, 50
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("activity_2048.src.RankCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(model.rank_list[idx + 1], idx + 1)

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

    return tableView
end




return RankDialog
