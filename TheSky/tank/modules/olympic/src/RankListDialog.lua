--[[
	总排行榜
	Author: Aaron Wei
	Date: 2016-09-26 10:55:09
]]


local RankListDialog = qy.class("RankListDialog", qy.tank.view.BaseDialog, "olympic.ui.RankListDialog")

function RankListDialog:ctor()
    RankListDialog.super.ctor(self)
	self:setCanceledOnTouchOutside(true)
	self.model = qy.tank.model.OlympicModel
     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(670,550),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "olympic/res/19.png",
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style, -1)

    self:InjectView("panel")
    self:InjectView("myRank")

    self.myRank:setString(tostring(self.model.my_rank))

    local tableView = cc.TableView:create(cc.size(600, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-200, -120)
    self.panel:addChild(tableView)

    local function numberOfCellsInTableView(tableView)
        return #self.model.rank_list
    end

    local function cellSizeForTable(tableView, idx)
        return 600, 45
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("olympic.src.RankListCell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.rank_list[idx+1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()
end

function RankListDialog:onEnter()

end

return RankListDialog
